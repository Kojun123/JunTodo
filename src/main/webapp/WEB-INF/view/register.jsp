<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>회원가입</title>
    <link rel="stylesheet" href="/css/index.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container d-flex justify-content-center align-items-center" style="height: 100vh;">
    <div class="card shadow-lg p-4" style="width: 400px;">
        <h3 class="text-center mb-4">📝 회원가입</h3>

        <!-- 성공/실패 메시지 -->
        <%
            if (request.getParameter("error") != null && request.getParameter("error").equals("exists")) {
        %>
        <div class="alert alert-danger" role="alert">
            ❌ 이미 존재하는 아이디입니다.
        </div>
        <%
            }
            if (request.getParameter("registerSuccess") != null) {
        %>
        <div class="alert alert-success" role="alert">
            ✅ 회원가입이 완료되었습니다! 로그인 해 주세요.
        </div>
        <%
            }
        %>

        <form method="post" action="${pageContext.request.contextPath}/register">
            <div class="mb-3">
                <label for="userId" class="form-label">아이디</label>
                <input type="text" name="userId" id="userId" class="form-control" required />
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">비밀번호</label>
                <input type="password" name="password" id="password" class="form-control" required />
            </div>

            <div class="d-grid mt-4">
                <button type="submit" class="btn btn-success">가입하기</button>
            </div>
        </form>

        <div class="text-center mt-3">
            <a href="/customLogin">이미 계정이 있으신가요? 로그인</a>
        </div>
    </div>
</div>
</body>
</html>
