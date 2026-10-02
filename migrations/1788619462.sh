echo "Hand Hermes Desktop the Unbloarchy theme as a skin"

# Only the app Unbloarchy installed under Install > AI follows the theme by itself.
# A Hermes the user set up some other way keeps whatever skin they chose.
unbloarchy-pkg-present hermes-desktop || exit 0

# The same hand-over a fresh install does. A Hermes that is not ready or refuses
# the write is reported and done with there; only Unbloarchy's own failures return.
unbloarchy-theme-set-hermes --activate
