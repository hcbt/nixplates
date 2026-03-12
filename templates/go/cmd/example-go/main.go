package main

import (
	"log"
	"os"

	"github.com/hcbt/example-go/internal/app"
	"github.com/hcbt/example-go/internal/version"
)

func main() {
	if err := app.Run(os.Stdout, version.Version); err != nil {
		log.Fatal(err)
	}
}
