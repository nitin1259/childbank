package main

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
	"github.com/nitin1259/childbank/api"
	db "github.com/nitin1259/childbank/db/sqlc"
)

const (
	dbDriver      string = "postgres"
	dbSource      string = "postgresql://root:root@localhost:5432/child_bank?sslmode=disable"
	serverAddress string = "0.0.0.0:8080"
)

func main() {

	// db connection
	conn, err := sql.Open(dbDriver, dbSource)
	if err != nil {
		log.Fatalf("cannot connect to the db: %s", err)
	}
	store := db.NewStore(conn)

	server := api.NewServer(store)

	if err := server.Start(serverAddress); err != nil {
		log.Fatal("cannot start the server, err: ", err.Error())
	}

}
