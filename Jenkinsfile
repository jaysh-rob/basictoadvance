pipeline {
    agent none
    tools {
        maven "mymaven"
    }

    environment {
        DEV_SERVER_IP = 'ec2-user@172.31.2.225'
        DEPLOY_SERVER_IP = 'ec2-user@172.31.11.173'
        IMAGE_NAME = 'jackdhub/jdk-mvn-addressbook'
    }

    parameters {
        string(name: 'Env', defaultValue: 'Test', description: 'Environment to deploy')
        booleanParam(name: 'executeTests', defaultValue: true, description: 'Decide to run tests')
        choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'])
    }

    stages {
        stage('Compile') { //slave1 --- /tmp/workspace
            agent any
            steps {
                echo "Compile the code in ${params.Env}"
                sh "mvn compile"
            }
        }

        stage('UnitTest') { //slave1 -- /tmp/workspace
			agent any
            when {
                expression {
                    params.executeTests == true
                }
            }
            // agent any
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

        stage('Package+push the image to registry') { //slave2 -- /var/lib/jenkins/workspace
            agent any
            steps {
                script {
                    sshagent(['slave2']) {
                        withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                            echo "Package the code ${params.APPVERSION}"
                            sh "scp -o StrictHostKeyChecking=no server-script.sh ${DEV_SERVER_IP}:/home/ec2-user"
                            sh "ssh -o StrictHostKeyChecking=no ${DEV_SERVER_IP} 'bash ~/server-script.sh ${IMAGE_NAME} ${BUILD_NUMBER}'"
                            //sh "ssh ${DEV_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
							sh "ssh ${DEV_SERVER_IP} 'echo ${PASSWORD} | sudo docker login --username ${USERNAME} --password-stdin'"
                            sh "ssh ${DEV_SERVER_IP} sudo docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                        }
                    }
                }
            }
        }

        stage('Deploy') { //slave2 -- /var/lib/jenkins/workspace
            // when {
            //     expression {
            //         BRANCH_NAME == 'docker-1'
            //     }
            // }
            agent any
            // input {
            //     message "Select the version to deploy"
            //     ok "Version selected"
            //     parameters {
            //         choice(name: 'NEWAPP', choices: ['1.2', '2.1', '3.1'])
            //     }
            // }
            steps {
                script {
                    sshagent(['slave3']) {
                        withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                            echo "Deploy the code ${params.NEWAPP}"
							sh "ssh-keyscan -H ${DEPLOY_SERVER_IP} >> ~/.ssh/known_hosts"
                            sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER_IP} sudo yum install docker -y"
                            sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER_IP} sudo systemctl start docker"
                            sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                            sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER_IP} sudo docker run -itd -p 9991:8080 ${IMAGE_NAME}:${BUILD_NUMBER}"
                        }
                    }
                }
            }
        }
    }
}
