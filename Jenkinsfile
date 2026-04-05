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


        stage('Deploy') {
            steps {
                sh 'docker compose up -d'
            }
        }
    }

    post {
        success {
            echo '✅ Build successful!'
            echo '✅ Application deployed successfully!'
        }

        failure {
            echo '❌ Build or test failed.'
        }
    }

}