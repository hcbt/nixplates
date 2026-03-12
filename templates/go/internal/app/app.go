package app

import (
	"fmt"
	"io"
)

func Run(w io.Writer, version string) error {
	_, err := fmt.Fprintf(w, "example-go %s\n", version)
	return err
}
