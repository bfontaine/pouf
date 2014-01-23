if [ -d $HOME/.sounds ]; then
# play random sounds from the command line
function pouf () {
    \ls -1 $HOME/.sounds/*$1* | head -1 | xargs afplay
}
fi
