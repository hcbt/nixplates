package app

import (
	"bytes"
	"testing"
)

func TestRunWritesVersion(t *testing.T) {
	var out bytes.Buffer

	if err := Run(&out, "0.1.0"); err != nil {
		t.Fatalf("Run returned error: %v", err)
	}

	if got, want := out.String(), "example-go 0.1.0\n"; got != want {
		t.Fatalf("unexpected output: got %q, want %q", got, want)
	}
}
