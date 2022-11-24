package db

import (
	"database/sql"
	"log"
	"os"
	"testing"

	_ "github.com/lib/pq"
	"github.com/nitin1259/childbank/util"
)

var testQueries *Queries
var testDB *sql.DB

func TestMain(m *testing.M) {

	config, confErr := util.LoadConfig("../..")
	if confErr != nil {
		log.Fatal("error while config load: ", confErr)
	}
	var err error
	testDB, err = sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatalf("cannot connect to the db: %s", err)
	}

	testQueries = New(testDB)

	os.Exit(m.Run())
}
