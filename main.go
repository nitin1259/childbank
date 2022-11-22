package main

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
	"github.com/nitin1259/childbank/api"
	db "github.com/nitin1259/childbank/db/sqlc"
	"github.com/nitin1259/childbank/util"
)

func main() {

	config, err := util.LoadConfig(".")
	if err != nil {
		log.Fatal("config loading error: ", err.Error())
	}

	// db connection
	conn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatalf("cannot connect to the db: %s", err)
	}
	store := db.NewStore(conn)

	server := api.NewServer(store)

	if err := server.Start(config.ServerAddress); err != nil {
		log.Fatal("cannot start the server, err: ", err.Error())
	}

}
