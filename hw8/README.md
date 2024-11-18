## Поднятие базы данных
```
docker-compose up -d
```
## Миграции
Миграции выполнены на языке PostgreSQL и накатаны с помощью терминальной утилиты psql
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

[Миграция базы данных](https://github.com/vitflare/db-sem-dz/blob/main/hw8/sql/01-init-schema.sql)
```
psql -h localhost -p 5432 -U superadmin -d job -a -f sql/01-init-schema.sql 
Password for user superadmin: 
```

[1 задание](https://github.com/vitflare/db-sem-dz/blob/main/hw8/sql/02-first-task.sql)
```
psql -h localhost -p 5432 -U superadmin -d job -a -f sql/02-first-task.sql 
Password for user superadmin: 
```

[2 задание](https://github.com/vitflare/db-sem-dz/blob/main/hw8/sql/03-second-task.sql)
```
psql -h localhost -p 5432 -U superadmin -d job -a -f sql/03-second-task.sql 
Password for user superadmin: 
```

[3 задание](https://github.com/vitflare/db-sem-dz/blob/main/hw8/sql/04-third-task.sql)
```
psql -h localhost -p 5432 -U superadmin -d job -a -f sql/04-third-task.sql 
Password for user superadmin: 
```

[4 задание](https://github.com/vitflare/db-sem-dz/blob/main/hw8/sql/05-fourth-task.sql)
```
psql -h localhost -p 5432 -U superadmin -d job -a -f sql/05-fourth-task.sql 
Password for user superadmin: 
```

[5 задание](https://github.com/vitflare/db-sem-dz/blob/main/hw8/sql/06-fifth-task.sql)
```
psql -h localhost -p 5432 -U superadmin -d job -a -f sql/06-fifth-task.sql 
Password for user superadmin: 
```

[6 задание](https://github.com/vitflare/db-sem-dz/blob/main/hw8/sql/07-sixth-task.sql)
```
psql -h localhost -p 5432 -U superadmin -d job -a -f sql/07-sixth-task.sql 
Password for user superadmin: 
```

[Тест триггера](https://github.com/vitflare/db-sem-dz/blob/main/hw8/sql/08-test-trigger.sql)
```
psql -h localhost -p 5432 -U superadmin -d job -a -f sql/08-test-trigger.sql 
Password for user superadmin: 
```
Результат:
![тест триггера](https://github.com/vitflare/db-sem-dz/blob/main/hw8/pic/test.png)
