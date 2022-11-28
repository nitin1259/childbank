postgres:
	docker run --name postgres15 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=root -d postgres:15-alpine

createdb:
	docker exec -it postgres15 createdb --username=root --owner=root child_bank

dropdb:
	docker exec -it postgres15 dropdb child_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/child_bank?sslmode=disable" -verbose up

migrateup-awsdb:
	migrate -path db/migration -database "postgresql://root:vbxz1wWGrH0a2PewgVx7@child-bank.cgqalu0bsppg.ap-south-1.rds.amazonaws.com:5432/child_bank" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/child_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/child_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/child_bank?sslmode=disable" -verbose down 1
	
sqlc:
	sqlc generate

test: 
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go  github.com/nitin1259/childbank/db/sqlc Store

docker-build:
	docker build -t childbank:latest .

docker-run:
	docker stop childbank
	docker rm childbank
	docker run --name childbank --network bank-network -p 8080:8080 -e GIN_MODE=release -e DB_SOURCE="postgresql://root:root@postgres15:5432/child_bank?sslmode=disable" childbank:latest

.PHONY: postgres createdb dropdb migrateup migrateup1 migratedown migratedown1 sqlc test server mock docker-build docker-run