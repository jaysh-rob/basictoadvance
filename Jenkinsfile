pipeline{
    agent none
    tools{
        maven 'mymaven'
    }

    environment{
        DEV_SERVER_IP='ec2-user@172.31.2.225'
    }

    parameters {
        string(name: 'ENV', defaultValue: 'TEST', description: 'this is the envirnoment to be set')
        booleanParam(name: 'Test', defaultValue: true, description: 'SKip the Test stage')
        choice(name: 'APPVERSION', choices: ['1.5', '2.5', '3.5'])
    }

    stages{
        stage('compile'){
			agent any
            steps{
                echo "This is the compile stage ${params.ENV}"
                sh 'mvn compile'
            }
            
        }

        stage('Test'){
			 agent {label 'slave1'}

             when{
                expression{
                    ${params.Test} == true
                }
            }
                steps{
                    echo "This is the test stage"
                    sh 'mvn test'
                }
        post{
            always{
                junit 'target/surefire-reports/*.xml'
            }
        }
        }

        stage('Package'){
			agent any
            when{
                expression{
                    BRANCH_NAME == 'update-2'
                }

                input {
                    message "Select the APP Version"
                    ok "Application Version selected"
                    parameters {
                    choice(name: 'NEWAPP', choices: ['1.1', '2.2', '3.3'])
                }
            }
            }

            steps{
                script{
                    sshagent(['slave2']){
                echo "This is the package stage ${params.APPVERSION}"
                sh "scp -o StrictHostKeyChecking=no server-script.sh ${DEV_SERVER_IP}:/home/ec2-user"
                sh "ssh -o StrictHostKeyChecking=no ${DEV_SERVER_IP} 'bash ~/server-script.sh"
                    }
                }
            }
        }
    }
}