pipeline {
    agent none
    tools {
        maven "mymaven"
    }

    parameters {
        string(name: 'ENV', defaultValue: 'TEST', description: 'Environment to deploy')
        booleanParam(name: 'executTests', defaultValue: true, description: 'Decide to run tests')
        choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'])
    }

    stages {
        stage('Compile') {
            agent { label 'slave1' }
            steps {
                echo "Compile the code in ${params.ENV}"
                sh "mvn compile"
            }
        }

        stage('UnitTest') {
            when {
                expression {
                    params.executTests == true
                }
            }
            agent any
            steps {
                echo "Test the code"
                sh "mvn test"
            }

            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Package') {
            agent { label 'slave1' }
            when {
                expression {
                    // Use the 'env.BRANCH_NAME' instead of just 'BRANCH_NAME' to avoid the error
                    return env.BRANCH_NAME == 'update-1'
                }
            }
            input {
                message "Select the version to deploy"
                ok "The version is selected"
                parameters {
                    choice(name: 'NEWAPP', choices: ['1.2', '2.1', '3.1'])
                }
            }
            steps {
                echo "Package the code ${params.APPVERSION}"
                sh "mvn package"
            }
        }
    }
}
