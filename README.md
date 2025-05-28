# JUNTODO

---

## 목차
- [프로젝트 소개](#프로젝트-소개)  
- [기능](#기능)  
- [기술 스택](#기술-스택)  
- [사용 예시](#사용-예시)  
- [CI/CD 파이프라인](#cicd-파이프라인)  

---

## 프로젝트 소개
JUNTODO는 Spring Boot 기반의 웹 애플리케이션으로, 계층형 아키텍처(Controller → Service → Repository)와 MySQL 연동 JPA(Hibernate)를 통해 안정적인 데이터 관리를 구현했습니다.  
인증·인가 기능은 Spring Security로 세션 기반 로그인·회원가입·비밀번호 변경·로그아웃·회원탈퇴를 처리하고, 프론트엔드에서는 JSP와 jQuery(Axios), Toast UI Calendar 캘린더 뷰를 사용하여 개발하였습니다.
CI/CD 파이프라인은 Jenkinsfile를 사용했으며 
git push -> jenkins가 check out ->  gradle로 빌드 -> docker image 생성 ->  AWS EC2(Lightsail) 배포 과정으로 진행되며
Swagger UI로 문서화된 API를 편리하게 확인할 수 있습니다.  

---

## 배포 도메인

메인: juntodo.site
Swagger : juntodo.site/swagger
Jenkins : 비공개

## 기능
- 투두 CRUD  
   할 일 생성·조회·수정·삭제  
- 조건 조회  
   오늘 생성한 할 일, 완료된 할 일, 전체 할 일 분류로 조회
- 검색 조회
    제목, 내용, 작성자로 검색하여 조건에 맞는 TODO 조회
- 캘린더 뷰  
   Toast UI Calendar로 일정 시각화  
- 사용자 설정  
   회원가입, 로그인, 비밀번호 변경, 유저명 변경(중복체크), 로그아웃, 회원탈퇴

---

## 기술 스택
- 언어 & 프레임워크  
  - Java 17, Spring Boot, Spring security
- 데이터베이스 & ORM  
  - MYSQL, Spring Data JPA(Hiberante)
- 뷰 & 프론트엔드  
  - JSP, HTML, CSS, JavaScript, jQuery  
  - Bootstrap 5, Toast UI Calendar v2  
- 인프라 & CI/CD  
  - Docker, Jenkins, AWS Lightsail  

---

## 프로젝트 구조



---

## 모니터링

- **UptimeRobot**  
  - **체크 주기**: 5분  
  - **모니터 유형**: HTTPS  
  - **알림**: 개인 이메일


현재 모니터링은 UptimeRobot으로 5분마다 서버를 확인해 생사 여부를 Gmail 알림으로 받고 있습니다.
Lightsail 플랜 성능이 아쉬워 당장은 적극 활용하지 않지만, 향후 인스턴스 업스케일링 후 보다 고도화된 모니터링 솔루션을 도입해볼 예정입니다.

--

*API 호출 예시는 Swagger UI에서 확인해주시기 바랍니다.*  

화면 스크린샷






