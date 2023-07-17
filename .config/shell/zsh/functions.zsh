count_lines() {
  find "$1" -type f -exec cat {} + | wc -l
}
