CONTAINER_NAME=pg_100
DB_NAME=test
DB_USER=postgres
AWS_REGION=ap-southeast-1
BUCKET_NAME=oxstreet-db-backups
IAM_USERNAME=oxstreet-infra-dev-user
BACKUP_FILE_NAME=all_dbs.sql

up:
	docker compose up -d

down:
	docker compose down --remove-orphans --volumes

psql:
	docker exec -it $(CONTAINER_NAME) psql -U $(DB_USER) -d $(DB_NAME)

sh:
	docker exec -it $(CONTAINER_NAME) sh

# dump into absolute path
pg_dump:
	docker exec -it $(CONTAINER_NAME) pg_dump -U $(DB_USER) $(DB_NAME) > $(DB_NAME).sql

pg_dumpall:
	docker exec -it $(CONTAINER_NAME) pg_dumpall -U $(DB_USER) > $(BACKUP_FILE_NAME).sql

# copy from container /tmp/all_dbs.sql to local ./all_dbs.sql
pg_dumpall_to_local:
	docker cp $(CONTAINER_NAME):/tmp/all_dbs.sql ./all_dbs.sql

aws_config:
	aws configure

aws_cp:
	aws s3 cp all_dbs.sql s3://$(BUCKET_NAME)/all_dbs.sql --region $(AWS_REGION)

aws_ls:
	aws s3 ls s3://$(BUCKET_NAME) --region $(AWS_REGION)

aws_download:
	aws s3 cp s3://$(BUCKET_NAME)/all_dbs.sql ./all_dbs.sql --region $(AWS_REGION)

# restore from local machine ./all_dbs.sql (not from container)
restore_all:
	docker exec -i $(CONTAINER_NAME) psql -U $(DB_USER) -d $(DB_NAME) < $(BACKUP_FILE_NAME)