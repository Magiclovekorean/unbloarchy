# Set identification from install inputs
if [[ -n ${UNBLOARCHY_USER_NAME//[[:space:]]/} ]]; then
  git config --global user.name "$UNBLOARCHY_USER_NAME"
fi

if [[ -n ${UNBLOARCHY_USER_EMAIL//[[:space:]]/} ]]; then
  git config --global user.email "$UNBLOARCHY_USER_EMAIL"
fi
