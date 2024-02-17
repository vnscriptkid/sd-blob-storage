# Backup Postgresql to S3

## Create table 
```sql
create table posts(id serial, user_id int, title text, content text, created_at timestamp);
```

### Seed some data
```sql
insert into posts(user_id, title, content, created_at) values(1, 'Post 1', 'Content 1', now());
insert into posts(user_id, title, content, created_at) values(1, 'Post 2', 'Content 2', now());
insert into posts(user_id, title, content, created_at) values(2, 'Post 3', 'Content 3', now());
```

### Delete all data
```sql
delete from posts;
```

### Backup
```bash
pg_dump -U postgres -h localhost -d mydb > mydb.sql
aws s3 cp mydb.sql s3://mybucket/mydb.sql
```

### Restore
```bash
aws s3 cp s3://mybucket/mydb.sql mydb.sql
psql -U postgres -h localhost -d mydb < mydb.sql
```