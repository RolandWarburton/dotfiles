SEL="$(xsel)"
FILE=$(mktemp XXXXXX).wav
pico2wave --wave $FILE -l en-US "$SEL"
aplay $FILE
rm $FILE