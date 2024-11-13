using System;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;

namespace hw_db_7;

public class OlympicsContext : DbContext
{
    public DbSet<DbCountry> Countries { get; set; }
    public DbSet<DbOlympics> Olympics { get; set; }
    public DbSet<DbPlayer> Players { get; set; }
    public DbSet<DbEvent> Events { get; set; }
    public DbSet<DbResult> Results { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Configure table names to match PostgreSQL
        modelBuilder.Entity<DbCountry>().ToTable("countries");
        modelBuilder.Entity<DbOlympics>().ToTable("olympics");
        modelBuilder.Entity<DbPlayer>().ToTable("players");
        modelBuilder.Entity<DbEvent>().ToTable("events");
        modelBuilder.Entity<DbResult>().ToTable("results");

        // Configure composite key for Results
        modelBuilder.Entity<DbResult>()
            .HasKey(r => new { r.EventId, r.PlayerId });

        // Configure relationships
        modelBuilder.Entity<DbResult>()
            .HasOne(r => r.Event)
            .WithMany(e => e.Results)
            .HasForeignKey(r => r.EventId);

        modelBuilder.Entity<DbResult>()
            .HasOne(r => r.Player)
            .WithMany(p => p.Results)
            .HasForeignKey(r => r.PlayerId);

        modelBuilder.Entity<DbEvent>()
            .HasOne(e => e.Olympics)
            .WithMany(o => o.Events)
            .HasForeignKey(e => e.OlympicId);

        // Configure column names to match PostgreSQL
        modelBuilder.Entity<DbCountry>()
            .Property(c => c.CountryId).HasColumnName("country_id");
        modelBuilder.Entity<DbCountry>()
            .Property(c => c.Name).HasColumnName("name");
        modelBuilder.Entity<DbCountry>()
            .Property(c => c.Population).HasColumnName("population");

        modelBuilder.Entity<DbOlympics>()
            .Property(o => o.OlympicId).HasColumnName("olympic_id");
        modelBuilder.Entity<DbOlympics>()
            .Property(o => o.CountryId).HasColumnName("country_id");
        modelBuilder.Entity<DbOlympics>()
            .Property(o => o.StartDate).HasColumnName("startdate");
        modelBuilder.Entity<DbOlympics>()
            .Property(o => o.EndDate).HasColumnName("enddate");
        modelBuilder.Entity<DbOlympics>()
            .Property(o => o.Year).HasColumnName("year");

        modelBuilder.Entity<DbPlayer>()
            .Property(p => p.PlayerId).HasColumnName("player_id");
        modelBuilder.Entity<DbPlayer>()
            .Property(p => p.Name).HasColumnName("name");
        modelBuilder.Entity<DbPlayer>()
            .Property(p => p.CountryId).HasColumnName("country_id");
        modelBuilder.Entity<DbPlayer>()
            .Property(p => p.Birthdate).HasColumnName("birthdate");

        modelBuilder.Entity<DbEvent>()
            .Property(e => e.EventId).HasColumnName("event_id");
        modelBuilder.Entity<DbEvent>()
            .Property(e => e.EventType).HasColumnName("eventtype");
        modelBuilder.Entity<DbEvent>()
            .Property(e => e.OlympicId).HasColumnName("olympic_id");
        modelBuilder.Entity<DbEvent>()
            .Property(e => e.IsTeamEvent).HasColumnName("is_team_event");
        modelBuilder.Entity<DbEvent>()
            .Property(e => e.NumPlayersInTeam).HasColumnName("num_players_in_team");
        modelBuilder.Entity<DbEvent>()
            .Property(p => p.Name).HasColumnName("name");
        modelBuilder.Entity<DbEvent>()
            .Property(e => e.ResultNotedIn).HasColumnName("result_noted_in");

        modelBuilder.Entity<DbResult>()
            .Property(r => r.EventId).HasColumnName("event_id");
        modelBuilder.Entity<DbResult>()
            .Property(r => r.PlayerId).HasColumnName("player_id");
        modelBuilder.Entity<DbResult>()
            .Property(r => r.Medal).HasColumnName("medal");
    }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseNpgsql("Host=localhost;Database=olimp;Username=superadmin;Password=superadmin");
    }
}

public class DbCountry
{
    [Key] [StringLength(3)] public string CountryId { get; set; }
    [StringLength(40)] public string Name { get; set; }
    public int AreaSqkm { get; set; }
    public int Population { get; set; }
    public virtual ICollection<DbPlayer> Players { get; set; }
}

public class DbOlympics
{
    [Key] [StringLength(7)] public string OlympicId { get; set; }
    [StringLength(3)] public string CountryId { get; set; }

