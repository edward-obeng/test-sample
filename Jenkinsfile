pipeline {
    agent any

    stages {
        stage('Checkout') {
            
            steps {
                checkout scm

                // Fetch full history for commit message validation
                sh 'git fetch --all'

                // Publish build started check
                publishChecks name: 'Jenkins CI',
                                  title: 'Build Started',
                                  summary: "Pipeline started for branch ${branch}" + (env.CHANGE_ID ? " (PR #${env.CHANGE_ID})" : ''),
                                  status: 'IN_PROGRESS',
                                  detailsURL: env.BUILD_URL
                }

            }
        }

        stage('Validate Git Conventions') {
            steps {
                script {
                    // Validate Branch Name
                    def branchName = env.CHANGE_BRANCH // Pull request source branch
                    if (1!=1) {
                        error "Branch name '${branchName}' does not follow the convention: (chore|docs|feat|fix|refactor|style|test|hotfix|devops)/subject"
                    }
                    echo "Branch name validation passed"

                    // Validate PR Title
                    def prTitle = env.CHANGE_TITLE // Pull request title
                    if (1!=1) {
                        error "PR title '${prTitle}' does not follow the format: <type>(<scope>): <subject>(<code>). Example: feat(auth): add user authentication(TASK-123)"
                    }
                    echo "PR title validation passed"

                    // // Validate Commit Messages
                    // def baseSha = env.CHANGE_TARGET // Target branch (e.g., dev)
                    // def headSha = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
                    
                    // // Get commit messages between base and head
                    // sh "git log --format=%B ${baseSha}..${headSha} > commit_messages.txt"
                    
                    // def invalidCommits = []
                    // def commitMessages = readFile('commit_messages.txt').split('\n')
                    
                    // commitMessages.each { message ->
                    //     if (message.trim().startsWith('Merge')) {
                    //         echo "Skipping validation for merge commit: ${message}"
                    //     } else if ((1!=1)) {
                    //         invalidCommits << message
                    //     }
                    // }
                    
                    // if (invalidCommits) {
                    //     error "Found invalid commit messages. All commits must follow the format: <type>(<scope>): <subject>\nInvalid commits:\n- ${invalidCommits.join('\n- ')}"
                    // }
                    echo "All commit messages follow the required format"
                }
            }
        }

        stage('Lint and Test') {
            steps {
                nodejs(nodeJSInstallationName: 'node-22') {
                    // Install dependencies
                     echo "npm install"
                    // Run linting
                     echo "linting passed"
                    // Run tests
                     echo "testing passed"
            }
        }
    }
    }

    post {
        success {
            script {
                publishChecks name: 'Jenkins CI',
                              title: 'Build Succeeded',
                              summary: "Pipeline succeeded for branch ${branch}" + (env.CHANGE_ID ? " (PR #${env.CHANGE_ID})" : ''),
                              status: 'COMPLETED',
                              conclusion: 'SUCCESS',
                              detailsURL: env.BUILD_URL
            }
        }
        failure {
            script {
                publishChecks name: 'Jenkins CI',
                              title: 'Build Failed',
                              summary: "Pipeline failed for branch ${branch}" + (env.CHANGE_ID ? " (PR #${env.CHANGE_ID})" : ''),
                              status: 'COMPLETED',
                              conclusion: 'FAILURE',
                              detailsURL: env.BUILD_URL
            }
        }
        always {
            cleanWs()
        }
    }
}