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
JUNTODO는 Spring Boot 기반의 웹 애플리케이션으로, 
jpa, security를 학습하며 docker로 배포하고 jenkins로 ci/cd를 해보자 라는 취지로 시작된 프로젝트입니다.

Spring Security로 세션 기반 로그인·회원가입·비밀번호 변경·로그아웃·회원탈퇴 등을 처리하고,
프론트엔드에서는 JSP와 jQuery(Axios), Toast UI Calendar 캘린더 뷰를 사용하여 개발하였습니다.
CI/CD 파이프라인은 Jenkinsfile를 사용했으며 
git push -> jenkins가 check out ->  gradle로 빌드 -> docker image 생성 ->  AWS EC2(Lightsail) 배포 과정으로 진행되며
Swagger UI로 문서화된 API를 확인할 수 있습니다.  

---

## 배포 도메인

메인: juntodo.site
Swagger : juntodo.site/swagger
Jenkins : 비공개

## 주요 기능
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

## 프로젝트 구조

-*

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

화면 스크린샷






