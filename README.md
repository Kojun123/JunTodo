# JunTodo

---

## 목차
- [프로젝트 소개](#프로젝트-소개)
- [기술 스택](#기술-스택)
- [배포 주소](#배포-주소)
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
  [![Spring Batch](https://img.shields.io/badge/Spring%20Batch-6DB33F?logo=spring-batch&logoColor=white)](https://spring.io/projects/spring-batch)

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

메인: https://juntodo.site

Swagger : https://juntodo.site/swagger (로그인 후 확인 가능)

Jenkins : 비공개

---

## 주요 기능

### Spring Security 기반 인증·인가

BCrypt로 비밀번호 암호화

CustomUserDetails와 CustomAuthenticationFilter로 세션 로그인 처리

Role.USER, Role.GUEST, Role.ADMIN 권한 분리

특정 URL은 permitAll로 열어둠(로그인·회원가입·게스트 로그인 등)

### 예외처리 구조

#### ApplicationException 클래스
   
![image](https://github.com/user-attachments/assets/790ae875-13f7-4e66-9af1-972c1932c00c)

- HttpStatus와 메시지를 받는 생성자로 구현

- 생성자 내부에서 super(message) 로 예외 메시지 설정

- getStatus() 메서드로 저장된 HTTP 상태 코드 반환

#### 커스텀 예외 클래스

ApplicationException 을 상속받아 클래스 생성

![image](https://github.com/user-attachments/assets/fcb30700-a321-4bf5-9592-7d0e507c1b6c)

위처럼 super(HttpStatus.CONFLICT, "메시지") 를 호출해 상태 코드와 메시지를 지정

서비스나 컨트롤러 로직에서 조건 검사 후 throw new 커스텀예외()로 호출하여 사용

```plaintext
if (userRepository.existsByNickname(nickname)) {
    throw new DuplicateNicknameException();    
}
```

#### GlobalExceptionHandler (@RestControllerAdvice)

- @ExceptionHandler(ApplicationException.class)

- ApplicationException 발생 시 ApiResponse<Void> 로 { success:false, message, result:null } 반환

HTTP 응답 상태는 ex.getStatus() 로 설정

@ExceptionHandler(RuntimeException.class)

그 외 예상치 못한 예외를 모두 잡아 HTTP 500 + "서버 오류가 발생했습니다." 메시지 반환

응답은 ApiResponse<Void> { success:false, message:"서버 오류가 발생했습니다.", result:null }

### 공통응답

모든 응답을 일관된 JSON 포맷으로 통일

```plaintext
{
  "success": false,
  "message": "에러 메시지",
  "result": null
}
```

![image](https://github.com/user-attachments/assets/cdb01fa9-37ce-4caf-be38-915a22e26786)

예시 : 

![image](https://github.com/user-attachments/assets/ba3b9eee-3192-4a2d-96c0-a7ac25fef6c7)




### Enum

  ![image](https://github.com/user-attachments/assets/2f396c1e-6058-453f-95aa-ab90787b1846)

- 검색 분류(오늘 생성한 할일, 완료한 할일, 전체할일), 검색 필터(SearchFilter) 등

### JPA Auditing

@CreatedDate, @LastModifiedDate으로 생성·수정 타임스탬프 자동 관리

별도 로직 없이 DB에 자동 기록

### 게스트 로그인 && SPRING BATCH 활용하여 생성된지 24시간 지난 게스트 계정 자동삭

게스트 계정 즉시 생성 후 세션 로그인기능.

게스트 계정이 생성된 지 24시간이 지나면 스케줄러(@Scheduled)로 배치(Job)를 실행하여 해당 계정을 자동 삭제

<img width="915" alt="{592F91BB-B820-4E79-B4A3-8B0E3EF16498}" src="https://github.com/user-attachments/assets/2223371c-5af5-4a93-94ab-cb7aeebb6cec" />


Tasklet을 이용해 삭제 로직을 분리하고 Job·Step을 구성해서 진행.

<img width="767" alt="{B30EC1E4-E636-4CC7-9C75-A4E97BC9D994}" src="https://github.com/user-attachments/assets/807d6cd2-eb26-4359-a529-b0b9676fa620" />


배치 데이터는 기본 BATCH_* 테이블에 기록되어, 실행 이력, 성공/실패 여부를 모니터링 가능


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







