package tests

import (
	"bytes"
	"os/exec"
	"strings"
	"testing"
)

func TestMainPackageRuns(t *testing.T) {
	cmd := exec.Command("go", "run", "./cmd/example-go")
	cmd.Dir = ".."

	var output bytes.Buffer
	cmd.Stdout = &output
	cmd.Stderr = &output

	if err := cmd.Run(); err != nil {
		t.Fatalf("go run failed: %v\n%s", err, output.String())
	}

	if got := strings.TrimSpace(output.String()); !strings.HasPrefix(got, "example-go ") {
		t.Fatalf("unexpected output: %q", got)
	}
}
