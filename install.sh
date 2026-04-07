#!/bin/bash
set -e

REPO_RAW="https://raw.githubusercontent.com/lucataco/replicate-opencode-plugin/main"

echo "Installing Replicate plugin for OpenCode..."

# Create required directories
mkdir -p .opencode/plugins .opencode/skills/replicate

# Download plugin
curl -sSL "$REPO_RAW/plugins/replicate.ts" -o .opencode/plugins/replicate.ts

# Download skill
curl -sSL "$REPO_RAW/skills/replicate/SKILL.md" -o .opencode/skills/replicate/SKILL.md

# Keep generated OpenCode files out of version control
if [ ! -f .opencode/.gitignore ]; then
  printf 'node_modules\npackage.json\npackage-lock.json\nbun.lock\n.gitignore\n' > .opencode/.gitignore
fi

# Handle package.json -- don't clobber existing
if [ ! -f .opencode/package.json ]; then
  curl -sSL "$REPO_RAW/package.json" -o .opencode/package.json
elif ! grep -q '"@opencode-ai/plugin"' .opencode/package.json; then
  echo "Note: .opencode/package.json exists but is missing the required dependency."
  echo "  Add this to your dependencies: \"@opencode-ai/plugin\": \"1.3.17\""
fi

echo ""
echo "Replicate plugin installed successfully!"
echo ""
echo "Next steps:"
echo "  1. Set your API token:  export REPLICATE_API_TOKEN=r8_your_token_here"
echo "  2. Start OpenCode:      opencode"
