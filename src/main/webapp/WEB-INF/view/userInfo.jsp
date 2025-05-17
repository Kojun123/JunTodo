<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>유저정보</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/dayjs@1/dayjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script> <!--confirm 꾸며줌 -->

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/sidebar.css">
    <link rel="stylesheet" href="/css/userInfo.css">

    <style>
        body {
            margin: 0;
            background-color: #f9f9f9;
        }

        .wrapper {
            display: flex;
        }

        .main-content {
            margin-left: 250px; /* 사이드바 너비 */
            padding: 2rem;
            width: 100%;
        }
    </style>
</head>

<body>

<div class="wrapper">
    <jsp:include page="sidebar.jsp"/>

    <div class="main-content">
        <div class="d-flex justify-content-center align-items-center mt-5">
            <div class="card profile-card p-4 text-center">
                <img src="https://i.pravatar.cc/100?u=6" class="rounded-circle mx-auto mb-3" width="100" height="100">
                <strong><h5 id="username">유저명 : </h5></strong>
                <p>아이디: <span id="userId">-</span></p>
                <p>가입일: <span id="createdAt">-</span></p>
                <p>권한: <span id="role">권한 : </span></p>

                <a href="#" class="btn btn-outline-primary mt-3" data-bs-toggle="modal" data-bs-target="#editUserNmModal">유저명 변경</a>
                <a href="#" class="btn btn-outline-secondary mt-2">비밀번호 변경</a>
                <a href="#" class="btn btn-danger mt-2">탈퇴하기</a>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="editUserNmModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">유저명 변경</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="nicknameForm">
                    <div class="mb-3">
                        <label for="newUserNm" class="form-label">새 유저명</label>
                        <input type="text" class="form-control" id="newUserNm" name="newUserNm" required>
                        <div id="userNmValidError" class="form-text text-danger"></div>
                    </div>
                    <button type="button" class="btn btn-primary w-100" onclick="changeNickName()">변경</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        getUserInfo();
    });

    function getUserInfo() {
        axios.get(`/api/settings/userInfo`)
            .then(response => {
                const responseData = response.data.data;
                const createdAt = dayjs(responseData.createdAt).format('YYYY-MM-DD');

                $('#username').text("유저명 : " + responseData?.username);
                $('#userId').text(responseData?.id);
                $('#createdAt').text(createdAt);
                $('#role').text(responseData?.role);
            })
    }

    function changeNickName() {
        let newUserNm = $('#newUserNm').val();
        $('#userNmValidError').text('');

        axios.patch(`/api/settings/changeNickName`, {
            newUsername: newUserNm
        })
            .then(response => {
                const data = response.data;
                if (data.success) {
                    alert(data.message);
                    const modal = bootstrap.Modal.getInstance(document.getElementById('editUserNmModal'));
                    modal.hide();
                    getUserInfo();
                } else {
                    $('#userNmValidError').text(data.message);
                }
            })
            .catch(error => {
                if (error.response?.data?.message) {
                    $('#userNmValidError').text(error.response.data.message);
                } else {
                    $('#userNmValidError').text("알 수 없는 오류가 발생했습니다.");
                }
            });
    }
</script>

</body>
</html>
