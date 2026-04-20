pipeline {
    agent any

        environment {
            AWS_REGION = 'us-east-1'
            REPOSITORY_URI = '139156132664.dkr.ecr.us-east-1.amazonaws.com/mern-estate-repo'
            IMAGE_TAG = '${BUILD_NUMBER}'
        }

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
                    -Dsonar.projectKey=frank-org_mern-estate \
                    -Dsonar.organization=frank-org \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=https://sonarcloud.io
                    '''
                }
            }
        }

        stage('Login to ECR') {
            steps {
                withCredentials([aws(credentialsId: 'AWS_ECR_LOGIN', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $REPOSITORY_URI
                    ''' 
                }
            }
        }

    

        stage('Build') {
            steps {
                sh 'docker compose build'
                sh 'docker tag mern-app:$IMAGE_TAG $REPOSITORY_URI:$IMAGE:TAG'
            }
        }


        stage('Push to ECR') {
            steps {
                sh 'docker push $REPOSITORY_URI:$IMAGE_TAG'
            }
        }
    }

    post {
        success {
            echo ' ✅ SonarCloud Analysis successful!'
            echo ' ✅ Build and pushed to ECR successful!'
            echo 'Pushed image: $REPOSITORY_URI:$IMAGE_TAG'
        }

        failure {
            echo '❌ Build or test failed.'
        }
    }

}