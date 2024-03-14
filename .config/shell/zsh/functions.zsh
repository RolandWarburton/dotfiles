count_lines() {
  find "$1" -type f -exec cat {} + | wc -l
dockersh() {
  if [ $# -eq 0 ]; then
    echo "Usage: dockersh <container_name>"
    return 1
  fi

  local container_name="$1"
  docker exec -it "$container_name" /bin/bash
}
