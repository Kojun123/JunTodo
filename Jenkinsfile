pipeline {
  agent any  // 어떤 에이전트에서든 실행 가능하도록

   options {
    disableConcurrentBuilds()  // 동시에 여러 빌드 못 돌리게 막음 (현재 서버 스펙이 좋지않아 두개 이상이면 서버터짐..)
  }

  environment {
    REGISTRY = 'kwonojun/zxtodoxz'  // DockerHub 이미지 저장소
    IMAGE    = "${REGISTRY}:${GIT_COMMIT.take(7)}"  // 커밋 해시 기반 태그 이미지 이름
    SSH_CRED = 'lightsail-ssh'  // Jenkins에 저장된 SSH 키 (Lightsail 접속용)
    DOCKER_CRED = 'dockerhub-cred'  // DockerHub 로그인용 Jenkins 자격증명 ID
  }

  parameters {
    booleanParam(
      name: 'DEPLOY',
      defaultValue: false,
      description: '체크시 Lightsail에 배포.'  // 사용자가 수동으로 체크할 수 있는 파라미터 싱글파이프라인에서 사용됨
    )
  }

  stages {

    stage('Checkout') {
      steps {
        // GitHub에서 코드 가져오기
        git url: 'https://github.com/Kojun123/zxTODOxz.git', branch: 'main'
      }
    }

    stage('Build & Test') {
      steps {
        // Gradle 빌드 및 테스트 스킵 (prod 버전으로)
        //sh './gradlew clean build -Dspring.profiles.active=prod'
        sh './gradlew clean build -x test -Dspring.profiles.active=prod'
      }
    }

    stage('Docker Build & Push') {
      steps {
        script {
          // Docker 이미지 빌드
          docker.build(IMAGE)
          // DockerHub에 이미지 푸시
          docker.withRegistry('', DOCKER_CRED) {
            docker.image(IMAGE).push()
          }
        }
      }
    }

    stage('Deploy to Lightsail') {
      when {
        // DEPLOY 파라미터를 true로 체크한 경우에 실행함
        expression {
          return params.DEPLOY == true
        }
      }
      steps {
        // SSH 연결로 Lightsail 서버에 접속 후 Docker 컨테이너 실행
        sshagent([SSH_CRED]) {
          sshagent([SSH_CRED]) {
            sh """
    ssh -o StrictHostKeyChecking=no ubuntu@3.39.87.232 '
      docker pull ${IMAGE} &&
      docker stop eight-app || true &&
      docker rm eight-app || true &&
      docker run -d --name eight-app \\
        --network host \\
        -e SPRING_PROFILES_ACTIVE=prod \\
        -e MYSQL_URL=jdbc:mysql://127.0.0.1:3306/dbname \\
        ${IMAGE}
    '
  """
}

        }
      }
    }
  }
  /* 최신 이미지 가져오기 -> 기존 컨테이너 중지 -> 기존 컨테이너 삭제 -> 새 컨테이너 실행 -> host 네트워크 모드 사용 -> spring profile 지정
    db주소 -> 서버포트 -> 이미지실행
  */


  post {
    success {
      echo '배포 성공'  // 빌드 성공 메시지
    }
    failure {
      echo '배포 실패'  // 빌드 실패 메시지
    }
  }
}
