<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/dayjs@1/dayjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <style>
        body {
            background: #f0f0f0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-box {
            background: #fff;
            padding: 40px 30px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            width: 360px;
            text-align: center;
        }
        .login-box h1.logo {
            font-family: serif;
            font-size: 24px;
            margin-bottom: 8px;
        }
        .login-box h2.title {
            font-size: 16px;
            margin-bottom: 30px;
            color: #333;
        }
        .login-box .input-group {
            position: relative;
            margin-bottom: 20px;
        }
        .login-box .input-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .login-box .input-group .eye {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
        }
        .login-box .checkbox-group {
            text-align: left;
            font-size: 13px;
            margin-bottom: 20px;
        }
        .login-box .checkbox-group label {
            cursor: pointer;
        }
        .login-box button {
            width: 100%;
            padding: 12px;
            background: #000;
            border: none;
            border-radius: 999px;
            color: #fff;
            font-size: 16px;
            cursor: pointer;
        }
        .login-box .links {
            margin: 20px 0;
            font-size: 13px;
        }
        .login-box .links a {
            margin: 0 8px;
            color: #666;
            text-decoration: none;
        }
        .login-box .sns-login {
            display: flex;
            justify-content: center;
            gap: 12px;
            margin-top: 20px;
        }
        .login-box .sns-login img {
            width: 36px;
            height: 36px;
            cursor: pointer;
        }
        .login-btn {
            margin-top: -3.5rem;
            margin-bottom: 0rem;
        }
        /* 변경된 에러 메시지 스타일 */
        #errorMsg {
            display: block;
            font-size: 0.9rem;
            color: #dc3545;
            text-align: left;
            margin-top: -12px;
            margin-bottom: 16px;
            padding-left: 4px;
        }
    </style>
</head>

<body>
<div class="login-box">
    <h1 class="logo">JunTodo</h1>
    <h2 class="title">로그인</h2>

        <div class="input-group">
            <input type="text" id="username" name="username" placeholder="아이디를 입력하세요" required />
        </div>
        <div class="input-group">
            <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required />
            <span class="eye" onclick="togglePw()">👁</span>
        </div>

    <div id="errorMsg" class="alert alert-danger mt-3 d-none" role="alert"></div>

        <div class="checkbox-group">
            <label>
<%--                <input type="checkbox" name="remember-me" /> 로그인 유지--%>
            </label>
        </div>
    <button id="loginBtn" type="submit" class="btn btn-dark btn-pill w-100 login-btn" onclick="login()">로그인</button>
    <button id="loginBtn" type="submit" class="btn btn-dark btn-pill w-100" onclick="guestLogin()">게스트 로그인</button>

    <div class="links">
        <a href="${pageContext.request.contextPath}/ui/register">회원가입</a>
<%--        ·--%>
<%--        <a href="${pageContext.request.contextPath}/find-id">비밀번호 찾기</a>--%>
    </div>

    <hr/>

    <!-- 간편 로그인 -->
<%--    <div class="sns-login">--%>
<%--        <img src="${pageContext.request.contextPath}/resources/images/naver.png" alt="네이버"/>--%>
<%--        <img src="${pageContext.request.contextPath}/resources/images/kakao.png" alt="카카오"/>--%>
<%--        <img src="${pageContext.request.contextPath}/resources/images/google.png" alt="구글"/>--%>
<%--        <img src="${pageContext.request.contextPath}/resources/images/apple.png" alt="애플"/>--%>
<%--        <img src="${pageContext.request.contextPath}/resources/images/facebook.png" alt="페이스북"/>--%>
<%--        <img src="${pageContext.request.contextPath}/resources/images/joins.png" alt="Joins"/>--%>
<%--    </div>--%>
</div>
</body>

<script>
    function login() {
        const user = document.getElementById("username").value.trim();
        const pass = document.getElementById("password").value.trim();
        const err  = $('#errorMsg');
        const btn  = document.getElementById("loginBtn");

        $('#errorMsg').addClass('d-none').text('');

        if (!user || !pass) {
            err.removeClass('d-none').text("아이디와 비밀번호를 모두 입력하세요.");
            return;
        }

        // btn.disabled = true;

        axios.post("/api/login", { username:user, password:pass }, { withCredentials:true })
            .then(res => {
                localStorage.setItem("nickname", res.data.nickname);
                window.location.href = "/";
            })
            .catch(e => {
                err.removeClass('d-none').text("아이디 또는 비밀번호를 확인해주세요.");
            })
            .finally(() => btn.disabled = false);
    }

    function togglePw() {
        const pw = document.getElementById('pw');
        pw.type = pw.type === 'password' ? 'text' : 'password';
    }

    function guestLogin() {
        axios.post("/api/settings/guestLogin", {} ,{withCredentials:true})
            .then(res => {
                console.log('guestLogin', res.data.data);
                localStorage.setItem("nickname", res.data.data.result.nickname);
                window.location.href = "/";
            }).catch(err => {
            console.error(err);
        });
    }
</script>

</html>
