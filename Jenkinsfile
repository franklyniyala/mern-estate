pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                credentialsId: 'GITHUB_LOGIN',
                url: 'https://github.com/franklyniyala/mern-estate.git'

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