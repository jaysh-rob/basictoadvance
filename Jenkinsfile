pipeline{
	agent none
	tools{
		maven "mymaven"
	}

	parameters{
		string(name: 'ENV', defaultValue: 'TEST', description: 'Environment to deploy')
		booleanParam(name: 'executTests', defaultValue: true, description: 'decided to tun tc')
		choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3']) 
	}

	stages{
		stage('Compile'){
			agent{label 'slave1'}
				steps{
					echo"Compile the code in ${params.ENV}"
					sh "mvn compile"
				}
		
		}

	stage('UnitTest'){
		when{
			expression{
			params.executTests == true
			}
		}
		agent any
	steps{
		echo "Test the code"
		sh "mvn test"
	}

	post{
		always{
			junit 'target/surefire-reports/*.xml'
		}
	}
}

	stage('Package'){
		agent {label 'slave1'}
		input{
			message "Select the version to deploy"
			ok "The version is selected"
			parameters{
				choice(name: 'NEWAPP', choices: ['1.2', '2.1', '3.1']) 
			}
		}
		//agent any 
		steps{
				echo"Package the code ${params.APPVERSION}"
				sh "mvn package"
		}
	}

	}
}