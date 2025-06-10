pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                // Fetch full history for commit message validation
                sh 'git fetch --all'
                // Publish build started status
                githubNotify context: 'Jenkins CI',
                             description: 'Build Started',
                             status: 'PENDING',
                             targetUrl: env.BUILD_URL
            }
        }

        stage('Validate Git Conventions') {
            steps {
                script {
                    // Validate Branch Name
                    def branchName = env.CHANGE_BRANCH ?: env.BRANCH_NAME
                    if (!branchName.matches('.+')) {
                        error "Branch name '${branchName}' cannot be empty"
                    }
                    echo "Branch name validation passed"

                    // Validate PR Title
                    def prTitle = env.CHANGE_TITLE
                    if (env.CHANGE_ID && !prTitle.matches('.+')) {
                        error "PR title '${prTitle}' cannot be empty"
                    }
                    echo "PR title validation passed"

                    // Validate Commit Messages
                    def baseSha = env.CHANGE_TARGET ?: 'origin/main' // Fallback to main if not a PR
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
                nodejs(nodeJSInstallationName: 'node-22') {
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
        success {
            githubNotify context: 'Jenkins CI',
                         description: 'Build Succeeded',
                         status: 'SUCCESS',
                         targetUrl: env.BUILD_URL
        }
        failure {
            githubNotify context: 'Jenkins CI',
                         description: 'Build Failed',
                         status: 'FAILURE',
                         targetUrl: env.BUILD_URL
        }
        always {
            cleanWs()
        }
    }
}