echo "Activate the Unbloarchy theme for existing T3 Code installs"

unbloarchy-pkg-present t3code-bin || exit 0
unbloarchy-install-ai-t3-code
