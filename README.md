# JUNTODO

---

## 목차
- [프로젝트 소개](#프로젝트-소개)
- [기술 스택](#기술-스택)
- [배포 주소](#배포-주소)
- [간략 기능](#간략-기능)
- [주요 기능](#주요-기능)
- [프로젝트 구조](#프로젝트-구조)  
- [모니터링](#모니터링)
- [화면 스크린샷](#화면-스크린샷)

---

## 프로젝트 소개
JUNTODO는 Spring Boot 기반의 웹 애플리케이션으로, 

jpa, security를 학습하며 docker로 배포하고 jenkins로 ci/cd를 해보자 라는 취지로 시작된 프로젝트입니다.

Spring Security로 세션 기반 로그인·회원가입·비밀번호 변경·로그아웃·회원탈퇴 등을 처리하고,

프론트엔드에서는 JSP와 jQuery(Axios), Toast UI Calendar 캘린더 뷰를 사용하여 개발하였습니다.

CI/CD 파이프라인은 Jenkinsfile를 사용했으며 

git push -> jenkins가 check out ->  gradle로 빌드 -> docker image 생성 ->  AWS EC2(Lightsail) 배포 과정으로 진행되며

Swagger UI로 문서화된 API를 확인할 수 있습니다.  

---

## 기술 스택

- **언어 & 프레임워크**  
  [![Java](https://img.shields.io/badge/Java-17-blue?logo=java&logoColor=white)](https://www.java.com/)  
  [![Spring Boot](https://img.shields.io/badge/Spring%20Boot-green?logo=spring&logoColor=white)](https://spring.io/projects/spring-boot)  
  [![Spring Security](https://img.shields.io/badge/Spring%20Security-green?logo=spring&logoColor=white)](https://spring.io/projects/spring-security)

- **데이터베이스 & ORM**  
  [![MySQL](https://img.shields.io/badge/MySQL-blue?logo=mysql&logoColor=white)](https://www.mysql.com/)  
  [![Spring Data JPA](https://img.shields.io/badge/Spring%20Data%20JPA-green?logo=spring&logoColor=white)](https://spring.io/projects/spring-data-jpa)  
  [![Hibernate](https://img.shields.io/badge/Hibernate-orange?logo=hibernate&logoColor=white)](https://hibernate.org/)

- **뷰 & 프론트엔드**  
  [![JSP](https://img.shields.io/badge/JSP-grey?logo=java&logoColor=white)](https://javaee.github.io/javaee-spec/jsp/)  
  [![HTML5](https://img.shields.io/badge/HTML5-E34F26?logo=html5&logoColor=white)](https://developer.mozilla.org/ko/docs/Web/Guide/HTML/HTML5)  
  [![CSS3](https://img.shields.io/badge/CSS3-1572B6?logo=css3&logoColor=white)](https://developer.mozilla.org/ko/docs/Web/CSS)  
  [![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=black)](https://developer.mozilla.org/ko/docs/Web/JavaScript)  
  [![jQuery](https://img.shields.io/badge/jQuery-0769AD?logo=jquery&logoColor=white)](https://jquery.com/)  
  [![Bootstrap](https://img.shields.io/badge/Bootstrap-5.0-purple?logo=bootstrap&logoColor=white)](https://getbootstrap.com/)  
  [![Toast UI Calendar](https://img.shields.io/badge/Toast%20UI%20Calendar-v2-blue)](https://ui.toast.com/tui-calendar)

- **인프라 & CI/CD**  
  [![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)  
  [![Jenkins](https://img.shields.io/badge/Jenkins-D24939?logo=jenkins&logoColor=white)](https://www.jenkins.io/)  
  [![AWS Lightsail](https://img.shields.io/badge/AWS%20Lightsail-FF9900?logo=amazonaws&logoColor=white)](https://aws.amazon.com/lightsail/)

  ---

## 배포 주소

메인: juntodo.site
Swagger : juntodo.site/swagger
Jenkins : 비공개

## 간략 기능
- 투두 CRUD  
   할 일 생성·조회·수정·삭제  
- 조건 조회
   오늘 생성된 할 일, 완료된 할 일, 전체 할 일을 각각 분류해 조회할 수 있는 기능
- 검색 조회
   제목 내용 작성자를 기준으로 키워드 검색해 조건에 맞는 TODO를 조회할 수 있는 기능
- 캘린더 뷰  
   Toast UI Calendar로 일정 시각화  
- 회원가입/로그인/게스트 로그인
- 사용자 설정 페이지
   비밀번호 변경, 유저명 변경, 회원탈퇴

---

## 주요 기능

### Spring Security 기반 인증·인가

BCrypt로 비밀번호 암호화

CustomUserDetails와 CustomAuthenticationFilter로 세션 로그인 처리

Role.USER, Role.GUEST, Role.ADMIN 권한 분리

특정 URL은 permitAll로 열어둠(로그인·회원가입·게스트 로그인 등)

### Global Exception Handling

@RestControllerAdvice + @ExceptionHandler 사용

모든 예외를 CustomErrorResponse 형태로 통일해서 반환

UserNotFound, DuplicateNickname, InvalidPassword, AccessDenied 등 커스텀 예외 처리

- Enum 활용
- 검색 분류(오늘 생성한 할일, 완료한 할일, 전체할일), 검색 필터(SearchFilter) 등

### JPA Auditing

@CreatedDate, @LastModifiedDate으로 생성·수정 타임스탬프 자동 관리

별도 로직 없이 DB에 자동 기록

### 게스트 로그인 & 배치 삭제

Role.GUEST 계정 즉시 생성 후 세션 로그인

@Scheduled(cron="0 0 0 * * *")로 24시간 지난 GUEST 계정 일괄 삭제

### Toast UI Calendar 사용하여 캘린더뷰 구현

### Swagger(OpenAPI) 자동 문서화

@Operation으로 API 스펙 자동 생성
juntodo.site 로그인 후 /swagger 입력하여 확인 가능.

### CI/CD 파이프라인

Jenkinsfile에 테스트 → 빌드 → Docker 이미지 생성 → AWS Lightsail 배포 단계

주요 업데이트가 있을 때마다 

![image](https://github.com/user-attachments/assets/1ee02b71-02ba-4406-bc17-2af393ffeeb1)

눌러서 수동 배포 진행


### 단위 테스트(JUnit5)

---

## 프로젝트 구조

```plaintext
└── zxTODOxz-main
    ├── .gitignore
    ├── Dockerfile
    ├── Jenkinsfile
    ├── README.md
    ├── build.gradle
    ├── gradlew
    ├── gradlew.bat
    ├── settings.gradle
    ├── src
    │   ├── main
    │   │   ├── java
    │   │   │   └── com
    │   │   │       └── example
    │   │   │           └── eightmonthcheckpoint
    │   │   │               ├── TTTODoApplication.java
    │   │   │               ├── config
    │   │   │               │   ├── AppConfig.java
    │   │   │               │   ├── SwaggerConfig.java
    │   │   │               │   └── WebMvcConfig.java
    │   │   │               ├── controller
    │   │   │               │   ├── AuthController.java
    │   │   │               │   ├── LectureController.java
    │   │   │               │   ├── MainController.java
    │   │   │               │   ├── TodoController.java
    │   │   │               │   └── UserController.java
    │   │   │               ├── domain
    │   │   │               │   ├── Lecture.java
    │   │   │               │   ├── Todo.java
    │   │   │               │   └── User.java
    │   │   │               ├── dto
    │   │   │               │   ├── LectureDto.java
    │   │   │               │   ├── TodoDto.java
    │   │   │               │   └── UserDto.java
    │   │   │               ├── exception
    │   │   │               │   ├── CustomErrorResponse.java
    │   │   │               │   ├── GlobalExceptionHandler.java
    │   │   │               │   └── NotFoundException.java
    │   │   │               ├── repository
    │   │   │               │   ├── LectureRepository.java
    │   │   │               │   ├── TodoRepository.java
    │   │   │               │   └── UserRepository.java
    │   │   │               ├── security
    │   │   │               │   ├── CustomAuthenticationFilter.class
    │   │   │               │   ├── CustomUserDetailService.class
    │   │   │               │   └── CustomUserDetails.class
    │   │   │               └── service
    │   │   │                   ├── LectureService.java
    │   │   │                   ├── TodoService.java
    │   │   │                   └── UserService.java
    │   │   └── resources
    │   │       ├── static
    │   │       │   ├── css
    │   │       │   │   └── style.css
    │   │       │   └── js
    │   │       │       └── script.js
    │   │       ├── templates
    │   │       │   ├── fragment
    │   │       │   │   └── header.html
    │   │       │   ├── index.html
    │   │       │   ├── lecture-list.html
    │   │       │   ├── todo-form.html
    │   │       │   ├── todoCalendar.html
    │   │       │   ├── todoList.html
    │   │       │   └── userInfo.html
    │   │       └── application.properties
    │   └── test
    │       └── java
    │           └── com
    │               └── example
    │                   └── eightmonthcheckpoint
    │                       ├── EightMonthCheckpointApplicationTests.java
    │                       └── UserTest.java
    ├── web
    │   └── WEB-INF
    │       └── web.xml
    └── zxTODOxz-main.iml
```

---

## 모니터링

- **UptimeRobot**  
  - **체크 주기**: 5분  
  - **모니터 유형**: HTTPS  
  - **알림**: 개인 이메일


현재 모니터링은 UptimeRobot으로 5분마다 서버를 확인해 생사 여부를 Gmail 알림으로 받고 있습니다.
Lightsail 플랜 성능이 아쉬워 당장은 적극 활용하지 않지만, 향후 인스턴스 업스케일링 후 보다 고도화된 모니터링 솔루션을 도입해볼 예정입니다.

--

*API 호출 예시는 Swagger UI에서 확인할 수 있습니다.*
## 화면 스크린샷

# 로그인 화면
![image](https://github.com/user-attachments/assets/76cff383-0a74-4ad3-b542-0b40d17f71a9)

# 회원가입 화면

![image](https://github.com/user-attachments/assets/d254a0aa-5708-4e62-be99-ed30149c0197)



# 화면 대시보드
![image](https://github.com/user-attachments/assets/04a17f41-1573-42cd-981f-00b7a60e67ff)

# 캘린더뷰 
![image](https://github.com/user-attachments/assets/0caef165-2e91-4511-9ccd-3ff1c300beea)

# 유저정보
![image](https://github.com/user-attachments/assets/d5286a29-7f82-495b-90eb-70acfc053b9f)



#젠킨스
![image](https://github.com/user-attachments/assets/d3e374bb-e2c0-4675-8f25-ad1afdb6ca50)

# swagger
![image](https://github.com/user-attachments/assets/ae90d32e-32c2-4429-8014-5f358d6c2de5)







