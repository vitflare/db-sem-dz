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

### Задания

Миграция базы данныз
```
psql -h localhost -p 5432 -U superadmin -d job -a -f sql/01-init-schema.sql 
Password for user superadmin: 
```

1 задание 
```
psql -h localhost -p 5432 -U superadmin -d job -a -f sql/02-first-task.sql 
Password for user superadmin: 
```

2 задание 
```
psql -h localhost -p 5432 -U superadmin -d job -a -f sql/03-second-task.sql 
Password for user superadmin: 
```

3 задание 
```
psql -h localhost -p 5432 -U superadmin -d job -a -f sql/04-third-task.sql 
Password for user superadmin: 
```

4 задание 
```
psql -h localhost -p 5432 -U superadmin -d job -a -f sql/05-fourth-task.sql 
Password for user superadmin: 
```

5 задание 
```
psql -h localhost -p 5432 -U superadmin -d job -a -f sql/06-fifth-task.sql 
Password for user superadmin: 
```

6 задание 
```
psql -h localhost -p 5432 -U superadmin -d job -a -f sql/07-sixth-task.sql 
Password for user superadmin: 
```

Тест триггера
```
psql -h localhost -p 5432 -U superadmin -d job -a -f sql/08-test-trigger.sql 
Password for user superadmin: 
```

![тест триггера](/pic/test.png)