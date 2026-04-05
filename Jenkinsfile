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

        stage('SonarCloud Scan') {
            steps {
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                    sh '''
                    docker run --rm \
                    -e SONAR_TOKEN=$SONAR_TOKEN \
                    -v $(pwd):/usr/src \
                    sonarsource/sonar-scanner-cli \
                    -Dsonar.projectKey=frank-org_mern-app \
                    -Dsonar.organization=frank-org \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=https://sonarcloud.io
                    '''
                }
            }
        }

    

        stage('Build') {
            steps {
                sh 'docker compose build'
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'DOCKER_LOGIN',
                    usernameVariable: 'DOCKER_USERNAME',
                    passwordVariable: 'DOCKER_PASSWORD'
                )])
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh '''
                echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                docker tag mern-application-client $DOCKER_USERNAME/mern-application-client:latest
                docker tag mern-application-api $DOCKER_USERNAME/mern-application-api:latest
                docker push $DOCKER_USERNAME/mern-application-client:latest
                docker push $DOCKER_USERNAME/mern-application-api:latest
                '''
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
            echo '✅ Build and pushed successful!'
            echo '✅ Application deployed successfully!'
        }

        failure {
            echo '❌ Build or test failed.'
        }
    }

}