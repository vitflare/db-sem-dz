## Поднятие базы данных
```
docker-compose up -d
```
## Миграции
Миграции выполнены на языке PostgreSQL и накатаны с помощью терминальной утилиты psql ([запросы см. тут](https://github.com/vitflare/db-sem-dz/tree/main/hw7/sql))
### Установка psql
<details>
  <summary>Установка на MacOS</summary>

```shell
brew install libpq
brew link --force libpq
```
</details>

<details>
  <summary>Установка на Ubuntu</summary>

```shell
sudo apt-get update
sudo apt-get install postgresql-client
```
</details>

<details>
  <summary>Установка на Windows</summary>

```shell
choco install postgresql
```
</details>

Полный гайд [см. тут](https://www.timescale.com/blog/how-to-install-psql-on-mac-ubuntu-debian-windows/)

### Мигрируем схему данных
```
psql -h localhost -p 5432 -U superadmin -d olimp -a -f sql/01-init-schema.sql 
Password for user superadmin: 
```
### Сидим данные
```
psql -h localhost -p 5432 -U superadmin -d olimp -a -f sql/02-seed-data.sql  
Password for user superadmin: 
```
### Наполняем таблицу данными
```
psql -h localhost -p 5432 -U superadmin -d olimp -a -f sql/03-populate-data.sql
Password for user superadmin: 
```

## Запросы
Запросы выполнены на языке C# с использованием фреймворка EF Core ([код см. тут](https://github.com/vitflare/db-sem-dz/blob/main/hw7/hw_db_7/hw_db_7/Program.cs))

Вывод приложения:
```
1. Статистика по годам рождения (2004):
Год: 1975, Игроков: 7, Золотых медалей: 14
Год: 1976, Игроков: 4, Золотых медалей: 7
Год: 1977, Игроков: 7, Золотых медалей: 17
Год: 1978, Игроков: 5, Золотых медалей: 14
Год: 1979, Игроков: 11, Золотых медалей: 20
Год: 1980, Игроков: 13, Золотых медалей: 83
Год: 1981, Игроков: 9, Золотых медалей: 75
Год: 1982, Игроков: 7, Золотых медалей: 43
Год: 1983, Игроков: 8, Золотых медалей: 57
Год: 1984, Игроков: 10, Золотых медалей: 74
Год: 1985, Игроков: 5, Золотых медалей: 39
Год: 1986, Игроков: 8, Золотых медалей: 13
Год: 1987, Игроков: 6, Золотых медалей: 11
Год: 1988, Игроков: 6, Золотых медалей: 10
Год: 1989, Игроков: 4, Золотых медалей: 9
Год: 1990, Игроков: 11, Золотых медалей: 20
Год: 1991, Игроков: 7, Золотых медалей: 14
Год: 1992, Игроков: 6, Золотых медалей: 12
Год: 1993, Игроков: 5, Золотых медалей: 8
Год: 1994, Игроков: 5, Золотых медалей: 9
Год: 1995, Игроков: 5, Золотых медалей: 14
Год: 1996, Игроков: 3, Золотых медалей: 8
Год: 1997, Игроков: 8, Золотых медалей: 23
Год: 1998, Игроков: 6, Золотых медалей: 11
Год: 1999, Игроков: 9, Золотых медалей: 25

2. Индивидуальные соревнования с ничьей:
ID события: E0002  
ID события: E0005  
ID события: E0007  
ID события: E0008  
ID события: E0009  
ID события: E0010  
ID события: E0011  
ID события: E0012  
ID события: E0013  
ID события: E0014  
ID события: E0015  
ID события: E0016  
ID события: E0018  
ID события: E0020  
ID события: E0022  
ID события: E0023  
ID события: E0025  
ID события: E0026  
ID события: E0029  
ID события: E0030  
ID события: E0033  
ID события: E0034  
ID события: E0036  
ID события: E0037  
ID события: E0040  
ID события: E0041  
ID события: E0042  
ID события: E0043  
ID события: E0045  
ID события: E0047  
ID события: E0048  

3. Медалисты по Олимпиадам:
Игрок: Elena Brown                             , Олимпиада: 2000SUM
Игрок: Bob Johnson                             , Олимпиада: 2004SUM
Игрок: Ian Wilson                              , Олимпиада: 2004SUM
Игрок: Emma Wilson                             , Олимпиада: 2000SUM
Игрок: Charlie Anderson                        , Олимпиада: 2000SUM
Игрок: Anna Taylor                             , Олимпиада: 2000SUM
Игрок: Elena Wilson                            , Олимпиада: 2004SUM
Игрок: David Anderson                          , Олимпиада: 2004SUM
Игрок: Emma Anderson                           , Олимпиада: 2004SUM
Игрок: Ian Johnson                             , Олимпиада: 2000SUM
Игрок: Oliver Taylor                           , Олимпиада: 2004SUM
Игрок: Oliver Moore                            , Олимпиада: 2000SUM
Игрок: Oliver Anderson                         , Олимпиада: 2000SUM
Игрок: Adam Taylor                             , Олимпиада: 2004SUM
Игрок: Emma Johnson                            , Олимпиада: 2004SUM
Игрок: Oliver Johnson                          , Олимпиада: 2000SUM
Игрок: David Smith                             , Олимпиада: 2000SUM
Игрок: Adam Martin                             , Олимпиада: 2000SUM
Игрок: Ian Anderson                            , Олимпиада: 2000SUM
Игрок: David Johnson                           , Олимпиада: 2004SUM
Игрок: Elena Davis                             , Олимпиада: 2004SUM
Игрок: Emma Smith                              , Олимпиада: 2000SUM
Игрок: Charlie Wilson                          , Олимпиада: 2000SUM
Игрок: Oliver Davis                            , Олимпиада: 2000SUM
Игрок: Charlie Johnson                         , Олимпиада: 2000SUM
Игрок: Oliver Wilson                           , Олимпиада: 2000SUM
Игрок: David Davis                             , Олимпиада: 2000SUM
Игрок: Charlie Martin                          , Олимпиада: 2000SUM
Игрок: Adam Davis                              , Олимпиада: 2004SUM
Игрок: Oliver Taylor                           , Олимпиада: 2000SUM
Игрок: Charlie Brown                           , Олимпиада: 2004SUM
Игрок: Emma Davis                              , Олимпиада: 2004SUM
Игрок: Emma Anderson                           , Олимпиада: 2000SUM
Игрок: Emma Davis                              , Олимпиада: 2000SUM
Игрок: Oliver Brown                            , Олимпиада: 2000SUM
Игрок: Bob Smith                               , Олимпиада: 2004SUM
Игрок: Anna Johnson                            , Олимпиада: 2004SUM
Игрок: Adam Thomas                             , Олимпиада: 2000SUM
Игрок: Emma Taylor                             , Олимпиада: 2000SUM
Игрок: Bob Moore                               , Олимпиада: 2000SUM
Игрок: Adam Johnson                            , Олимпиада: 2004SUM
Игрок: Frank Wilson                            , Олимпиада: 2000SUM
Игрок: Frank Brown                             , Олимпиада: 2004SUM
Игрок: Anna Davis                              , Олимпиада: 2000SUM
Игрок: Elena Taylor                            , Олимпиада: 2004SUM
Игрок: Frank Moore                             , Олимпиада: 2000SUM
Игрок: Adam Johnson                            , Олимпиада: 2000SUM
Игрок: David Johnson                           , Олимпиада: 2000SUM
Игрок: Emma Brown                              , Олимпиада: 2004SUM
Игрок: Oliver Wilson                           , Олимпиада: 2004SUM
Игрок: Bob Davis                               , Олимпиада: 2004SUM
Игрок: Anna Brown                              , Олимпиада: 2000SUM
Игрок: Adam Taylor                             , Олимпиада: 2000SUM
Игрок: Oliver Martin                           , Олимпиада: 2000SUM
Игрок: Elena Moore                             , Олимпиада: 2000SUM
Игрок: Oliver Brown                            , Олимпиада: 2004SUM
Игрок: Elena Brown                             , Олимпиада: 2004SUM
Игрок: Oliver Anderson                         , Олимпиада: 2004SUM
Игрок: Ian Taylor                              , Олимпиада: 2000SUM
Игрок: Bob Martin                              , Олимпиада: 2000SUM
Игрок: Oliver Johnson                          , Олимпиада: 2004SUM
Игрок: David Taylor                            , Олимпиада: 2000SUM
Игрок: Charlie Davis                           , Олимпиада: 2004SUM
Игрок: Anna Moore                              , Олимпиада: 2000SUM
Игрок: Frank Martin                            , Олимпиада: 2000SUM
Игрок: Bob Johnson                             , Олимпиада: 2000SUM
Игрок: Oliver Thomas                           , Олимпиада: 2004SUM
Игрок: Charlie Anderson                        , Олимпиада: 2004SUM
Игрок: Frank Martin                            , Олимпиада: 2004SUM
Игрок: Anna Johnson                            , Олимпиада: 2000SUM
Игрок: David Wilson                            , Олимпиада: 2004SUM
Игрок: Charlie Johnson                         , Олимпиада: 2004SUM
Игрок: Frank Johnson                           , Олимпиада: 2000SUM
Игрок: Frank Johnson                           , Олимпиада: 2004SUM
Игрок: Emma Thomas                             , Олимпиада: 2004SUM
Игрок: Anna Smith                              , Олимпиада: 2004SUM
Игрок: David Davis                             , Олимпиада: 2004SUM
Игрок: Anna Anderson                           , Олимпиада: 2004SUM
Игрок: Emma Thomas                             , Олимпиада: 2000SUM
Игрок: Charlie Wilson                          , Олимпиада: 2004SUM
Игрок: Anna Moore                              , Олимпиада: 2004SUM
Игрок: Frank Brown                             , Олимпиада: 2000SUM
Игрок: Bob Smith                               , Олимпиада: 2000SUM
Игрок: Bob Martin                              , Олимпиада: 2004SUM
Игрок: Ian Davis                               , Олимпиада: 2000SUM
Игрок: David Brown                             , Олимпиада: 2004SUM
Игрок: Elena Wilson                            , Олимпиада: 2000SUM
Игрок: Bob Thomas                              , Олимпиада: 2004SUM
Игрок: Elena Thomas                            , Олимпиада: 2000SUM
Игрок: Charlie Brown                           , Олимпиада: 2000SUM
Игрок: Emma Taylor                             , Олимпиада: 2004SUM
Игрок: Ian Johnson                             , Олимпиада: 2004SUM
Игрок: Emma Smith                              , Олимпиада: 2004SUM
Игрок: Frank Davis                             , Олимпиада: 2000SUM
Игрок: Anna Thomas                             , Олимпиада: 2004SUM
Игрок: Bob Taylor                              , Олимпиада: 2004SUM
Игрок: Ian Thomas                              , Олимпиада: 2004SUM
Игрок: Emma Wilson                             , Олимпиада: 2004SUM
Игрок: Elena Taylor                            , Олимпиада: 2000SUM
Игрок: Charlie Martin                          , Олимпиада: 2004SUM
Игрок: Frank Davis                             , Олимпиада: 2004SUM
Игрок: Emma Moore                              , Олимпиада: 2000SUM
Игрок: Oliver Moore                            , Олимпиада: 2004SUM
Игрок: Emma Martin                             , Олимпиада: 2004SUM
Игрок: Adam Anderson                           , Олимпиада: 2000SUM
Игрок: Oliver Davis                            , Олимпиада: 2004SUM
Игрок: Elena Smith                             , Олимпиада: 2000SUM
Игрок: Frank Anderson                          , Олимпиада: 2004SUM
Игрок: Adam Wilson                             , Олимпиада: 2004SUM
Игрок: Ian Taylor                              , Олимпиада: 2004SUM
Игрок: Charlie Taylor                          , Олимпиада: 2000SUM
Игрок: Ian Smith                               , Олимпиада: 2004SUM
Игрок: Oliver Martin                           , Олимпиада: 2004SUM
Игрок: Ian Davis                               , Олимпиада: 2004SUM
Игрок: Elena Martin                            , Олимпиада: 2000SUM
Игрок: David Taylor                            , Олимпиада: 2004SUM
Игрок: Charlie Smith                           , Олимпиада: 2000SUM
Игрок: David Moore                             , Олимпиада: 2000SUM
Игрок: Emma Martin                             , Олимпиада: 2000SUM
Игрок: Bob Davis                               , Олимпиада: 2000SUM
Игрок: Anna Brown                              , Олимпиада: 2004SUM
Игрок: Oliver Thomas                           , Олимпиада: 2000SUM
Игрок: Frank Wilson                            , Олимпиада: 2004SUM
Игрок: Emma Johnson                            , Олимпиада: 2000SUM
Игрок: Frank Smith                             , Олимпиада: 2004SUM
Игрок: Elena Martin                            , Олимпиада: 2004SUM
Игрок: Bob Wilson                              , Олимпиада: 2000SUM
Игрок: Frank Moore                             , Олимпиада: 2004SUM
Игрок: Ian Martin                              , Олимпиада: 2000SUM
Игрок: Adam Brown                              , Олимпиада: 2004SUM
Игрок: Anna Wilson                             , Олимпиада: 2000SUM
Игрок: Anna Smith                              , Олимпиада: 2000SUM
Игрок: Anna Wilson                             , Олимпиада: 2004SUM
Игрок: Anna Thomas                             , Олимпиада: 2000SUM
Игрок: Frank Thomas                            , Олимпиада: 2000SUM
Игрок: Elena Smith                             , Олимпиада: 2004SUM
Игрок: David Anderson                          , Олимпиада: 2000SUM
Игрок: David Brown                             , Олимпиада: 2000SUM
Игрок: Bob Brown                               , Олимпиада: 2004SUM
Игрок: Ian Wilson                              , Олимпиада: 2000SUM
Игрок: Ian Smith                               , Олимпиада: 2000SUM
Игрок: Adam Anderson                           , Олимпиада: 2004SUM
Игрок: Frank Taylor                            , Олимпиада: 2000SUM
Игрок: David Smith                             , Олимпиада: 2004SUM
Игрок: Charlie Taylor                          , Олимпиада: 2004SUM
Игрок: Bob Thomas                              , Олимпиада: 2000SUM
Игрок: Bob Brown                               , Олимпиада: 2000SUM
Игрок: Adam Davis                              , Олимпиада: 2000SUM
Игрок: Charlie Davis                           , Олимпиада: 2000SUM
Игрок: Elena Moore                             , Олимпиада: 2004SUM
Игрок: Anna Taylor                             , Олимпиада: 2004SUM
Игрок: Bob Wilson                              , Олимпиада: 2004SUM
Игрок: Elena Anderson                          , Олимпиада: 2004SUM
Игрок: Adam Martin                             , Олимпиада: 2004SUM
Игрок: Adam Thomas                             , Олимпиада: 2004SUM
Игрок: Ian Anderson                            , Олимпиада: 2004SUM
Игрок: Elena Anderson                          , Олимпиада: 2000SUM
Игрок: Frank Smith                             , Олимпиада: 2000SUM
Игрок: Charlie Thomas                          , Олимпиада: 2000SUM
Игрок: Ian Martin                              , Олимпиада: 2004SUM
Игрок: Bob Taylor                              , Олимпиада: 2000SUM
Игрок: Frank Thomas                            , Олимпиада: 2004SUM
Игрок: Adam Smith                              , Олимпиада: 2000SUM
Игрок: Anna Davis                              , Олимпиада: 2004SUM
Игрок: Frank Anderson                          , Олимпиада: 2000SUM
Игрок: Emma Moore                              , Олимпиада: 2004SUM
Игрок: David Wilson                            , Олимпиада: 2000SUM
Игрок: Adam Smith                              , Олимпиада: 2004SUM
Игрок: Elena Thomas                            , Олимпиада: 2004SUM
Игрок: Emma Brown                              , Олимпиада: 2000SUM
Игрок: Elena Davis                             , Олимпиада: 2000SUM
Игрок: Charlie Smith                           , Олимпиада: 2004SUM
Игрок: Frank Taylor                            , Олимпиада: 2004SUM
Игрок: Ian Thomas                              , Олимпиада: 2000SUM
Игрок: David Moore                             , Олимпиада: 2004SUM
Игрок: Bob Moore                               , Олимпиада: 2004SUM
Игрок: Adam Brown                              , Олимпиада: 2000SUM
Игрок: Anna Anderson                           , Олимпиада: 2000SUM
Игрок: Charlie Thomas                          , Олимпиада: 2004SUM
Игрок: Adam Wilson                             , Олимпиада: 2000SUM

4. Страна с наибольшим процентом игроков с гласной:
Страна: Finland                                 , Процент: 64,00%

5. Топ-5 стран с минимальным соотношением медалей к населению (2000):
Страна: Finland                                 , Соотношение: 2,206689E-005
```
