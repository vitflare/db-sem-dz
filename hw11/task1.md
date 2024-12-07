# Задание 1: BRIN индексы и bitmap-сканирование

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

4. Создайте BRIN индекс по колонке category:
   ```sql
   CREATE INDEX t_books_brin_cat_idx ON t_books USING brin(category);
   ```

5. Найдите книги с NULL значением category:
   ```sql
   EXPLAIN ANALYZE
   SELECT * FROM t_books WHERE category IS NULL;
   ```
   
   *План выполнения:*
   ```
   Bitmap Heap Scan on t_books  (cost=12.00..16.01 rows=1 width=33) (actual time=0.011..0.012 rows=0 loops=1)
   Recheck Cond: (category IS NULL)
   ->  Bitmap Index Scan on t_books_brin_cat_idx  (cost=0.00..12.00 rows=1 width=0) (actual time=0.009..0.009 rows=0 loops=1)
        Index Cond: (category IS NULL)
   Planning Time: 0.216 ms
   Execution Time: 0.038 ms
   ```
   
   *Объясните результат:*
   
   Используется Bitmap Heap Scan с Bitmap Index Scan

   Несмотря на то, что оптимизатор предполагал наличие одной такой строки, по факту их не оказалось. BRIN индекс хорошо сработал в данном случае, так как:
   - Позволил быстро исключить все блоки данных, где точно нет NULL значений
   - Не потребовалось сканировать всю таблицу
   - Время выполнения минимальное, что подтверждает эффективность использования индекса

6. Создайте BRIN индекс по автору:
   ```sql
   CREATE INDEX t_books_brin_author_idx ON t_books USING brin(author);
   ```

7. Выполните поиск по категории и автору:
   ```sql
   EXPLAIN ANALYZE
   SELECT * FROM t_books 
   WHERE category = 'INDEX' AND author = 'SYSTEM';
   ```
   
   *План выполнения:*
   ```
   Bitmap Heap Scan on t_books  (cost=12.16..2350.34 rows=1 width=33) (actual time=19.222..19.223 rows=0 loops=1)
      Recheck Cond: ((category)::text = 'INDEX'::text)
      Rows Removed by Index Recheck: 150000
      Filter: ((author)::text = 'SYSTEM'::text)
      Heap Blocks: lossy=1225
      ->  Bitmap Index Scan on t_books_brin_cat_idx  (cost=0.00..12.16 rows=74212 width=0) (actual time=0.126..0.126 rows=12250 loops=1)
         Index Cond: ((category)::text = 'INDEX'::text)
   Planning Time: 0.276 ms
   Execution Time: 19.263 ms
   ```
   
   *Объясните результат (обратите внимание на bitmap scan):*
   
   План выполнения показывает, что PostgreSQL использовал BRIN индекс по колонке category (t_books_brin_cat_idx), но проигнорировал индекс по автору. Bitmap Index Scan создал битовую карту потенциально подходящих строк для категории 'INDEX', после чего Bitmap Heap Scan проверял эти строки на соответствие обоим условиям. 
   
   Интересно отметить параметр "Rows Removed by Index Recheck: 150000" и "Heap Blocks: lossy=1225" - это говорит о том, что BRIN индекс дал приблизительную оценку, и многие строки пришлось перепроверять. 
   
   Хотя изначально индекс предположил около 74212 строк (rows в Bitmap Index Scan), фактически было проверено 150000 строк, и в итоге не найдено ни одной полностью соответствующей условиям (actual time=19.222..19.223 rows=0). 
   
   Общее время выполнения составило 19.263 мс, что относительно много для запроса, не вернувшего результатов, и указывает на неэффективность BRIN индекса для точечных запросов такого типа.

8. Получите список уникальных категорий:
   ```sql
   EXPLAIN ANALYZE
   SELECT DISTINCT category 
   FROM t_books 
   ORDER BY category;
   ```
   
   *План выполнения:*
   ```
   Sort  (cost=3100.14..3100.15 rows=6 width=7) (actual time=35.639..35.640 rows=6 loops=1)
      Sort Key: category
      Sort Method: quicksort  Memory: 25kB
      ->  HashAggregate  (cost=3100.00..3100.06 rows=6 width=7) (actual time=35.607..35.  608 rows=6 loops=1)
         Group Key: category
         Batches: 1  Memory Usage: 24kB
         ->  Seq Scan on t_books  (cost=0.00..2725.00 rows=150000 width=7) (actual time=0.032..9.881 rows=150000 loops=1)
   Planning Time: 0.095 ms
   Execution Time: 35.793 ms
   ```
   
   *Объясните результат:*
   
   Общее время выполнения составило 35.793 мс, что объясняется необходимостью полного сканирования таблицы, хотя результирующий набор данных оказался очень маленьким (всего 6 строк). BRIN индекс здесь не использовался, так как требовалось получить все уникальные значения, а не искать конкретные.

