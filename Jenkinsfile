pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                // Fetch full history for commit message validation
                sh 'git fetch --all'
            }
        }

        stage('Validate Git Conventions') {
            steps {
                script {
                    // Validate Branch Name
                    def branchName = env.CHANGE_BRANCH // Pull request source branch
                    if (!branchName.matches('.+')) {
                        error "Branch name '${branchName}' cannot be empty"
                    }
                    echo "Branch name validation passed"

                    // Validate PR Title
                    def prTitle = env.CHANGE_TITLE // Pull request title
                    if (!prTitle.matches('.+')) {
                        error "PR title '${prTitle}' cannot be empty"
                    }
                    echo "PR title validation passed"

                    // Validate Commit Messages
                    def baseSha = env.CHANGE_TARGET // Target branch (e.g., dev)
                    def headSha = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
                    
                    // Get commit messages between base and head
                    sh "git log --format=%B ${baseSha}..${headSha} > commit_messages.txt"
                    
                    def invalidCommits = []
                    def commitMessages = readFile('commit_messages.txt').split('\n')
                    
                    commitMessages.each { message ->
                        if (message.trim().startsWith('Merge')) {
                            echo "Skipping validation for merge commit: ${message}"
                        } else if (!message.trim()) {
                            invalidCommits << message
                        }
                    }
                    
                    if (invalidCommits) {
                        error "Found empty commit messages.\nInvalid commits:\n- ${invalidCommits.join('\n- ')}"
                    }
                    echo "All commit messages are valid"
                }
            }
        }

        stage('Lint and Test') {
            steps {
                nodejs(nodeJSInstallationName: 'Node 22') {
                    // Install dependencies
                    sh 'npm ci'
                    // Run linting
                    sh 'npm run lint'
                    // Run tests
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