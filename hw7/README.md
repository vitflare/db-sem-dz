```
psql -h localhost -p 5432 -U superadmin -d olimp -a -f ./01-init-schema.sql 
Password for user superadmin: 
```
```
psql -h localhost -p 5432 -U superadmin -d olimp -a -f ./02-seed-data.sql  
Password for user superadmin: 
```
```
psql -h localhost -p 5432 -U superadmin -d olimp -a -f sql/03-populate-data.sql
Password for user superadmin: 
```