9. Подсчитайте книги, где автор начинается на 'S':
   ```sql
   EXPLAIN ANALYZE
   SELECT COUNT(*) 
   FROM t_books 
   WHERE author LIKE 'S%';
   ```
   
   *План выполнения:*
   ```
   Aggregate  (cost=3100.04..3100.05 rows=1 width=8) (actual time=21.624..21.625 rows=1 loops=1)
      ->  Seq Scan on t_books  (cost=0.00..3100.00 rows=15 width=0) (actual time=21.613..21.613 rows=0 loops=1)
         Filter: ((author)::text ~~ 'S%'::text)
         Rows Removed by Filter: 150000
   Planning Time: 0.711 ms
   Execution Time: 21.766 ms
   ```
   
   *Объясните результат:*

   План выполнения показывает, что PostgreSQL выполнил последовательное сканирование (Seq Scan) всей таблицы вместо использования BRIN индекса по автору, даже несмотря на его наличие. Это можно объяснить тем, что BRIN индексы не эффективны для поиска по префиксу (LIKE 'S%'), поскольку они работают с диапазонами значений, а не с точным поиском или поиском по шаблону. В процессе сканирования было проверено все 150000 строк (Rows Removed by Filter: 150000), из которых ни одна не соответствовала условию поиска (rows=0). Операция агрегации (Aggregate) применялась для подсчета строк. 
   
   Общее время выполнения составило 21.766 мс, что относительно много для запроса, не нашедшего ни одной строки, и подтверждает неэффективность BRIN индексов для такого типа поиска.

10. Создайте индекс для регистронезависимого поиска:
    ```sql
    CREATE INDEX t_books_lower_title_idx ON t_books(LOWER(title));
    ```

11. Подсчитайте книги, начинающиеся на 'O':
    ```sql
    EXPLAIN ANALYZE
    SELECT COUNT(*) 
    FROM t_books 
    WHERE LOWER(title) LIKE 'o%';
    ```
   
      *План выполнения:*
      ```
      Aggregate  (cost=3476.88..3476.89 rows=1 width=8) (actual time=44.964..44.964 rows=1 loops=1)
      ->  Seq Scan on t_books  (cost=0.00..3475.00 rows=750 width=0) (actual time=44.957..44.959 rows=1 loops=1)
         Filter: (lower((title)::text) ~~ 'o%'::text)
         Rows Removed by Filter: 149999
      Planning Time: 0.277 ms
      Execution Time: 44.987 ms
      ```
   
      *Объясните результат:*
   
      План выполнения демонстрирует, что PostgreSQL не использовал созданный индекс t_books_lower_title_idx, а вместо этого выполнил последовательное сканирование (Seq Scan) таблицы. 
   
      Время выполнения составило 44.987 мс, что довольно много для такой операции. Это может указывать на то, что оптимизатор посчитал последовательное сканирование более эффективным в данном случае, возможно, из-за неточных статистических данных или из-за того, что ожидалось большое количество совпадений (750 строк), что сделало бы использование индекса менее выгодным по сравнению с полным сканированием.

12. Удалите созданные индексы:
    ```sql
    DROP INDEX t_books_brin_cat_idx;
    DROP INDEX t_books_brin_author_idx;
    DROP INDEX t_books_lower_title_idx;
    ```

13. Создайте составной BRIN индекс:
    ```sql
    CREATE INDEX t_books_brin_cat_auth_idx ON t_books 
    USING brin(category, author);
    ```

14. Повторите запрос из шага 7:
    ```sql
    EXPLAIN ANALYZE
    SELECT * FROM t_books 
    WHERE category = 'INDEX' AND author = 'SYSTEM';
    ```
   
      *План выполнения:*
      ```
      Bitmap Heap Scan on t_books  (cost=12.16..2350.34 rows=1 width=33) (actual time=1.231..1.232 rows=0 loops=1)
         Recheck Cond: (((category)::text = 'INDEX'::text) AND ((author)::text = 'SYSTEM'::text))
         Rows Removed by Index Recheck: 8848
         Heap Blocks: lossy=73
         ->  Bitmap Index Scan on t_books_brin_cat_auth_idx  (cost=0.00..12.16 rows=74212 width=0) (actual time=0.058..0.058 rows=730 loops=1)
            Index Cond: (((category)::text = 'INDEX'::text) AND ((author)::text = 'SYSTEM'::text))
      Planning Time: 0.212 ms
      Execution Time: 1.268 ms
      ```
   
      *Объясните результат:*

      План выполнения показывает значительное улучшение производительности с составным BRIN индексом. По сравнению с предыдущим запросом (19.263 мс), время выполнения сократилось до 1.268 мс. Bitmap Index Scan по составному индексу оказался эффективнее, проверив меньше строк (8848 против 150000) и использовав меньше блоков (73 lossy blocks против 1225). 
      
      Это демонстрирует, что составной BRIN индекс по category и author позволяет более точно определить диапазоны блоков, содержащих нужные значения, хотя оценка оптимизатора всё ещё не точна (ожидалось 74212 строк, а проверено 8848).