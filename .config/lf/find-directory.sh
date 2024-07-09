hidden_flag=0

for arg in "$@"; do
  echo $arg
  if [ "$arg" = "--hidden" ]; then
    hidden_flag=1
    break
  fi
done

if [ "$hidden_flag" -eq 1 ]; then
  lf -remote "send $id cd '$(fdfind --type d --exclude .git --exclude git --exclude .cargo --exclude node_modules --hidden | fzf)'"
  else 
  lf -remote "send $id cd '$(fdfind --type d --exclude .git --exclude git --exclude .cargo --exclude node_modules | fzf)'"
fi
