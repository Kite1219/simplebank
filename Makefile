DB_URL=postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable
changedir:
	cd /mnt/d/Codes/backend/simplebank


postgres:
	docker run --name postgres17 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:17-alpine

createdb:
	docker exec -it postgres17 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres17 dropdb simple_bank

migrateup:
	migrate -path ./db/migration -database "${DB_URL}" -verbose up

migrateup1:
	migrate -path ./db/migration -database "${DB_URL}" -verbose up 1

migratedown:
	migrate -path ./db/migration -database "${DB_URL}" -verbose down

migratedown1:
	migrate -path ./db/migration -database "${DB_URL}" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/kite1209/simplebank/db/sqlc Store

db_docs:
	dbdocs build doc/db.dbml

db_schema:
	dbml2sql -postgres -o doc/schema.sql doc/db.dbml

.PHONY: server postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 sqlc mock db_docs db_schema

