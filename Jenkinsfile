pipeline{
	agent none
	tools{
		maven "mymaven"
	}

	parameters{
		string(name: 'ENV', defaultValue: 'TEST', description: 'Environment to deploy')
		booleanParam(name: 'executTests', defaultValue: true, description: 'decided to tun tc')
		choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'], description: '') 
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
		agent any
	steps{
		echo "Test the code"
		sh "mvn test"
	}
}

	stage('Package'){
		agent {label 'slave1'}
		steps{
				echo"Package the code"
				sh "mvn package"
		}
	}

	}
}