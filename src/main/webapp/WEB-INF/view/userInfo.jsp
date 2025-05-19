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
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/sidebar.css">
    <link rel="stylesheet" href="/css/userInfo.css">
</head>

<body>
<div class="wrapper">
    <jsp:include page="sidebar.jsp"/>

    <div class="main-content">
        <div class="d-flex justify-content-center align-items-center mt-5">
            <div class="card profile-card p-4 text-center">
                <div class="position-relative d-inline-block">
                    <img src="https://i.pravatar.cc/100?u=6" class="rounded-circle mb-3" width="100" height="100">
                    <span class="position-absolute top-0 start-100 translate-middle p-1 bg-light border border-secondary rounded-circle">
                        <i class="bi bi-camera"></i>
                    </span>
                </div>
                <strong><h5 id="nickname">유저명 : </h5></strong>
                <p>아이디: <span id="userId">-</span></p>
                <p>가입일: <span id="createdAt">-</span></p>
                <p>권한: <span id="role">권한 : </span></p>

                <a href="#" class="btn btn-outline-primary mt-3" data-bs-toggle="modal" data-bs-target="#editUserNmModal">유저명 변경</a>
                <a href="#" class="btn btn-outline-primary mt-3" data-bs-toggle="modal" data-bs-target="#editPasswordChangeModal">비밀번호 변경</a>
                <a href="#" class="btn btn-danger mt-2">탈퇴하기</a>
            </div>
        </div>
    </div>
</div>

<!-- 유저명 변경 모달 -->
<div class="modal fade" id="editUserNmModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <h5 class="modal-title">유저명 변경</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="nicknameForm">
                    <table class="table">
                        <tbody>
                        <tr>
                            <th>현재 유저명</th>
                            <td><span id="currentNickname">(불러오는중)</span></td>
                        </tr>
                        <tr>
                            <th>변경할 유저명</th>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <input type="text" class="form-control" id="newUserNm" name="newUserNm" required style="flex: 1;">
                                    <button type="button" class="btn btn-outline-secondary" onclick="checkNicknameDuplication()">중복확인</button>
                                </div>
                                <div id="userNmValidError" class="form-text text-danger"></div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                    <div class="text-end">
                        <button type="button" id="nickNameChangeConfirmBtn" class="btn btn-primary" onclick="changeNickName()" disabled>완료</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- 비밀번호 변경 모달 -->
