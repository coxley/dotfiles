# Vendored from oh-my-zsh plugins/catimg. The script lives next to this
# file so it does not depend on the oh-my-zsh clone.
typeset -g _COXLEY_PLUGINS="${${(%):-%x}:h}"

function catimg() {
  if (( $+commands[magick] )); then
    CONVERT_CMD="magick" zsh $_COXLEY_PLUGINS/catimg/catimg.sh $@
  elif (( $+commands[convert] )); then
    CONVERT_CMD="convert" zsh $_COXLEY_PLUGINS/catimg/catimg.sh $@
  else
    echo "catimg need magick/convert (ImageMagick) to work)"
  fi
}
