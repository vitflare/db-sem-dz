## Задание 3

1. Создайте таблицу с большим количеством данных:
    ```sql
    CREATE TABLE test_cluster AS 
    SELECT 
        generate_series(1,1000000) as id,
        CASE WHEN random() < 0.5 THEN 'A' ELSE 'B' END as category,
        md5(random()::text) as data;
    ```

2. Создайте индекс:
    ```sql
    CREATE INDEX test_cluster_cat_idx ON test_cluster(category);
    ```

3. Измерьте производительность до кластеризации:
    ```sql
    EXPLAIN ANALYZE
    SELECT * FROM test_cluster WHERE category = 'A';
    ```
    
    *План выполнения:*
    ```
    Bitmap Heap Scan on test_cluster  (cost=5575.43..20209.42 rows=500000 width=39) (actual time=21.914..89.740 rows=499630 loops=1)
        Recheck Cond: (category = 'A'::text)
        Heap Blocks: exact=8334
        ->  Bitmap Index Scan on test_cluster_cat_idx  (cost=0.00..5450.43 rows=500000 width=0) (actual time=20.563..20.564 rows=499630 loops=1)
            Index Cond: (category = 'A'::text)
    Planning Time: 0.660 ms
    Execution Time: 102.694 ms
    ```
    
    *Объясните результат:*
    
    План выполнения показывает, что запрос использует Bitmap Index Scan для поиска строк с category = 'A', после чего выполняется Bitmap Heap Scan для получения данных. Время выполнения составило 102.694 мс, при этом было обработано 8334 блока данных для извлечения примерно 499630 строк. Оценки оптимизатора (500000 строк) оказались довольно точными. 
    
    Относительно высокое время выполнения и количество обработанных блоков указывают на то, что данные физически разбросаны по таблице, что делает операцию чтения менее эффективной.

4. Выполните кластеризацию:
    ```sql
    CLUSTER test_cluster USING test_cluster_cat_idx;
    ```
    
    *Результат:*
    ```
    workshop.public> CLUSTER test_cluster USING test_cluster_cat_idx
    [2024-12-07 22:23:33] completed in 507 ms
    ```

5. Измерьте производительность после кластеризации:
    ```sql
    EXPLAIN ANALYZE
    SELECT * FROM test_cluster WHERE category = 'A';
    ```
    
    *План выполнения:*
    ```
    Bitmap Heap Scan on test_cluster  (cost=5575.43..20159.42 rows=500000 width=39) (actual time=19.457..81.520 rows=499630 loops=1)
        Recheck Cond: (category = 'A'::text)
        Heap Blocks: exact=4164
        ->  Bitmap Index Scan on test_cluster_cat_idx  (cost=0.00..5450.43 rows=500000 width=0) (actual time=18.648..18.648 rows=499630 loops=1)
            Index Cond: (category = 'A'::text)
    Planning Time: 0.653 ms
    Execution Time: 96.489 ms
    ```
    
    *Объясните результат:*
    
    План выполнения после кластеризации показывает заметные улучшения: количество обработанных блоков уменьшилось вдвое (с 8334 до 4164), а время выполнения сократилось с 102.694 мс до 96.489 мс. 
    
    Это произошло благодаря тому, что CLUSTER физически переупорядочил данные на диске по индексу category, сгруппировав записи с одинаковыми значениями вместе, что позволило PostgreSQL читать данные более последовательно и эффективно.

6. Сравните производительность до и после кластеризации:
    
    *Сравнение:*
    
    - Время выполнения: улучшилось на 6% (с 102.694 мс до 96.489 мс)
    - Количество блоков: сократилось на 50% (с 8334 до 4164)
    - План запроса: остался тем же (Bitmap Heap Scan + Bitmap Index Scan)
    - Точность оченки не менялась

    Основное улучшение достигнуто за счет более эффективного физического расположения данных на диске после кластеризации, что сократило количество операций ввода-вывода.