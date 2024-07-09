# Creates a new file or folder
#
# Suffix your path with a / to create a folder, otherwise a file will be created
# Example: foo/bar will touch bar in foo
# Example: foo/bar/ will mkdir bar in foo

# read user input
clear
echo "Please enter a file name:"
read filename

# check we are not overwriting anything
if [ -f "$filename" -o -d "$filename" ]; then
  echo "refusing to overwrite $(basename $filename)"
  return 0
fi

# Remove leading /
if [[ "$filename" == /* ]]; then
    filename="${filename:1}"
fi

# check if the last char is a /
# this determines if we are creating a file or a folder
last_character="${filename: -1}"
if [ "$last_character" = "/" ]; then
  # create a folder
  mkdir -p $filename
else
  # create a file
  mkdir -p $(dirname $filename)
  touch $filename
fi
