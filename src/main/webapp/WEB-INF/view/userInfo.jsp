<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>유저정보</title>

    <!-- bootstrap cdn -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">내 계정 설정</h2>

    <div class="card mb-4">
        <div class="card-header">내 정보</div>
        <div class="card-body">
            <p><strong>아이디:</strong> <span id="username">불러오는 중...</span></p>
            <p><strong>이메일:</strong> <span id="email">불러오는 중...</span></p>
            <p><strong>가입일:</strong> <span id="createdAt">불러오는 중...</span></p>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header">비밀번호 변경</div>
        <div class="card-body">
            <form id="passwordForm">
                <div class="mb-3">
                    <label for="currentPassword" class="form-label">현재 비밀번호</label>
                    <input type="password" class="form-control" id="currentPassword" required>
                </div>
                <div class="mb-3">
                    <label for="newPassword" class="form-label">새 비밀번호</label>
                    <input type="password" class="form-control" id="newPassword" required>
                </div>
                <button type="submit" class="btn btn-primary">비밀번호 변경</button>
            </form>
        </div>
    </div>

    <div class="text-end">
        <a href="/todos?filter=my" class="btn btn-outline-secondary">내 Todo 바로가기</a>
    </div>

</div>


<script>
</script>


</body>
</html>
