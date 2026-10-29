# A language the install media preset (/etc/unbloarchy/language) becomes this
# user's desktop language; the system step generated its locale.
code=
[[ -r /etc/unbloarchy/language ]] && read -r code </etc/unbloarchy/language
if [[ -n $code ]]; then
  "$UNBLOARCHY_PATH/bin/unbloarchy-language" seed "$code" || echo "Could not set the preset language $code" >&2
fi
