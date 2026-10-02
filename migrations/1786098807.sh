echo "Relink agent skill symlinks to default/agents/skills/unbloarchy"

mkdir -p ~/.agents/skills ~/.claude/skills ~/.codex/skills ~/.pi/agent/skills
ln -sfn "$UNBLOARCHY_PATH/default/agents/skills/unbloarchy" ~/.agents/skills/unbloarchy
ln -sfn "$UNBLOARCHY_PATH/default/agents/skills/unbloarchy" ~/.claude/skills/unbloarchy
ln -sfn "$UNBLOARCHY_PATH/default/agents/skills/unbloarchy" ~/.codex/skills/unbloarchy
ln -sfn "$UNBLOARCHY_PATH/default/agents/skills/unbloarchy" ~/.pi/agent/skills/unbloarchy