<div class="modal fade" id="editPasswordChangeModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <h5 class="modal-title">비밀번호 변경</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="PasswordForm">
                    <table class="table">
                        <tbody>
                        <tr>
                            <th>현재 비밀번호</th>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <input type="text" class="form-control" id="currentPassword" name="currentPassword" required style="flex: 1;">
                                    <button type="button" class="btn btn-outline-secondary" onclick="checkPassword()">확인</button>
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <th>새로운 비밀번호</th>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <input type="text" class="form-control" id="newPassword" name="newPassword" required style="flex: 1;">
<%--                                    <button type="button" class="btn btn-outline-secondary" onclick="checkPassword()">확인</button>--%>
                                </div>
                            </td>
                        </tr>

                        </tbody>
                    </table>
                    <div class="text-end">
                        <button type="button" id="passwordChangeBtn" class="btn btn-primary" onclick="changePassword()" disabled>완료</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    </div>
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
                console.log('getuserinfo',response);
                const responseData = response.data.data;
                const createdAt = dayjs(responseData.createdAt).format('YYYY-MM-DD');

                $('#nickname').text("유저명 : " + responseData?.nickname);
                $('#userId').text(responseData?.userId);
                $('#createdAt').text(createdAt);
                $('#role').text(responseData?.role);
                $('#currentNickname').text(responseData?.nickname);
            });
    }

    // 유저명 변경 모달 열릴때
    $('#editUserNmModal').on('shown.bs.modal', function () {
        $('#newUserNm').val('');
        $('#nickNameChangeConfirmBtn').prop('disabled', true);
    });

    // 비밀번호 변경 모달 열릴때
    $('#editPasswordChangeModal').on('shown.bs.modal', function () {
        $('#currentPassword').val('');
        $('#newPassword').val('');
        $('#passwordChangeBtn').prop('disabled', true);
    });



    // 닉네임 중복검사
    let isNicknameChecked = false;
    function checkNicknameDuplication() {
        const nickname = $('#newUserNm').val();
        if (!nickname) return;

        axios.get(`/api/settings/checkNickname`, { params: { nickname } })
            .then(res => {
                console.log('checkNickname',res);
                if (res.data.data.available) {
                    Swal.fire('사용 가능', '해당 닉네임은 사용 가능합니다!', 'success');
                    $('#userNmValidError').text('');
                    isNicknameChecked = true;
                    $('#nickNameChangeConfirmBtn').prop('disabled', false);
                } else {
                    $('#userNmValidError').text('이미 사용 중인 닉네임입니다.');
                    isNicknameChecked = false;
                    $('#nickNameChangeConfirmBtn').prop('disabled', true);
                }
            })
            .catch(() => {
                $('#userNmValidError').text('중복 확인 중 오류 발생');
                isNicknameChecked = false;
                $('#nickNameChangeConfirmBtn').prop('disabled', true);
            });
    }

    // 닉네임 입력 내용이 바뀌면 다시 중복확인 초기화
    $('#newUserNm').on('input', () => {
        isNicknameChecked = false;
        $('#nickNameChangeConfirmBtn').prop('disabled', true);
    });

    // 닉네임 변경
    function changeNickName() {
        let newUserNm = $('#newUserNm').val();
        $('#userNmValidError').text('');

        axios.patch(`/api/settings/changeNickName`, {
            newUsername: newUserNm
        })
            .then(response => {
                console.log('~~',response);
                const data = response.data;
                if (data.success) {
                    Swal.fire({
                        icon: 'success',
                        title: '완료!',
                        text: '유저명이 변경되었습니다.'
                    });

                    localStorage.setItem('nickname', data.data.nickname);
                    const currentUser = localStorage.getItem("nickname");

                    if (currentUser) {
                        $("#currentUser").html(`<strong>\${currentUser}님</strong>`);
                    }

                    const modal = bootstrap.Modal.getInstance(document.getElementById('editUserNmModal'));
                    modal.hide();
                    getUserInfo();
                } else {
                    $('#userNmValidError').text(data.message);
                }
            })
            .catch(error => {
                if (error.response?.data?.data?.message) {
                    $('#userNmValidError').text(error.response.data.data?.message);
                } else {
                    $('#userNmValidError').text("알 수 없는 오류가 발생했습니다.");
                }
            });
    }

    // 현재 비밀번호 검사
    let isPasswordChecked = false;
    function checkPassword() {
        const password = $('#currentPassword').val();
        if (!password) return;

        axios.post('/api/settings/checkPassword', { password })
            .then(res => {
                console.log('checkPassword', res);
                if (res.data.data.valid) {
                    Swal.fire('확인 완료', '비밀번호가 일치합니다.', 'success');
                    $('#passwordValidError').text('');
                    isPasswordChecked = true;
                    $('#passwordChangeBtn').prop('disabled', false);
                } else {
                    Swal.fire('확인 완료', '비밀번호가 일치하지 않습니다.', 'error');
                    isPasswordChecked = false;
                    $('#passwordChangeBtn').prop('disabled', true);
                }
            })
            .catch(() => {
                $('#passwordValidError').text('비밀번호 확인 중 오류 발생');
                isPasswordChecked = false;
                $('#passwordChangeBtn').prop('disabled', true);
            });
    }

    // 비밀번호 변경
    function changePassword() {
        let newPassword = $('#newPassword').val();
        let currentPassword = $('#currentPassword').val();

        axios.patch(`/api/settings/changePassword`, {
            currentPassword: currentPassword
            ,newPassword : newPassword
        })
            .then(response => {
                console.log('~~',response);
                const data = response.data;
                if (data.success) {
                    Swal.fire({
                        icon: 'success',
                        title: '완료!',
                        text: '비밀번호가 변경되었습니다.'
                    });

                    const modal = bootstrap.Modal.getInstance(document.getElementById('editPasswordChangeModal'));
                    modal.hide();
                    getUserInfo();
                } else {
                }
            })
            .catch(error => {
                if (error.response?.data?.data?.message) {
                } else {
                }
            });
    }

</script>

</body>
</html>