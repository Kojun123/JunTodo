<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/dayjs@1/dayjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>


    <style>
        body {
            background: #f0f0f0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .register-box {
            background: #fff;
            padding: 40px 30px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            width: 480px;
        }
        .btn-pill {
            border-radius: 50px;
        }
    </style>
</head>

<body>
<div class="register-box">
    <h1 class="text-center" style="font-family: serif; font-size: 24px; font-weight: bold; margin-bottom:8px;">
        JunTodo
    </h1>
    <h2 class="text-center" style="font-size:16px; font-weight:500; margin-bottom:30px; color:#333;">
        회원가입
    </h2>
    <form id="registerForm">
        <div class="mb-3">
            <label for="userId" class="form-label">아이디<span class="text-danger">*</span></label>
            <div class="input-group">
                <input type="text"
                       id="userId"
                       name="userId"
                       class="form-control"
                       placeholder="아이디를 입력해주세요, 영문·숫자 조합"
                       required>
                <button type="button"
                        class="btn btn-outline-secondary btn-pill"
                        onclick="checkDup()">
                    중복확인
                </button>
            </div>
        </div>
    <div id="userIdError" class="form-text text-danger d-none">아이디를 입력해주세요</div>

        <div class="mb-3">
            <label for="password" class="form-label">비밀번호<span class="text-danger">*</span></label>
            <input type="password"
                   id="password"
                   name="password"
                   class="form-control"
                   placeholder="비밀번호를 입력해주세요, 영문·숫자 조합"
                   required>
        </div>
    <div id="passwordError" class="form-text text-danger d-none">비밀번호를 입력해주세요</div>

        <div class="mb-3">
            <label for="passwordConfirm" class="form-label">비밀번호 확인<span class="text-danger">*</span></label>
            <input type="password"
                   id="passwordConfirm"
                   name="passwordConfirm"
                   class="form-control"
                   placeholder="비밀번호를 한번 더 입력해주세요"
                   required>
        </div>
        <div id="pwConfirmError" class="form-text text-danger d-none">비밀번호를 확인해주세요</div>

<%--        <div class="mb-4">--%>
<%--            <label for="name" class="form-label">이름<span class="text-danger">*</span></label>--%>
<%--            <input type="text"--%>
<%--                   id="name"--%>
<%--                   name="name"--%>
<%--                   class="form-control"--%>
<%--                   placeholder="이름을 입력해주세요"--%>
<%--                   required>--%>
<%--        </div>--%>
    </form>
        <button id="registerBtn" type="button" class="btn btn-dark btn-pill w-100 mb-3" onclick="register()">
            회원가입
        </button>

        <button id="" type="button" class="btn btn-dark btn-pill w-100 mb-3" onclick="location.href='${pageContext.request.contextPath}/ui/customLogin'">
            로그인 페이지로 이동
        </button>


</div>


<script>
    function register() {
        const userId = $('#userId');
        const pw = $('#password');
        const pw2 = $('#passwordConfirm');
        const userIdError = $('#userIdError');
        const passwordError = $('#passwordError');
        const pwConfirmError = $('#pwConfirmError');

        // 초기화
        $('#userIdError, #passwordError, #pwConfirmError ').addClass('d-none').text('');



        if ( pw.val().trim() !== pw2.val().trim() ) {
            pwConfirmError.removeClass('d-none').text('비밀번호가 일치하지 않습니다.');
            return;
        }


        const form = document.getElementById("registerForm");  // 폼 요소 가져오기
        const formData = new FormData(form);  // FormData 객체 생성
        const jsonFormData = Object.fromEntries(formData);  // JSON 변환

        axios.post(`/api/settings/register`, jsonFormData)
            .then(response => {
                Swal.fire({
                    icon: "success",
                    title: "회원가입 성공!",
                    text: "회원가입 성공!",
                    confirmButtonText: "확인"
                }).then(() => {
                    window.location.href = "/ui/customLogin";
                });
            })
            .catch(error => {
                console.log('register error', error);
                let errorData = error.response.data;
                let errorField = errorData.data.errorField;
                let errorMsg = errorData.data.message;

                if (errorData.result != 0) {
                    if(errorField == 'userId') {
                        userIdError.removeClass("d-none").text(errorMsg);
                    }
                    else if(errorField == 'password') {
                        passwordError.removeClass("d-none").text(errorMsg);
                    } else if(errorField == 'existsByUser') {
                        Swal.fire("에러", errorMsg || "알 수 없는 오류", "error");
                    }

                }

            });
    }
</script>
</body>
</html>
