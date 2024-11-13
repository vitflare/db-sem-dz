-- Очистка таблиц
TRUNCATE TABLE results, events, players CASCADE;

-- Генерация имён спортсменов с гласными и согласными в начале имени
WITH RECURSIVE
name_components AS (
    SELECT array['Anna', 'Emma', 'Ian', 'Oliver', 'Elena', 'Adam', 'Bob', 'Charlie', 'David', 'Frank'] as first_names,
           array['Smith', 'Johnson', 'Brown', 'Davis', 'Wilson', 'Anderson', 'Taylor', 'Thomas', 'Moore', 'Martin'] as last_names
),
generate_names AS (
    SELECT first_names[1 + floor(random() * array_length(first_names, 1))::integer] || ' ' ||
           last_names[1 + floor(random() * array_length(last_names, 1))::integer] as name
    FROM name_components, generate_series(1, 200)
)
INSERT INTO players (name, player_id, country_id, birthdate)
SELECT 
    name,
    'P' || to_char(row_number() over (order by random()), 'FM0000'),
    (SELECT country_id FROM countries ORDER BY random() LIMIT 1),
    '1975-01-01'::date + (random() * 9000)::integer
FROM generate_names;

-- Создание спортивных событий
WITH event_types AS (
    SELECT 
        s.sport,
        c.category,
        o.olympic_id
    FROM 
        (SELECT unnest(array['Swimming', 'Athletics', 'Gymnastics', 'Boxing', 'Wrestling']) as sport) s
        CROSS JOIN
        (SELECT unnest(array['100m', '200m', 'Final', 'Qualifying', 'Medal Round']) as category) c
        CROSS JOIN
        (SELECT olympic_id FROM olympics) o
)
INSERT INTO events (event_id, name, eventtype, olympic_id, is_team_event, num_players_in_team, result_noted_in)
SELECT 
    'E' || to_char(row_number() over (order by 1), 'FM0000'),
    sport || ' ' || category,
    sport,
    olympic_id,
    CASE WHEN random() < 0.3 THEN 1 ELSE 0 END,
    CASE WHEN random() < 0.3 THEN floor(random() * 10 + 2)::integer ELSE 1 END,
    'Points'
FROM event_types;

-- Генерация результатов с учетом медалей
INSERT INTO results (event_id, player_id, medal, result)
SELECT 
    e.event_id,
    p.player_id,
    CASE 
        WHEN rn <= 1 THEN 'GOLD'
        WHEN rn <= 2 THEN 'SILVER'
        WHEN rn <= 3 THEN 'BRONZE'
        ELSE NULL
    END as medal,
    random() * 100 as result
FROM events e
CROSS JOIN players p
CROSS JOIN (SELECT generate_series(1, 3) as rn) nums
WHERE random() < 0.1
AND (e.is_team_event = 0 OR (e.is_team_event = 1 AND random() < 0.3))
ORDER BY random();

-- Создание нескольких ничьих для индивидуальных событий
WITH tie_events AS (
    SELECT event_id 
    FROM events 
    WHERE is_team_event = 0 
    LIMIT 3
),
random_players AS (
    SELECT player_id 
    FROM players 
    LIMIT 2
)
INSERT INTO results (event_id, player_id, medal, result)
SELECT 
    e.event_id,
    p.player_id,
    'GOLD',
    100.0  -- Одинаковый результат для создания ничьей
FROM tie_events e
CROSS JOIN random_players p;

-- Добавление дополнительных результатов для 2004 года с учетом года рождения
INSERT INTO results (event_id, player_id, medal, result)
SELECT 
    e.event_id,
    p.player_id,
    'GOLD',
    random() * 100
FROM events e
JOIN players p ON extract(year from p.birthdate) between 1980 and 1985
WHERE e.olympic_id = '2004SUM'
AND random() < 0.2
ON CONFLICT DO NOTHING;