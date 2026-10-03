#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

# The wordmark ships in two forms that have to agree: logo.txt is the ASCII
# grid, logo.svg is that same grid vectorised. Nothing generates either at
# install time, so a hand edit to one silently desyncs the pair. These tests pin
# the grid itself and then prove the SVG reproduces it cell for cell.

expected=$(
  cat <<'WORDMARK'
 ▄█   █▄    ▄█   █▄     ▄███████  ▄██         ▄█████▄     ▄███████    ▄███████   ▄███████    ▄█   █▄     ▄█   █▄
███   ███  ███▄  ███   ███   ███  ███        ███   ███   ███   ███   ███   ███  ███   ███   ███   ███   ███   ███
███   ███  ███▀▄ ███   ███   ███  ███        ███   ███   ███   ███   ███   ███  ███   █▀    ███   ███   ███   ███
███   ███  ███ ▀▄███   ████████▀  ███        ███   ███  ▄███▄▄▄███  ▄███▄▄▄██▀  ███        ▄███▄▄▄███▄  ███▄▄▄███
███   ███  ███  ▀███   ███   ███  ███        ███   ███  ▀███▀▀▀███  ▀███▀▀▀▀    ███        ▀███▀▀▀███   ▀▀▀▀▀▀███
███   ███  ███   ███   ███   ███  ███        ███   ███   ███   ███  ██████████  ███   █▄    ███   ███   ▄██   ███
███   ███  ███   ███   ███   ███  ███        ███   ███   ███   ███   ███   ███  ███   ███   ███   ███   ███   ███
 ▀█████▀    █▀   ▀█    ▀██████▀   ███████▀    ▀█████▀    ███   █▀    ███   ███  ███████▀    ███   █▀     ▀█████▀
                                                                     ███   █▀
WORDMARK
)

[[ -f $ROOT/logo.txt ]] || fail "logo.txt exists"
actual=$(cat "$ROOT/logo.txt")
[[ $actual == "$expected" ]] || fail "logo.txt is the Unbloarchy wordmark" "expected:
$expected
actual:
$actual"
pass "logo.txt is the Unbloarchy wordmark"

# The icon set is the one piece of brand artwork the rename leaves alone: it
# carries no ASCII, so there is nothing to spell the old name. Pin the digests
# so a regeneration cannot slip in under the wordmark commit.
icon_txt_sha=5fe8adced2fe67e410e177477a7272d1807b3fedc81fbc3f030dd479bc046b76
icon_png_sha=edd69e61d711d8b423555f27a5afc64935c299f6e7f779112d2ce970ec0236e4

require_command sha256sum

[[ $(sha256sum "$ROOT/icon.txt" | cut -d' ' -f1) == "$icon_txt_sha" ]] ||
  fail "icon.txt is untouched by the rename"
pass "icon.txt is untouched by the rename"

[[ $(sha256sum "$ROOT/icon.png" | cut -d' ' -f1) == "$icon_png_sha" ]] ||
  fail "icon.png is untouched by the rename"
pass "icon.png is untouched by the rename"

