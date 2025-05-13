<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>유저정보</title>

    <!-- bootstrap cdn -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/userInfo.css">
    <script src="https://cdn.jsdelivr.net/npm/dayjs@1/dayjs.min.js"></script> <!-- date 파싱용 -->
</head>
<body>

<div class="container-fluid">
    <div class="row">

        <nav class="col-md-3 col-lg-2 d-md-block sidebar py-4">
            <div class="list-group">
                <a href="/ui/settings" class="list-group-item list-group-item-action active">내 정보</a>
                <a href="/todos?filter=my" class="list-group-item list-group-item-action">내 할 일</a>
                <a href="#" class="list-group-item list-group-item-action">비밀번호 변경</a>
            </div>
        </nav>


        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-center align-items-center mt-5">
                <div class="card profile-card p-4 text-center">
<%--                    <img src="/img/default-profile.png" class="rounded-circle mx-auto mb-3" width="120" height="120" alt="Profile">--%>
                    <h5 id="nickname">유저아이디</h5>
<%--                    <p class="text-muted" id="useremail">이메일</p>--%>
                    <p>가입일: <span id="createdAt">-</span></p>
                    <p>권한: <span id="role">USER</span></p>

                    <a href="#" class="btn btn-outline-primary mt-3">내 정보 수정</a>
                    <a href="#" class="btn btn-outline-secondary mt-2">비밀번호 변경</a>
                    <a href="#" class="btn btn-danger mt-2">탈퇴하기</a>
                </div>
            </div>
        </main>
    </div>
</div>

<script>

    $(document).ready(function() {
        getUserInfo();
    })

    function getUserInfo() {
        axios.get(`/api/settings/userInfo`)
            .then(response => {
                console.log('userInfo', response);
                let responseData = response.data;

                let createdAt = response.data.createdAt;
                let formatCreatedAt = dayjs(createdAt).format('YYYY-MM-DD');

                $('#nickname').text(responseData?.name);
                $('#createdAt').text(formatCreatedAt);
                $('#role').text(responseData?.role);
            })
    }

</script>


</body>
</html>
