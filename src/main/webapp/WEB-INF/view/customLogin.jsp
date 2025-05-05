<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>로그인</title>
    <link rel="stylesheet" href="/css/index.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container d-flex justify-content-center align-items-center" style="height: 100vh;">
    <div class="card shadow-lg p-4" style="width: 400px;">
        <h3 class="text-center mb-4">🔐 로그인</h3>

        <form method="post" action="/doLogin">
            <div class="mb-3">
                <label for="username" class="form-label">아이디</label>
                <input type="text" name="username" id="username" class="form-control" required />
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">비밀번호</label>
                <input type="password" name="password" id="password" class="form-control" required />
            </div>

            <%
                if (request.getParameter("error") != null) {
            %>
            <div class="alert alert-danger mt-3" role="alert">
                ❌ 로그인 실패! 아이디 또는 비밀번호를 확인하세요.
            </div>
            <%
                }
                if (request.getParameter("logout") != null) {
            %>
            <div class="alert alert-success mt-3" role="alert">
                👋 로그아웃 되었습니다.
            </div>
            <%
                }
            %>

            <div class="d-grid mt-4">
                <button type="submit" class="btn btn-primary">로그인</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
