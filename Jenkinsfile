pipeline {
    agent {
        any // Assumes a Jenkins agent with this label
    }

    environment {
        NODE_VERSION = '22" // Matches GitHub Actions Node.js version
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
                // Fetch full history for commit message validation
                sh 'git fetch --depth=0'
            }
        }

        stage('Validate Branch Name') {
            steps {
                script {
                    def branchName = env.CHANGE_BRANCH // Pull request source branch
                    if (!branchName.matches('^(chore|docs|feat|fix|refactor|style|test|hotfix|devops)/[a-z0-9-]+$')) {
                        error "Branch name '${branchName}' does not follow the convention: (chore|docs|feat|fix|refactor|style|test|hotfix|devops)/subject"
                    }
                    echo "Branch name validation passed"
                }
            }
        }

        stage('Validate PR Title') {
            steps {
                script {
                    def prTitle = env.CHANGE_TITLE // Pull request title
                    if (!prTitle.matches('^([a-z0-9-]+)\\(([a-z0-9-]+)\\): .+\\([A-Z]+-[0-9]+\\)$')) {
                        error "PR title '${prTitle}' does not follow the format: <type>(<scope>): <subject>(<code>). Example: feat(auth): add user authentication(TASK-123)"
                    }
                    echo "PR title validation passed"
                }
            }
        }

        stage('Validate Commit Messages') {
            steps {
                script {
                    // Get base and head SHAs for the PR
                    def baseSha = env.CHANGE_TARGET // Target branch (e.g., dev)
                    def headSha = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
                    
                    // Get commit messages between base and head
                    sh "git log --format=%B ${baseSha}..${headSha} > commit_messages.txt"
                    
                    def invalidCommits = []
                    def commitMessages = readFile('commit_messages.txt').split('\n')
                    
                    commitMessages.each { message ->
                        if (message.trim().startsWith('Merge')) {
                            echo "Skipping validation for merge commit: ${message}"
                        } else if (message.trim() && !message.trim().matches('^(chore|docs|feat|fix|refactor|style|test)\\(([a-z0-9-]+)\\): .+')) {
                            invalidCommits << message
                        }
                    }
                    
                    if (invalidCommits) {
                        error "Found invalid commit messages. All commits must follow the format: <type>(<scope>): <subject>\nInvalid commits:\n- ${invalidCommits.join('\n- ')}"
                    }
                    echo "All commit messages follow the required format"
                }
            }
        }

        stage('Set up Node.js') {
            steps {
                nodejs(nodeJSInstallationName: 'Node 17') { // Assumes Node 17 is configured in Jenkins
                    sh 'node --version'
                    sh 'npm --version'
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                nodejs(nodeJSInstallationName: 'Node 17') {
                    sh 'npm ci'
                }
            }
        }

        stage('Run Linting') {
            steps {
                nodejs(nodeJSInstallationName: 'Node 22') {
                    sh 'npm run lint'
                }
            }
        }

        stage('Run Tests') {
            steps {
                nodejs(nodeJSInstallationName: 'Node 22') {
                    sh 'npm run test'
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean workspace after the build
        }
        failure {
            echo 'One or more checks failed. Please review the logs.'
        }
    }
}