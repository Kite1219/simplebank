package main

import (
	"database/sql"
	"log"

	"github.com/kite1209/simplebank/api"
	db "github.com/kite1209/simplebank/db/sqlc"
	"github.com/kite1209/simplebank/util"
	_ "github.com/lib/pq"
)

func main() {
	config, err := util.LoadConfig(".")
	if err != nil {
		log.Fatal("cannot load config", err)
	}

	conn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("cannot connect to the database", err)
	}
	store := db.NewStore(conn)
	server, err := api.NewServer(config, store)

	if err != nil {
		log.Fatal("cannot create server: ", err)
	}

	err = server.Start(config.ServerAddress)

	if err != nil {
		log.Fatal("cannot log server")
	}
}
