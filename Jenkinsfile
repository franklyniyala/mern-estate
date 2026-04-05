pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm

            }
        }

        stage('Build') {
            steps {
                sh 'docker compose build'
            }
        }

        stage('Test') {
            steps {
                sh 'docker compose run --rm app npm test'

            }
        }
    }

    post {
        success {
            echo '✅ Build and test successful!'
        }

        failure {
            echo '❌ Build or test failed.'
        }
    }

}