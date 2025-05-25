pipeline {
  agent any
  environment {
    REGISTRY = 'kwonojun/zxtodoxz'
    IMAGE    = "${REGISTRY}/my-app:${GIT_COMMIT.take(7)}"
    SSH_CRED = 'lightsail-ssh'
    DOCKER_CRED = 'dockerhub-cred'
  }
  stages {
    stage('Checkout') {
      steps { git url: 'https://github.com/Kojun123/zxTODOxz.git', branch: 'main' }
    }
    stage('Build & Test') {
      steps { sh 'mvn clean package -DskipTests=false' }
    }
    stage('Docker Build & Push') {
      steps {
        script {
          docker.build(IMAGE)
          docker.withRegistry('', DOCKER_CRED) { docker.image(IMAGE).push() }
        }
      }
    }
    stage('Deploy to Lightsail') {
      steps {
        sshagent([SSH_CRED]) {
          sh """
            ssh -o StrictHostKeyChecking=no ubuntu@3.36.121.32 '
              docker pull ${IMAGE} &&
              docker stop eight-app || true &&
              docker rm eight-app || true &&
              docker run -d --name eight-app \\
                --network host \\
                -e SPRING_PROFILES_ACTIVE=prod \\
                -e MYSQL_URL=jdbc:mysql://127.0.0.1:3306/dbname \\
                -e SERVER_PORT=8080 \\
                ${IMAGE}
            '
          """
        }
      }
    }
  }
  post {
    success { echo '배포 성공' }
    failure { echo '배포 실패' }
  }
}
