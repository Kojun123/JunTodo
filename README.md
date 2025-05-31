# JUNTODO

---

## 목차
- [프로젝트 소개](#프로젝트-소개)
- [기술 스택](#기술-스택)
- [배포 주소](#배포-주소)
- [간략 기능](#간략-기능)
- [주요 기능 설명](#주요-기능-설명)
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

## 주요 기능 설명

#### 회원가입·로그인 (Spring Security)

- 회원가입

URL : POST /api/settings/register

동작 흐름 :

DTO 유효성 검사 
    @NotBlank(message = "아이디는 필수입니다.") 
    @Pattern(regexp = "^[a-zA-Z0-9]+$", message = "아이디는 공백이 들어갈 수 없으며 영어와 숫자만 가능합니다.") - 영문자, 숫자만 가능하도록 정규식 사용
    
userService.existsById(dto.getUserId()) 로 중복 ID 체크 → 이미 존재하면 400 Bad Request 처리 후 프론트에서 안내 진행

위 과정 통과시 

userService.register(dto) 호출

내부에서 BCryptPasswordEncoder 사용하여 비밀번호 암호화

초기에는 무작위 닉네임 ("사용자" + 랜덤 0~99999) 생성 후 중복 체크, Role USER 세팅후  userRepository.save(user) 호출하여 유저 정보 저장.


- 아이디 중복 확인

URL : GET /api/settings/existsUserId?userId={param}

동작 흐름 :

userService.existsById(userId) -> userRepository.findByUserId(userId).isPresent() 결과 boolean 타입으로 반환(true면 중복되는 아이디, false면 중복되지 않음)

- 게스트 로그인

URL : POST /api/settings/guestLogin

동작 흐름 :

UserService.createGuest() 호출 → 게스트명 생성 "guest" + (int)(Math.random() * 100000) -> 이후 게스트명과 권한 Role.Guest 만 가지고 userRepository.save(guest) 호출하여 게스트 생성

저장된 guest를 CustomUserDetails로 감싸서 Authentication guestAuth = new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());

SecurityContextHolder.getContext().setAuthentication(guestAuth) → 세션에 GUEST 인증 정보 저장 HttpSession session= request.getSession(true);

session.setAttribute(
                HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY,
                SecurityContextHolder.getContext()
        );

HttpSession에 SPRING_SECURITY_CONTEXT_KEY로 인증 정보 저장 → 즉시 로그인 처리

(추후 구현 예정)

매일 자정(@Scheduled(cron = "0 0 0 * * *"))에 Role.GUEST 계정 중 생성 시점으로부터 24시간 지난 사용자들 userRepository.delete(...)로 일괄 삭제

#### 사용자 설정

- 유저 정보 조회
  
URL : GET /api/settings/userInfo

동작 흐름 : 

       CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getUser().getId();
        로 현재 로그인된 아이디 얻어서

userService.getUserInfo(userId) → userRepository.findById(id) 호출하여 유저 정보 UserResponseDto 반환

성공 응답:
{
  "success": true,
  "message": "유저정보 불러오기 성공",
  "result": {
    "id": 5,
    "userId": "example123",
    "nickname": "jun",
    "role": "USER",
    "createdAt": "2025-05-30T14:23:45",
    "updatedAt": "2025-05-30T14:23:45"
  }
}

- 닉네임 중복 확인

URL : GET /api/settings/checkNickname?nickname={새닉네임}

동작 흐름 :

userService.isNicknameAvailable(nickname) 호출 → !userRepository.existsByNickname(nickname) 반환

성공 응답:

json
복사
편집
{
  "success": true,
  "message": "닉네임 중복체크",
  "result": {
    "available": true    // true면 사용 가능, false면 이미 사용 중
  }
}
닉네임 변경

URL

bash
복사
편집
PATCH /api/settings/nickname
Request Body (JSON)

json
복사
편집
{
  "newUsername": "newNick"   // UserNameChangeRequestDto
}
동작 흐름

Authentication에서 CustomUserDetails로 현재 로그인한 userId 조회

userService.changeNickname(userId, newUsername) 호출

DB에서 User user = userRepository.findById(userId) 조회 (없으면 UserNotFoundException)

userRepository.existsByNickname(newUsername) 중복 검사 → 중복 시 DuplicateNicknameException

user.setNickname(newUsername) 후 userRepository.save(user)

성공 응답:

json
복사
편집
{
  "success": true,
  "message": "닉네임 변경 완료",
  "result": {
    "id": 5,
    "userId": "example123",
    "nickname": "newNick",
    "role": "USER",
    "createdAt": "2025-05-30T14:23:45",
    "updatedAt": "2025-06-01T09:12:30"
  }
}
비밀번호 확인

URL

bash
복사
편집
POST /api/settings/checkPassword
Request Body (JSON)

json
복사
편집
{
  "password": "현재비밀번호"   // PasswordCheckRequestDto
}
동작 흐름

Authentication에서 userId 조회

userService.checkCurrentPassword(userId, inputPassword) 호출

DB에서 User user = userRepository.findById(userId) → passwordEncoder.matches(inputPassword, user.getPassword()) 반환

성공 응답:

json
복사
편집
{
  "success": true,
  "message": "비밀번호 확인",
  "result": {
    "valid": true   // true면 일치, false면 불일치
  }
}
비밀번호 변경

URL

bash
복사
편집
PATCH /api/settings/password
Request Body (JSON)

json
복사
편집
{
  "currentPassword": "현재비밀번호",   // PasswordChangeRequestDto
  "newPassword": "새비밀번호123!"
}
동작 흐름

Authentication에서 userId 조회

userService.changePassword(userId, dto) 호출

DB에서 User user = userRepository.findById(userId) (없으면 UserNotFoundException)

passwordEncoder.matches(dto.getCurrentPassword(), user.getPassword()) (불일치 시 InvalidPasswordException)

String newEncoded = passwordEncoder.encode(dto.getNewPassword()) → user.setPassword(newEncoded) → userRepository.save(user)

성공 응답:

json
복사
편집
{
  "success": true,
  "message": "비밀번호가 변경되었습니다.",
  "result": null
}
회원 탈퇴 (유저 삭제)

URL

sql
복사
편집
DELETE /api/settings/user
동작 흐름

Authentication에서 userId 조회

userService.deleteUser(userId) 호출

DB에서 User user = userRepository.findById(userId) (없으면 UserNotFoundException)

userRepository.delete(user)

세션 만료 처리 후 성공 응답:

json
복사
편집
{
  "success": true,
  "message": "회원 탈퇴 완료",
  "result": null
}
3. 할 일 CRUD (ToDo API)
3-1. 조건 조회 (Filter)
URL

pgsql
복사
편집
GET /api/todos?filter={today|completed|all}
파라미터

filter=today → 오늘 생성된 할 일만 조회

filter=completed → 완료된 할 일만 조회

filter=all → 전체 할 일 조회

동작 흐름

TodoController.getTodosByFilter(@RequestParam String filter)

java
복사
편집
List<Todo> todos = switch(filter) {
  case "today"     -> todoService.getTodayTodos();
  case "completed" -> todoService.getCompletedTodos();
  case "all"       -> todoService.getAllTodo();
  default          -> new ArrayList<>();
};
Authentication에서 현재 로그인한 userId 조회 → List<TodoResponseDto> dtoList = todos.stream().map(todo -> new TodoResponseDto(todo, userId)).toList();

성공 응답:

json
복사
편집
{
  "success": true,
  "message": "Todo 카드형 데이터 조회 성공",
  "result": [
    {
      "id": 1,
      "title": "운동하기",
      "description": "매일 아침 7시 공원에서 30분 걷기",
      "dueDate": "2025-06-10",
      "priority": "NORMAL",
      "completed": false,
      "createdAt": "2025-06-01T08:15:00",
      "updatedAt": "2025-06-01T08:15:00",
      "ownerId": 5,        // 로그인한 사용자 ID
      "isMine": true       // 현재 로그인 사용자가 만든 할 일인지 여부
    },
    { … }
  ]
}
3-2. 할 일 생성
URL

bash
복사
편집
POST /api/todos
Request Body (JSON)

json
복사
편집
{
  "title": "회의 준비",
  "description": "내일 10시 팀 미팅 자료 준비",
  "dueDate": "2025-06-10",   // yyyy-MM-dd 형식
  "priority": "HIGH"        // Enum: LOW, NORMAL, HIGH
}
동작 흐름

TodoController.createTodo(@RequestBody Todo todo) 호출

todoService.addTodo(todo) 내부:

java
복사
편집
Authentication auth = SecurityContextHolder.getContext().getAuthentication();
CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
User user = userDetails.getUser();

todo.setUser(user);
Todo saved = todoRepository.save(todo);
return saved;
TodoResponseDto responseDto = new TodoResponseDto(saved, userId) 생성

성공 응답:

json
복사
편집
{
  "success": true,
  "message": "Todo 생성 완료",
  "result": {
    "id": 10,
    "title": "회의 준비",
    "description": "내일 10시 팀 미팅 자료 준비",
    "dueDate": "2025-06-10",
    "priority": "HIGH",
    "completed": false,
    "createdAt": "2025-06-01T14:22:00",
    "updatedAt": "2025-06-01T14:22:00",
    "ownerId": 5,
    "isMine": true
  }
}
3-3. 할 일 상세 조회
URL

bash
복사
편집
GET /api/todos/{id}
동작 흐름

TodoController.getTodoById(@PathVariable Long id) 호출

Todo todo = todoService.getTodoById(id) (ID가 없으면 todo == null → 404 Not Found)

Authentication에서 userId 가져와 TodoResponseDto dto = new TodoResponseDto(todo, userId)

성공 응답:

json
복사
편집
{
  "success": true,
  "message": "Todo 상세 조회 성공",
  "result": {
    "id": 3,
    "title": "영화 보기",
    "description": "주말에 신작 영화 예매하기",
    "dueDate": "2025-06-08",
    "priority": "LOW",
    "completed": false,
    "createdAt": "2025-05-29T20:10:00",
    "updatedAt": "2025-05-29T20:10:00",
    "ownerId": 5,
    "isMine": true
  }
}
3-4. 할 일 수정
URL

bash
복사
편집
PATCH /api/todos/{id}
Request Body (JSON)

json
복사
편집
{
  "title": "회의 자료 최종 확인",
  "description": "발표 자료 PPT 점검 완료",
  "dueDate": "2025-06-10",
  "priority": "NORMAL",
  "completed": true
}
동작 흐름

TodoController.updateTodo(@PathVariable Long id, @RequestBody Todo todo) 호출

todoService.verifyTodoOwner(id, userId) → Todo todoEntity = todoRepository.findById(id) → 작성자(userId)와 일치하지 않으면 AccessDeniedException

todoService.updateTodo(id, todo) → DB 업데이트

성공 응답(코드상 문자열 반환):

scss
복사
편집
수 정 완 료 (200 OK)
3-5. 할 일 삭제
URL

bash
복사
편집
DELETE /api/todos/{id}
동작 흐름

TodoController.deleteTodo(@PathVariable Long id) 호출

todoService.verifyTodoOwner(id, userId) (작성자 검증)

boolean isDel = todoService.deleteTodo(id)

내부: todoRepository.deleteById(id) 실행 후 true 반환

성공 시 204 No Content 응답

3-6. 기간별 조회 (캘린더용)
URL

pgsql
복사
편집
GET /api/todos/by-date?year={yyyy}&month={MM}
예시

sql
복사
편집
GET /api/todos/by-date?year=2025&month=06
동작 흐름

TodoController.getTodosByYearMonth(@RequestParam String year, @RequestParam String month) 호출

todoService.getTodosByYearMonth(year, month, userId) →

java
복사
편집
int y = Integer.parseInt(year);
int m = Integer.parseInt(month);
List<Todo> list = todoRepository.findByCreatedAtYearMonth(y, m);
return list.stream()
           .map(todo -> new TodoResponseDto(todo, userId))
           .collect(Collectors.toList());
성공 응답:

json
복사
편집
{
  "success": true,
  "message": "Todo 캘린더형 데이터 리스트 조회 성공",
  "result": [
    { /* TodoResponseDto 객체들 */ }
  ]
}
3-7. 검색 조회 (Search)
URL

pgsql
복사
편집
GET /api/todos/search?keyword={검색어}&filter={TITLE|DESCRIPTION|USERNAME}
예시

sql
복사
편집
GET /api/todos/search?keyword=회의&filter=TITLE
GET /api/todos/search?keyword=공원&filter=DESCRIPTION
GET /api/todos/search?keyword=jun&filter=USERNAME
동작 흐름

TodoController.searchTodo(@RequestParam String keyword, @RequestParam String filter) 호출

내부에서 SearchFilter searchFilter = SearchFilter.from(filter);

TITLE, DESCRIPTION, USERNAME 중 하나여야 함(대소문자 무시). 잘못된 값이면 searchFilter == null → 빈 결과 반환.

SearchFilter.TITLE → todoRepository.findBytitleContaining(keyword)
SearchFilter.DESCRIPTION → todoRepository.findBydescriptionContaining(keyword)
SearchFilter.USERNAME → todoRepository.findByUser_nicknameContaining(keyword)

반환된 List<Todo>를 List<TodoResponseDto>로 매핑 후 응답:

json
복사
편집
{
  "success": true,
  "message": "검색 완료",
  "result": [
    { /* TodoResponseDto 객체들 */ }
  ]
}
4. 예외 처리 (GlobalExceptionHandler)
GlobalExceptionHandler.java (@ControllerAdvice) 덕분에 발생 가능한 예외를 통일된 JSON으로 반환

UserNotFoundException

발생 위치: userRepository.findById(id).orElseThrow(UserNotFoundException::new)

응답

json
복사
편집
{
  "success": false,
  "message": "사용자를 찾을 수 없습니다.",
  "result": null
}
HTTP Status: 404 Not Found

DuplicateNicknameException

발생 위치: if(userRepository.existsByNickname(newNickname)) throw new DuplicateNicknameException();

응답

json
복사
편집
{
  "success": false,
  "message": "이미 사용 중인 닉네임입니다.",
  "result": null
}
HTTP Status: 409 Conflict

InvalidPasswordException

발생 위치: if(!passwordEncoder.matches(...)) throw new InvalidPasswordException();

응답

json
복사
편집
{
  "success": false,
  "message": "비밀번호가 유효하지 않습니다.",
  "result": null
}
HTTP Status: 400 Bad Request

AccessDeniedException

발생 위치: if(!todo.getUser().getId().equals(userId)) throw new AccessDeniedException("작성자가 아닙니다.");

응답

json
복사
편집
{
  "success": false,
  "message": "작성자가 아닙니다.",
  "result": null
}
HTTP Status: 403 Forbidden

그 외 MethodArgumentNotValidException, HttpMessageNotReadableException 등도 모두 CustomErrorResponse 형태로 일관된 JSON 리턴

5. JPA Auditing (생성·수정 시간 자동 관리)
모든 User 엔티티와 Todo 엔티티에는 @CreatedDate createdAt, @LastModifiedDate updatedAt 애노테이션이 달려 있어서

레코드 삽입 시점 createdAt 자동 저장, 수정 시점 updatedAt 자동 갱신

따라서 별도 로직 없이 DB 칼럼에 자동으로 타임스탬프가 찍힘

6. 단위 테스트 (JUnit5) & CI/CD 파이프라인 (Jenkins)
단위 테스트

src/test/java/com/example/eightmonthcheckpoint/ 하위에

EightMonthCheckpointApplicationTests.java (컨텍스트 로딩 테스트)

UserTest.java (UserService 로직 검증)

로컬 및 CI 환경에서 ./gradlew test 명령으로 실행 → 테스트 통과 여부 확인

CI/CD (Jenkins)

리포지토리 최상단에 있는 Jenkinsfile 사용

SCM 체크아웃: GitHub에서 git push 이벤트 발생 시 Jenkins 빌드 트리거

단위 테스트 실행: ./gradlew test → 테스트 통과 시 다음 단계로 진행

애플리케이션 빌드: ./gradlew bootJar 또는 docker build → Docker 이미지 생성

배포: AWS Lightsail 인스턴스에 docker-compose.yaml (또는 docker run) 명령으로 컨테이너 배포

(추후) 스케줄링 배치: GUEST 계정 24시간 자동 삭제 배치 추가 예정 → Jenkinsfile에 크론 잡 설정

7. Swagger UI (OpenAPI) 자동 문서
URL

arduino
복사
편집
https://juntodo.site/swagger-ui/index.html
(Springdoc 버전에 따라 /swagger-ui.html 또는 /swagger-ui/index.html 중 하나일 수 있음)

동작

@Operation 애노테이션이 달린 모든 컨트롤러 메서드를 자동 스캔하여

API 엔드포인트 목록, Request/Response DTO 스펙, 예시 바디 등을 UI로 제공

개발자는 Swagger UI를 통해 실시간으로 API 호출 테스트 가능

8. UI 라우팅 (JSP) & 정적 리소스
UIController (/ui 기준)

GET /ui/customLogin → resources/templates/customLogin.html (로그인 폼)

GET /ui/register → resources/templates/register.html (회원가입 폼)

정적 리소스

src/main/resources/static/css/style.css

src/main/resources/static/js/script.js

src/main/resources/templates/fragment/header.html 등으로 레이아웃 구성

Toast UI Calendar (v2)

프론트엔드 JSP에서 <script src="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.js"></script> 등으로

/api/todos/by-date?year=yyyy&month=MM 결과를 이벤트 객체로 매핑하여 캘린더에 뿌림

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







