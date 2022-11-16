postgres:
	docker run --name postgres15 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=root -d postgres:15-alpine

createdb:
	docker exec -it postgres15 createdb --username=root --owner=root child_bank

dropdb:
	docker exec -it postgres15 dropdb child_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/child_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/child_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

.PHONY: postgres createdb dropdb migrateup migratedown sqlc