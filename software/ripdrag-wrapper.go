package main

// RIPDRAG WRAPPER
// Wraps ripdrag for use with lf
// lf outputs multiple files as $1\n$2...
// this script converts them to $1 $2, stripping the newline

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	// Check if at least one argument is provided
	if len(os.Args) < 2 {
		fmt.Println("Usage: go run main.go <string1> [<string2> <string3> ...]")
		os.Exit(1)
	}

	// Concatenate all strings into one line with spaces between each string
	combinedString := strings.ReplaceAll(os.Args[1], "\n", " ")
	for _, arg := range os.Args[2:] {
		combinedString += " " + strings.ReplaceAll(arg, "\n", " ")
	}

	// Print the combined string
	fmt.Println(combinedString)
}
