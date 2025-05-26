```markdown
# 🌟 zxTODOxz
<br/>

## 👨‍💻 프로젝트 소개

-소개초안

<br/>

## 🔧 기술 스택
Language : JAVA17, JSP
Framework : SpringBoot 3.2.5, Spring Security, Spring Data JPA
DB : MYSQL8
Infra/DevOps : Docker, Jenkins, AWS Lightsail
Build : Gradle
Frontend : HTML, CSS(BootStrap5), JQUERY, Toast UI
API_DOCS : SWAGGER

<br/>

## 💡 주요 기능

| 기능 | 설명 |
|------|------|
| 📝 할일 CRUD | 제목, 설명, 마감일 등을 등록/수정/삭제 |
| 🔼 우선순위 정렬 | 사용자 지정 우선순위로 리스트 자동 정렬 |
| 📅 D-Day 기능 | 남은 일수 자동 계산 및 표기 |
| 🗓️ 뷰 전환 | 카드형 보기 ↔ 캘린더 보기 (Toast UI Calendar) |
| 🔐 로그인 기능 | Spring Security 기반 세션 로그인 |
| 📁 REST API 제공 | Swagger UI를 통해 테스트 가능 |

<br/>

## 🛠️ 프로젝트 구조

zxTODOxz
├── src
│   ├── main
│   │   ├── java (Spring Backend)
│   │   ├── resources
│   │   └── webapp (JSP, JS, CSS)
├── Dockerfile
├── Jenkinsfile
├── build.gradle
├── README.md

<br/>

## 🚀 CI/CD & 배포 구조

[GitHub]
   ↓ Push 감지 (Jenkins가 Git을 pull)
[Jenkins (서버 내부에서 실행 중)]
   ↓ ./gradlew build → .war 생성
   ↓ docker build → 이미지 생성
   ↓ docker push → DockerHub로 푸시
   ↓ ssh로 AWS Lightsail에 접속
[AWS Lightsail (Ubuntu + Docker 설치됨)]
   ↓ docker pull → 새 이미지 받아옴
   ↓ 기존 컨테이너 stop + rm
   ↓ 새 컨테이너 run → 배포 완료

* Jenkins `Jenkinsfile` 기반 멀티 스테이지 파이프라인 작성
* Docker 이미지 자동 푸시 및 Lightsail 서버에서 재배포
* `.war` 파일을 Tomcat 10 기반 Docker 컨테이너로 실행 (스프링부트 3버전 이상은 Tomcat 10을 사용해야됨.)

<br/>

## 📸 화면 예시

<br/>

## 🙋‍♂️ 만든 사람
권오준 : kwonojou@gmail.com 
<br/>

## 📌 프로젝트 목적
* 실무에 가까운 Spring + JSP 프로젝트 구조 학습
* Jenkins + Docker 기반 CI/CD 파이프라인 직접 구성
* 실서버 운영 환경 경험 (AWS Lightsail 활용)
* 포트폴리오 및 이력서용 백엔드 개발 역량 증명