# Every block character is one cell. Measuring the width with awk or ${#line}
# would be locale-dependent: under LC_ALL=C both count bytes, and the
# three-byte blocks turn 113 columns into 263. Substituting the blocks for
# single-byte digits first makes the count byte-accurate in every locale, since
# what remains is all ASCII.
mapfile -t logo_lines <"$ROOT/logo.txt"
rows=${#logo_lines[@]}
declare -a uppers=() lowers=()
columns=0
for line in "${logo_lines[@]}"; do
  upper=${line//█/1}
  upper=${upper//▀/1}
  upper=${upper//▄/0}
  upper=${upper// /0}
  lower=${line//█/1}
  lower=${lower//▀/0}
  lower=${lower//▄/1}
  lower=${lower// /0}
  uppers+=("$upper")
  lowers+=("$lower")
  (( ${#upper} > columns )) && columns=${#upper}
done

# Rows are stored right-trimmed, so their leading spaces already sit at the
# correct absolute columns and only the tail is missing: pad right.
zeros=$(printf '%*s' "$columns" "" | tr ' ' '0')
logo_bits=$(
  for ((row = 0; row < rows; row++)); do
    printf '%s%s\n' "${uppers[row]}" "${zeros:0:columns - ${#uppers[row]}}"
    printf '%s%s\n' "${lowers[row]}" "${zeros:0:columns - ${#lowers[row]}}"
  done
)

(( columns == 113 )) || fail "the wordmark is 113 columns wide" "got $columns"
(( rows == 9 )) || fail "the wordmark is 9 rows tall" "got $rows"
pass "the wordmark grid is 113 by 9"

# The SVG is on a 15-unit grid: 15 per column, 30 per row (two 15-unit
# half-blocks). Anything else means the two forms no longer share a geometry.
[[ -f $ROOT/logo.svg ]] || fail "logo.svg exists"
svg=$(cat "$ROOT/logo.svg")

viewbox=$(sed -n 's/.*viewBox="0 0 \([0-9]*\) \([0-9]*\)".*/\1 \2/p' <<<"$svg")
[[ $viewbox == "$((columns * 15)) $((rows * 30))" ]] ||
  fail "the viewBox matches the ASCII grid" "expected $((columns * 15)) $((rows * 30)), got '$viewbox'"
pass "the viewBox matches the ASCII grid"

paths=$(grep -o '<path ' <<<"$svg" | wc -l)
(( paths == 10 )) || fail "there is one path per letter" "got $paths"
pass "there is one path per letter"

# Rebuild the occupancy from the SVG's rectangles and compare it to the ASCII.
# A rectangle is "M<x> <y>h<w>v<h>h-<w>z"; x and y are cell coordinates scaled by
# 15, and every cell is either wholly in or wholly out of it.
declare -A svg_cells=()
data=$(grep -o 'd="[^"]*"' <<<"$svg" | sed 's/^d="//; s/"$//' | tr -d '\n')
max_col=0
max_row=0
rest=$data
while [[ $rest =~ ^M([0-9]+)[[:space:]]([0-9]+)h([0-9]+)v([0-9]+)h-([0-9]+)z(.*)$ ]]; do
  x=${BASH_REMATCH[1]}
  y=${BASH_REMATCH[2]}
  width=${BASH_REMATCH[3]}
  height=${BASH_REMATCH[4]}
  rest=${BASH_REMATCH[6]}

  (( x % 15 == 0 && y % 15 == 0 && width % 15 == 0 && height % 15 == 0 )) ||
    fail "every rectangle lands on the 15-unit grid" "M$x $y h$width v$height"

  for ((cell_x = x / 15; cell_x < (x + width) / 15; cell_x++)); do
    for ((cell_y = y / 15; cell_y < (y + height) / 15; cell_y++)); do
      svg_cells[$cell_x,$cell_y]=1
    done
  done

  (( (x + width) / 15 > max_col )) && max_col=$(( (x + width) / 15 ))
  (( (y + height) / 15 > max_row )) && max_row=$(( (y + height) / 15 ))
done
[[ -z $rest ]] || fail "every subpath is a plain rectangle" "trailing: ${rest:0:60}"

(( max_col == columns )) || fail "the SVG is $columns columns wide" "got $max_col"
(( max_row == rows * 2 )) || fail "the SVG is $((rows * 2)) half rows tall" "got $max_row"
pass "the SVG geometry stays inside the ASCII grid"

svg_bits=$(
  for ((half_row = 0; half_row < max_row; half_row++)); do
    line=""
    for ((cell_x = 0; cell_x < max_col; cell_x++)); do
      [[ -n ${svg_cells[$cell_x,$half_row]:-} ]] && line+="1" || line+="0"
    done
    printf '%s\n' "$line"
  done
)

if [[ $svg_bits != "$logo_bits" ]]; then
  diff <(printf '%s\n' "$logo_bits") <(printf '%s\n' "$svg_bits") >&2 || true
  fail "logo.svg reproduces logo.txt cell for cell"
fi
pass "logo.svg reproduces logo.txt cell for cell"

# unbloarchy-show-logo and the branding screensaver both cat this file straight
# into a terminal, so a stray control character or trailing blank would show.
blank_lines=$(grep -c ' $' <<<"$actual" || true)
(( blank_lines == 0 )) || fail "no row is padded with trailing blanks" "$blank_lines rows end in a blank"
[[ $actual != *[[:cntrl:]] ]] || fail "the wordmark carries no control characters"
pass "no row is padded with trailing blanks"

output=$(UNBLOARCHY_PATH="$ROOT" bash "$ROOT/bin/unbloarchy-show-logo")
[[ $output == *"$expected"* ]] || fail "unbloarchy-show-logo prints the wordmark" "got:
$output"
pass "unbloarchy-show-logo prints the wordmark"

# unbloarchy-provision-owner sizes the first-boot banner from the file rather
# than assuming a width, so the longer wordmark must not be clipped by a
# hardcoded fallback.
grep -q 'LOGO_WIDTH=$(awk' "$ROOT/bin/unbloarchy-provision-owner" ||
  fail "the first-boot banner measures logo.txt instead of assuming a width"
pass "the first-boot banner measures logo.txt instead of assuming a width"
