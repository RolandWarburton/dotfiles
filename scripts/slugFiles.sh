#!/bin/sh
for var in "$@"; do
	file="$(basename "$var")"
	dir="$(dirname "$var")"
	mv "$var" "$dir/${file// /_}"
done
