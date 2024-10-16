################################################################################
# Integrates rip grep with LF
# to allow searching all file contents in the current directory recursively
################################################################################

RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
res="$(
  FZF_DEFAULT_COMMAND="$RG_PREFIX ''" \
    fzf --bind "change:reload:$RG_PREFIX {q} || true" \
    --ansi --layout=reverse --header 'Search in files' \
    | cut -d':' -f1 | sed 's/\\/\\\\/g;s/"/\\"/g'
)"
[ -n "$res" ] && lf -remote "send $id select \"$res\""
