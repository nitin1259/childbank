package db

import (
	"database/sql"
	"log"
	"os"
	"testing"

	_ "github.com/lib/pq"
)

const (
	dbDriver string = "postgres"
	dbSource string = "postgresql://root:root@localhost:5432/child_bank?sslmode=disable"
)

var testQueries *Queries
var testDB *sql.DB

func TestMain(m *testing.M) {
	var err error
	testDB, err = sql.Open(dbDriver, dbSource)
	if err != nil {
		log.Fatalf("cannot connect to the db: %s", err)
	}

	testQueries = New(testDB)

	os.Exit(m.Run())
}
