#!/bin/sh

# Make the hooks executable
chmod +x .github/hooks/pre-commit
chmod +x .github/hooks/commit-msg
chmod +x .github/hooks/pre-push

# Configure Git to use the hooks from the git-hooks directory
git config core.hooksPath .github/hooks

echo "Git hooks have been set up successfully!"
echo "The following hooks are now active:"
echo "  - pre-commit: Runs linting and tests before each commit"
echo "  - commit-msg: Validates commit message format"
echo "  - pre-push: Validates branch naming convention"
echo ""
echo "See WORKFLOW_GUIDELINES.md for more details on the validation rules."