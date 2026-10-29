# An upgrade, or a run of unbloarchy-setup-git, can have set the identity already.
if [[ -z $(git config --global user.name) || -z $(git config --global user.email) ]]; then
  unbloarchy-notification-send -u critical -g  "$(unbloarchy-i18n firstRun.gitTitle)" "$(unbloarchy-i18n firstRun.gitBody)" \
    --exec unbloarchy-launch-floating-terminal-with-presentation unbloarchy-setup-git
fi
