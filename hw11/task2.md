## Задание 2

1. Удалите старую базу данных, если есть:
    ```shell
    docker compose down
    ```

2. Поднимите базу данных из src/docker-compose.yml:
    ```shell
    docker compose down && docker compose up -d
    ```

3. Обновите статистику:
    ```sql
    ANALYZE t_books;
    ```

4. Создайте полнотекстовый индекс:
    ```sql
    CREATE INDEX t_books_fts_idx ON t_books 
    USING GIN (to_tsvector('english', title));
    ```

5. Найдите книги, содержащие слово 'expert':
    ```sql
    EXPLAIN ANALYZE
    SELECT * FROM t_books 
    WHERE to_tsvector('english', title) @@ to_tsquery('english', 'expert');
    ```
    
    *План выполнения:*
    ```
    Bitmap Heap Scan on t_books  (cost=21.03..1335.59 rows=750 width=33) (actual time=0.063..0.064 rows=1 loops=1)
          Recheck Cond: (to_tsvector('english'::regconfig, (title)::text) @@ '''expert'''::tsquery)"
          Heap Blocks: exact=1
          ->  Bitmap Index Scan on t_books_fts_idx  (cost=0.00..20.84 rows=750 width=0) (actual time=0.046..0.047 rows=1 loops=1)
              Index Cond: (to_tsvector('english'::regconfig, (title)::text) @@ '''expert'''::tsquery)"
     Planning Time: 0.731 ms
     Execution Time: 0.135 ms
    ```
    
    *Объясните результат:*
    
    План выполнения демонстрирует эффективную работу полнотекстового GIN индекса. Bitmap Index Scan нашел только одну строку, содержащую слово 'expert', хотя оптимизатор ожидал 750 строк. Для доступа к данным потребовался всего один блок (Heap Blocks: exact=1). Время выполнения очень низкое - 0.135 мс, что показывает высокую эффективность полнотекстового поиска с использованием GIN индекса по сравнению с обычным LIKE-поиском.

6. Удалите индекс:
    ```sql
    DROP INDEX t_books_fts_idx;
    ```

7. Создайте таблицу lookup:
    ```sql
    CREATE TABLE t_lookup (
         item_key VARCHAR(10) NOT NULL,
         item_value VARCHAR(100)
    );
    ```

8. Добавьте первичный ключ:
    ```sql
    ALTER TABLE t_lookup 
    ADD CONSTRAINT t_lookup_pk PRIMARY KEY (item_key);
    ```

9. Заполните данными:
    ```sql
    INSERT INTO t_lookup 
    SELECT 
         LPAD(CAST(generate_series(1, 150000) AS TEXT), 10, '0'),
         'Value_' || generate_series(1, 150000);
    ```

10. Создайте кластеризованную таблицу:
     ```sql
     CREATE TABLE t_lookup_clustered (
          item_key VARCHAR(10) PRIMARY KEY,
          item_value VARCHAR(100)
     );
     ```

11. Заполните её теми же данными:
     ```sql
     INSERT INTO t_lookup_clustered 
     SELECT * FROM t_lookup;
     
     CLUSTER t_lookup_clustered USING t_lookup_clustered_pkey;
     ```

12. Обновите статистику:
     ```sql
     ANALYZE t_lookup;
     ANALYZE t_lookup_clustered;
     ```

13. Выполните поиск по ключу в обычной таблице:
     ```sql
     EXPLAIN ANALYZE
     SELECT * FROM t_lookup WHERE item_key = '0000000455';
     ```
     
     *План выполнения:*
     ```
     Index Scan using t_lookup_pk on t_lookup  (cost=0.42..8.44 rows=1 width=23) (actual time=0.017..0.018 rows=1 loops=1)
          Index Cond: ((item_key)::text = '0000000455'::text)
     Planning Time: 0.215 ms
     Execution Time: 0.040 ms
     ```
     
     *Объясните результат:*

     План выполнения показывает эффективный поиск по первичному ключу: используется Index Scan с условием item_key = '0000000455'. Операция выполнилась за 0.040 мс, найдена одна строка. Оценки планировщика (cost=0.42..8.44, rows=1) оказались точными.

