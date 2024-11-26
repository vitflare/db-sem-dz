# ДЗ 9
### Шиверских Елизавета Анатольевна БПИ223

## Поднятие базы данных
```
docker-compose up -d
```
### Задание 1
Создание и заполнение таблицы:
```
CREATE TABLE IF NOT EXISTS demographics (
    id SERIAL PRIMARY KEY
    , name VARCHAR(100)
    , birthday DATE
    , race VARCHAR(100)
);

INSERT INTO demographics (name, birthday, race) VALUES
('John Doe', '1990-05-15', 'Caucasian')
, ('Jane Smith', '1985-07-22', 'African American')
, ('Mike Johnson', '1992-11-30', 'Hispanic');
```
Запрос:
```
SELECT
    LENGTH(name) + LENGTH(race) AS calculation
FROM demographics;
```
Результат:

![pic](https://github.com/vitflare/db-sem-dz/blob/main/hw9/pic/1.png)

### Задание 2
Используется та же таблица demographics

Запрос:
```
SELECT
    id
    , BIT_LENGTH(name) AS name
    , birthday
    , BIT_LENGTH(race) AS race
FROM demographics;
```
Результат:

![pic](https://github.com/vitflare/db-sem-dz/blob/main/hw9/pic/2.png)

### Задание 3
Используется та же таблица demographics

Запрос:
```
SELECT
    id
    , ASCII(name) AS name
    , birthday
    , ASCII(race) AS race
FROM demographics;
```
Результат:

![pic](https://github.com/vitflare/db-sem-dz/blob/main/hw9/pic/3.png)

### Задание 4
Создание и заполнение таблицы:
```
CREATE TABLE IF NOT EXISTS names (
    id SERIAL PRIMARY KEY
    , prefix VARCHAR(50)
    , first VARCHAR(100)
    , last VARCHAR(100)
    , suffix VARCHAR(50)
);

INSERT INTO names (prefix, first, last, suffix) VALUES
('Dr.', 'John', 'Doe', 'Jr.')
, ('Mr.', 'Mike', 'Smith', NULL)
, (NULL, 'Sarah', 'Johnson', 'PhD');
```
Запрос:
```
SELECT
    CONCAT_WS(' ', prefix, first, last, suffix) AS title
FROM names;
```
Результат:

![pic](https://github.com/vitflare/db-sem-dz/blob/main/hw9/pic/4.png)

### Задание 5
Создание и заполнение таблицы:
```
CREATE TABLE IF NOT EXISTS encryption (
    md5 VARCHAR(32)
    , sha1 VARCHAR(40)
    , sha256 VARCHAR(64)
);

INSERT INTO encryption (md5, sha1, sha256) VALUES
('abc123', 'def456', 'ghi789xyz123456')
, ('123abc', '456def', '789xyzabc123456');
```
Запрос:
```
SELECT
    md5 || REPEAT('1', LENGTH(sha256) - LENGTH(md5)) AS md5
    , REPEAT('0', LENGTH(sha256) - LENGTH(sha1)) || sha1 AS sha1
    , sha256
FROM encryption;
```
Результат:

![pic](https://github.com/vitflare/db-sem-dz/blob/main/hw9/pic/5.png)

### Задание 6
Создание и заполнение таблицы:
```
CREATE TABLE IF NOT EXISTS repositories (
    project VARCHAR(100)
    , commits INT
    , contributors INT
    , address VARCHAR(200)
);

INSERT INTO repositories (project, commits, contributors, address) VALUES
('Bitcoin', 50, 5, 'bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq')
, ('Ethereum', 30, 3, 'eth1x5f3a7c2b1d9e8f4g5h6j7k8l9m0n')
, ('Litecoin', 20, 4, 'ltc1q5d4x3c2b1a9z8y7x6w5v4u3t2s1');
```
Запрос:
```
SELECT
    LEFT(project, commits) AS project
    , RIGHT(address, contributors) AS address
FROM repositories;
```
Результат:

![pic](https://github.com/vitflare/db-sem-dz/blob/main/hw9/pic/6.png)

### Задание 7
Используется та же таблица repositories

Запрос:
```
SELECT
    project
    , commits
    , contributors
    , REGEXP_REPLACE(address, '\d', '!', 'g') AS address
FROM repositories;
```
Результат:

![pic](https://github.com/vitflare/db-sem-dz/blob/main/hw9/pic/7.png)

### Задание 8
Создание и заполнение таблицы:
```
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY
    , name VARCHAR(100)
    , price FLOAT
    , stock INT
    , weight FLOAT
    , producer VARCHAR(100)
    , country VARCHAR(100)
);

INSERT INTO products (name, price, stock, weight, producer, country) VALUES
('Sugar', 2.50, 100, 1000, 'Sweet Co', 'USA')
, ('Coffee', 8.75, 50, 500, 'Brew Masters', 'Brazil')
, ('Rice', 3.20, 200, 2000, 'Grain Inc', 'India');
```
Запрос:
```
SELECT
    name
    , weight
    , price
    , ROUND((price / (weight / 1000.0))::numeric, 2) AS price_per_kg
FROM products
ORDER BY 
    rice_per_kg ASC
    , name ASC;
```
Результат:

![pic](https://github.com/vitflare/db-sem-dz/blob/main/hw9/pic/8.png)
