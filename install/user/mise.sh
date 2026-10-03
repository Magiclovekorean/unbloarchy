# Upgrades must not delete the version a running process is executing from:
# mise up would prune the old install dir out from under a live session.
mise settings set upgrade.auto_prune false

unbloarchy-mise-install codex
unbloarchy-mise-install claude
unbloarchy-mise-install crush
unbloarchy-mise-install antigravity-cli agy
unbloarchy-mise-install gh
unbloarchy-mise-install copilot
unbloarchy-mise-install opencode
unbloarchy-mise-install npm:playwright playwright
unbloarchy-mise-install pi
unbloarchy-mise-install github:can1357/oh-my-pi omp
unbloarchy-mise-install grok
# Cursor's own installer links the same path, so a re-provision keeps it.
unbloarchy-cmd-missing cursor-agent && unbloarchy-mise-install cursor-agent
unbloarchy-mise-install npm:@kitlangton/ghui ghui
unbloarchy-mise-install aqua:modem-dev/hunk hunk
unbloarchy-mise-install npm:cf cf
unbloarchy-mise-install github:OpenRouterLabs/ori-releases ori
if unbloarchy-cmd-missing muse; then
  unbloarchy-mise-install "http:muse[url=https://api.meta.ai/muse-launcher.sh,bin=muse,version_list_url=https://api.meta.ai/muse-code/channels/muse-stable,version_json_path=.version]" muse
fi
