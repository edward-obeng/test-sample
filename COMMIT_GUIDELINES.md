# Git Hooks Enforcer

A lightweight, customizable setup for enforcing code quality and commit message standards in your Git workflow.

## 🚀 Features

- ✅ **Pre-commit Validation**: Runs linting and tests before each commit.
- ✅ **Commit Message Enforcement**: Ensures all commit messages follow the [Conventional Commits](https://www.conventionalcommits.org/) format
- ✅ **Beautiful Error Messages**: User-friendly, detailed error messages when validation fails

## 📋 Requirements

- Node.js (v14 or higher)
- npm (v6 or higher)
- Git

## 🔧 Installation

1. **Clone this repository or copy its files to your project**

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Initialize Husky**

   ```bash
   npm run prepare
   ```

## 🛠️ How It Works

### Pre-commit Hook

The pre-commit hook runs your linting and test scripts before allowing a commit. This ensures code quality standards are met before code is committed.

### Commit Message Hook

The commit-msg hook validates that your commit messages follow the Conventional Commits format:

```
<type>: <description>
```

Where `<type>` is one of:

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

## 📝 Examples

### Valid Commit Messages

```
feat: add user authentication
fix: resolve issue with login form
docs: update API documentation
chore: update dependencies
```

### Invalid Commit Messages

```
added new feature
fixing bug
updated docs
```
