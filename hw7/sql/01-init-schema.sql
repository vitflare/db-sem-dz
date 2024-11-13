create table if not exists countries
(
    name       char(40),
    country_id char(3)
        unique,
    area_sqkm  integer,
    population integer
);

create table if not exists olympics
(
    olympic_id char(7)
        unique,
    country_id char(3)
        references countries (country_id),
    city       char(50),
    year       integer,
    startdate  date,
    enddate    date
);

create table if not exists players
(
    name       char(40),
    player_id  char(10)
        unique,
    country_id char(3)
        references countries (country_id),
    birthdate  date
);

create table if not exists events
(
    event_id            char(7)
        unique,
    name                char(40),
    eventtype           char(20),
    olympic_id          char(7)
        references olympics (olympic_id),
    is_team_event       integer
        constraint events_is_team_event_check
            check (is_team_event = ANY (ARRAY [0, 1])),
    num_players_in_team integer,
    result_noted_in     char(100)
);

create table if not exists results
(
    event_id  char(7)
        references events (event_id),
    player_id char(10)
        references players (player_id),
    medal     char(7),
    result    double precision
);
