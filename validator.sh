#!/bin/bash

# Colors for better readability
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Regex patterns from your configuration
BRANCH_PATTERN='^(feat|fix|hotfix)\/[a-z0-9-]+$'
COMMIT_PATTERN='^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)\(([a-z0-9-]+)\): .+'
PR_TITLE_PATTERN='^(([a-z0-9-]+))\(([a-z0-9-]+)\)\(([a-z0-9-]+)\): .+\([A-Z]+-[0-9]+\)$'

# Function to validate branch names
validate_branch() {
    echo -e "${BLUE}=== Branch Name Validation ===${NC}"
    echo -e "${YELLOW}Pattern:${NC} $BRANCH_PATTERN"
    echo -e "${YELLOW}Examples:${NC}"
    echo "feat/user-login"
    echo "fix/broken-api"
    echo "hotfix/critical-security-issue"
    echo ""
    
    while true; do
        read -p "Enter a branch name to test (or 'q' to quit): " branch
        
        if [ "$branch" = "q" ]; then
            break
        fi
        
        if echo "$branch" | grep -qE "$BRANCH_PATTERN"; then
            echo -e "${GREEN}✓ Valid branch name${NC}"
        else
            echo -e "${RED}✗ Invalid branch name${NC}"
            echo "Branch name should follow the pattern: (feat|fix|hotfix)/subject"
            echo "Examples:"
            echo "  - feat/new-feature"
            echo "  - fix/bug-fix"
            echo "  - hotfix/critical-bug-fix"
        fi
        echo ""
    done
}

# Function to validate commit messages
validate_commit() {
    echo -e "${BLUE}=== Commit Message Validation ===${NC}"
    echo -e "${YELLOW}Pattern:${NC} $COMMIT_PATTERN"
    echo -e "${YELLOW}Examples:${NC}"
    echo "feat(auth): add user authentication"
    echo "fix(api): resolve timeout issue"
    echo "chore(deps): update dependencies"
    echo ""
    
    while true; do
        read -p "Enter a commit message to test (or 'q' to quit): " commit
        
        if [ "$commit" = "q" ]; then
            break
        fi
        
        if echo "$commit" | grep -qE "$COMMIT_PATTERN"; then
            echo -e "${GREEN}✓ Valid commit message${NC}"
        else
            echo -e "${RED}✗ Invalid commit message${NC}"
            echo "Commit message should follow the pattern: <type>(<scope>): <subject>"
            echo "Allowed types: build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test"
        fi
        echo ""
    done
}

# Function to validate PR titles
validate_pr() {
    echo -e "${BLUE}=== PR Title Validation ===${NC}"
    echo -e "${YELLOW}Pattern:${NC} $PR_TITLE_PATTERN"
    echo -e "${YELLOW}Examples:${NC}"
    echo "feat(auth): add user authentication(TASK-123)"
    echo "fix(api): resolve timeout issue(BUG-456)"
    echo "chore(deps): update dependencies(MAINT-789)"
    echo ""
    
    while true; do
        read -p "Enter a PR title to test (or 'q' to quit): " pr_title
        
        if [ "$pr_title" = "q" ]; then
            break
        fi
        
        if echo "$pr_title" | grep -qE "$PR_TITLE_PATTERN"; then
            echo -e "${GREEN}✓ Valid PR title${NC}"
        else
            echo -e "${RED}✗ Invalid PR title${NC}"
            echo "PR title should follow the pattern: <type>(<scope>): <subject>(<code>)"
            echo "Allowed types: build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test"
            echo "Example: feat(auth): add user authentication(TASK-123)"
        fi
        echo ""
    done
}

# Main menu
while true; do
    echo -e "${BLUE}=== Git Convention Validator ===${NC}"
    echo "What would you like to validate?"
    echo "1. Branch names"
    echo "2. Commit messages"
    echo "3. PR titles"
    echo "4. Exit"
    read -p "Enter your choice (1-4): " choice
    
    case $choice in
        1) validate_branch ;;
        2) validate_commit ;;
        3) validate_pr ;;
        4) echo "Goodbye!"; exit 0 ;;
        *) echo -e "${RED}Invalid choice. Please try again.${NC}" ;;
    esac
    
    echo ""
done