# WORKFLOW GUIDELINES

A lightweight and customizable Git workflow setup designed to enforce code quality standards and commit message conventions.
It integrates seamlessly with GitHub Actions to automatically validate pull requests, ensuring consistent and clean code before merging.

## Features

- **Pre-commit Validation**: Runs linting and tests before each commit.
- **Commit Message Enforcement**: Ensures all commit messages follow the [Conventional Commits](https://www.conventionalcommits.org/) format
- **Branch Name Validation**: Validates branch names follow the team's naming convention
- **PR Title Validation**: Ensures PR titles include ticket references and follow conventions
- **Beautiful Error Messages**: User-friendly, detailed error messages when validation fails

## Git Hooks Setup

This project uses Git hooks to enforce code quality standards and commit message conventions.

### First-time setup

After cloning the repository, run the setup script to configure Git hooks:

```bash
# Make the setup script executable
chmod +x setup-hooks.sh

# Run the setup script
./setup-hooks.sh
```

## Validation Rules

### Branch Names

Branch names must follow the pattern: `(feat|fix|hotfix)/[a-z0-9-]+`

**✓ Valid Examples:**

- `feat/user-authentication`
- `fix/api-timeout`
- `hotfix/security-patch`

**✗ Invalid Examples:**

- `feature/login` (wrong type prefix)
- `feat_user_auth` (wrong separator)
- `fix/CamelCase` (contains uppercase)
- `hotfix-security` (wrong separator)

### Commit Messages

Commit messages must follow the pattern: `<type>(<scope>): <subject>`

**✓ Valid Examples:**

- `feat(auth): add password strength meter`
- `fix(api): resolve timeout issue`
- `chore(deps): update dependencies`

**✗ Invalid Examples:**

- `added new feature` (missing format)
- `feat: add login` (missing scope)
- `feature(auth): add login` (wrong type)
- `fix(api) fix timeout` (missing colon)

**Allowed Types:**

- `build`: Changes affecting build system or dependencies
- `chore`: Maintenance tasks, no production code change
- `ci`: Changes to CI configuration files/scripts
- `docs`: Documentation only changes
- `feat`: New feature
- `fix`: Bug fix
- `perf`: Performance improvement
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `revert`: Revert to a previous commit
- `style`: Formatting, missing semi colons, etc; no code change
- `test`: Adding missing tests, refactoring tests

### PR Titles

PR titles must follow the pattern: `<type>(<scope>): <subject>(<code>)`

**✓ Valid Examples:**

- `feat(auth): add user authentication(TASK-123)`
- `fix(api): resolve timeout issue(BUG-456)`
- `chore(deps): update dependencies(MAINT-789)`

**✗ Invalid Examples:**

- `feat(auth): add user authentication` (missing ticket code)
- `fix(api): resolve timeout issue (BUG-456)` (extra space before ticket)
- `chore(deps): update dependencies(task123)` (wrong ticket format)

## Workflow Stages

### 1. Pre-commit Hook

Before each commit

- Runs linting: `mock up lint`
- Runs tests: `mock up test`
- Validates commit message format

### 2. Pre-push Hook

Before each push

- Validates branch name format

### 3. GitHub Actions (PR Validation)

Before PR creation

- Validates branch name
- Validates PR title
- Validates all commit messages in the PR
- Runs linting and tests
- Runs SonarQube analysis

### 4. GitHub Actions (Post-merge to Dev)

After merge to dev branch

- Runs full SonarQube analysis
- Notifies team of successful build

```

```