    [StringLength(50)] public string City { get; set; }
    public int Year { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public virtual ICollection<DbEvent> Events { get; set; }
}

public class DbPlayer
{
    [Key] [StringLength(10)] public string PlayerId { get; set; }
    [StringLength(40)] public string Name { get; set; }
    [StringLength(3)] public string CountryId { get; set; }
    public DateTime Birthdate { get; set; }
    public virtual DbCountry Country { get; set; }
    public virtual ICollection<DbResult> Results { get; set; }
}

public class DbEvent
{
    [Key] [StringLength(7)] public string EventId { get; set; }
    [StringLength(40)] public string Name { get; set; }
    [StringLength(20)] public string EventType { get; set; }
    [StringLength(7)] public string OlympicId { get; set; }
    public int IsTeamEvent { get; set; }
    public int? NumPlayersInTeam { get; set; }
    [StringLength(100)] public string ResultNotedIn { get; set; }
    public virtual DbOlympics Olympics { get; set; }
    public virtual ICollection<DbResult> Results { get; set; }
}

public class DbResult
{
    [Key] public string EventId { get; set; }
    [Key] public string PlayerId { get; set; }
    public string Medal { get; set; }
    public double Result { get; set; }
    public virtual DbEvent Event { get; set; }
    public virtual DbPlayer Player { get; set; }
}

public class Program
{
    static void Main(string[] args)
    {
        using (var context = new OlympicsContext())
        {
            // 1. Олимпийские игры 2004
            var olympicId2004 = context.Olympics
                .Where(o => o.Year == 2004)
                .Select(o => o.OlympicId)
                .FirstOrDefault();

            var playerBirthYearStats = context.Results
                .Include(r => r.Event)
                .Include(r => r.Player)
                .Where(r => r.Medal == "GOLD" && r.Event.OlympicId == olympicId2004)
                .GroupBy(r => r.Player.Birthdate.Year)
                .Select(g => new
                {
                    BirthYear = g.Key,
                    PlayerCount = g.Select(r => r.PlayerId).Distinct().Count(),
                    GoldMedalCount = g.Count()
                })
                .OrderBy(s => s.BirthYear)
                .ToList();

            // 2. Индивидуальные соревнования с ничьей
            var tiedIndividualEvents = context.Events
                .Include(e => e.Results)
                .Where(e => e.IsTeamEvent == 0)
                .Where(e => e.Results.Count(r => r.Medal == "GOLD") >= 2)
                .Select(e => e.EventId)
                .ToList();

            // 3. Медалисты
            var medalistsByOlympiad = context.Results
                .Include(r => r.Event)
                .Include(r => r.Player)
                .Where(r => new[] { "GOLD", "SILVER", "BRONZE" }.Contains(r.Medal))
                .Select(r => new
                {
                    PlayerName = r.Player.Name,
                    OlympicId = r.Event.OlympicId
                })
                .Distinct()
                .ToList();

            // 4. Страна с наибольшим процентом игроков с гласной
            var playersByCountry = context.Countries
                .Include(c => c.Players)
                .Select(c => new
                {
                    CountryId = c.CountryId,
                    CountryName = c.Name,
                    PlayerCount = c.Players.Count(),
                    VowelPlayerCount = c.Players.Count(p =>
                        p.Name.StartsWith("A") ||
                        p.Name.StartsWith("E") ||
                        p.Name.StartsWith("I") ||
                        p.Name.StartsWith("O") ||
                        p.Name.StartsWith("U") ||
                        p.Name.StartsWith("a") ||
                        p.Name.StartsWith("e") ||
                        p.Name.StartsWith("i") ||
                        p.Name.StartsWith("o") ||
                        p.Name.StartsWith("u"))
                })
                .Where(x => x.PlayerCount > 0)
                .OrderByDescending(p => (double)p.VowelPlayerCount / p.PlayerCount)
                .FirstOrDefault();

            // 5. Страны с минимальным соотношением медалей к населению
            var olympicId2000 = context.Olympics
                .Where(o => o.Year == 2000)
                .Select(o => o.OlympicId)
                .FirstOrDefault();

            var teamMedalsByCountry = context.Countries
                .Include(c => c.Players)
                .ThenInclude(p => p.Results)
                .ThenInclude(r => r.Event)
                .Select(c => new
                {
                    CountryId = c.CountryId,
                    CountryName = c.Name,
                    TeamMedalCount = c.Players
                        .SelectMany(p => p.Results)
                        .Count(r => r.Medal != null &&
                                    r.Event.IsTeamEvent == 1 &&
                                    r.Event.OlympicId == olympicId2000),
                    Population = c.Population
                })
                .Where(x => x.TeamMedalCount > 0)
                .OrderBy(c => (double)c.TeamMedalCount / c.Population)
                .Take(5)
                .ToList();

            // Вывод результатов
            Console.WriteLine("1. Статистика по годам рождения (2004):");
            foreach (var stat in playerBirthYearStats)
            {
                Console.WriteLine(
                    $"Год: {stat.BirthYear}, Игроков: {stat.PlayerCount}, Золотых медалей: {stat.GoldMedalCount}");
            }

            Console.WriteLine("\n2. Индивидуальные соревнования с ничьей:");
            foreach (var eventId in tiedIndividualEvents)
            {
                Console.WriteLine($"ID события: {eventId}");
            }

            Console.WriteLine("\n3. Медалисты по Олимпиадам:");
            foreach (var medalist in medalistsByOlympiad)
            {
                Console.WriteLine($"Игрок: {medalist.PlayerName}, Олимпиада: {medalist.OlympicId}");
            }

            Console.WriteLine("\n4. Страна с наибольшим процентом игроков с гласной:");
            if (playersByCountry != null)
            {
                Console.WriteLine($"Страна: {playersByCountry.CountryName}, " +
                                  $"Процент: {(double)playersByCountry.VowelPlayerCount / playersByCountry.PlayerCount * 100:F2}%");
            }
            else
            {
                Console.WriteLine("No matching countries found.");
            }

            Console.WriteLine("\n5. Топ-5 стран с минимальным соотношением медалей к населению (2000):");
            foreach (var country in teamMedalsByCountry)
            {
                Console.WriteLine(
                    $"Страна: {country.CountryName}, Соотношение: {(double)country.TeamMedalCount / country.Population:E}");
            }
        }
    }
}