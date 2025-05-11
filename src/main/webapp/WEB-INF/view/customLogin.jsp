<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>로그인</title>
    <link rel="stylesheet" href="/css/index.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
</head>
<body>
<div class="container d-flex justify-content-center align-items-center" style="height: 100vh;">
    <div class="card shadow-lg p-4" style="width: 400px;">
        <h3 class="text-center mb-4">🔐 로그인</h3>

        <div>
            <div class="mb-3">
                <label for="username" class="form-label">아이디</label>
                <input type="text" id="username" class="form-control" />
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">비밀번호</label>
                <input type="password" id="password" class="form-control" />
            </div>

            <div id="errorMsg" class="alert alert-danger mt-3 d-none" role="alert"></div>

            <div class="d-grid mt-4">
                <button id="loginBtn" onclick="login()" class="btn btn-primary">
                    <span id="loginText">로그인</span>
                    <span id="loginSpinner" class="spinner-border spinner-border-sm d-none"></span>
                </button>
                <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary mt-3">회원가입</a>
            </div>
        </div>
    </div>
</div>

<script>
    function login() {
        const username = document.getElementById("username").value.trim();
        const password = document.getElementById("password").value.trim();
        const errorBox = document.getElementById("errorMsg");
        const loginBtn = document.getElementById("loginBtn");
        const loginText = document.getElementById("loginText");
        const loginSpinner = document.getElementById("loginSpinner");

        if (!username || !password) {
            errorBox.textContent = "아이디와 비밀번호를 모두 입력하세요.";
            errorBox.classList.remove("d-none");
            return;
        }

        loginBtn.disabled = true;
        loginText.classList.add("d-none");
        loginSpinner.classList.remove("d-none");
        errorBox.classList.add("d-none");

        axios.post("/api/login", { username: username, password: password },{withCredentials : true})
            .then(res => {
                localStorage.setItem("username", username);
                window.location.href = "/";
            })
            .catch(err => {
                errorBox.textContent = "아이디 또는 비밀번호를 확인하세요.";
                errorBox.classList.remove("d-none");
            })
            .finally(() => {
                loginBtn.disabled = false;
                loginText.classList.remove("d-none");
                loginSpinner.classList.add("d-none");
            });
    }
</script>

</body>
</html>