14. Выполните поиск по ключу в кластеризованной таблице:
     ```sql
     EXPLAIN ANALYZE
     SELECT * FROM t_lookup_clustered WHERE item_key = '0000000455';
     ```
     
     *План выполнения:*
     ```
     Index Scan using t_lookup_clustered_pkey on t_lookup_clustered  (cost=0.42..8.44 rows=1 width=23) (actual time=0.240..0.241 rows=1 loops=1)
          Index Cond: ((item_key)::text = '0000000455'::text)
     Planning Time: 0.905 ms
     Execution Time: 0.354 ms
     ```
     
     *Объясните результат:*
     
     План выполнения показывает, что поиск по ключу в кластеризованной таблице оказался медленнее (0.354 мс против 0.040 мс в некластеризованной таблице). Несмотря на то, что данные в кластеризованной таблице физически упорядочены по первичному ключу, это не дало преимущества при точечном поиске - обе таблицы используют Index Scan с одинаковой оценочной стоимостью (cost=0.42..8.44). 
     
     Это объясняется тем, что для поиска по одному значению первичного ключа кластеризация не даёт выигрыша, так как B-tree индекс и так эффективно находит нужную запись.

15. Создайте индекс по значению для обычной таблицы:
     ```sql
     CREATE INDEX t_lookup_value_idx ON t_lookup(item_value);
     ```

16. Создайте индекс по значению для кластеризованной таблицы:
     ```sql
     CREATE INDEX t_lookup_clustered_value_idx 
     ON t_lookup_clustered(item_value);
     ```

17. Выполните поиск по значению в обычной таблице:
     ```sql
     EXPLAIN ANALYZE
     SELECT * FROM t_lookup WHERE item_value = 'T_BOOKS';
     ```
     
     *План выполнения:*
     ```
     Index Scan using t_lookup_value_idx on t_lookup  (cost=0.42..8.44 rows=1 width=23) (actual time=0.127..0.128 rows=0 loops=1)
          Index Cond: ((item_value)::text = 'T_BOOKS'::text)
     Planning Time: 0.960 ms
     Execution Time: 0.204 ms
     ```
     
     *Объясните результат:*
     
     План выполнения показывает использование Index Scan по индексу item_value. Хотя оптимизатор ожидал найти одну строку, фактически записей с value = 'T_BOOKS' не обнаружено (rows=0). Запрос выполнился за 0.204 мс, используя только индекс для поиска без обращения к таблице.

18. Выполните поиск по значению в кластеризованной таблице:
     ```sql
     EXPLAIN ANALYZE
     SELECT * FROM t_lookup_clustered WHERE item_value = 'T_BOOKS';
     ```
     
     *План выполнения:*
     ```
     Index Scan using t_lookup_clustered_value_idx on t_lookup_clustered  (cost=0.42..8.44 rows=1 width=23) (actual time=0.098..0.099 rows=0 loops=1)
          Index Cond: ((item_value)::text = 'T_BOOKS'::text)
     Planning Time: 1.040 ms
     Execution Time: 0.115 ms
     ```
     
     *Объясните результат:*
     
     План выполнения аналогичен предыдущему запросу, но показывает немного лучшую производительность в кластеризованной таблице (0.115 мс против 0.204 мс). Однако это различие незначительно, так как поиск по индексу item_value не получает преимущества от кластеризации таблицы по первичному ключу. Оценки планировщика идентичны (cost=0.42..8.44, rows=1), и в обоих случаях записей не найдено (rows=0).

19. Сравните производительность поиска по значению в обычной и кластеризованной таблицах:
     
     *Сравнение:*
     - Обычная таблица: 0.204 мс
     - Кластеризованная таблица: 0.115 мс

     Разница: 0.089 мс (43% быстрее)
     
     Несмотря на небольшое преимущество кластеризованной таблицы, разница несущественна для точечных запросов, так как оба запроса используют индекс по item_value, а кластеризация по первичному ключу не влияет на эффективность поиска по другим колонкам.