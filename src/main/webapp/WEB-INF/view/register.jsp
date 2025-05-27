<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>회원가입</title>
    <link rel="stylesheet" href="/css/index.css">
</head>
<body>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script> <!--confirm 꾸며줌 -->

<div class="container d-flex justify-content-center align-items-center" style="height: 100vh;">
    <div class="card shadow-lg p-4" style="width: 400px;">
        <h3 class="text-center mb-4">📝 회원가입</h3>

        <form id="registerForm">
            <div class="mb-3">
                <label for="userId" class="form-label">아이디</label>
                <input type="text" name="userId" id="userId" class="form-control" required />
                <div id="userIdError" class="form-text text-danger d-none">아이디를 입력해주세요</div>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">비밀번호</label>
                <input type="password" name="password" id="password" class="form-control" required />
                <div id="passwordError" class="form-text text-danger d-none">비밀번호를 입력해주세요</div>
            </div>
        </form>

        <div class="d-grid mt-4">
            <button type="button" onclick="register()" class="btn btn-success">가입하기</button>
        </div>

        <div class="text-center mt-3">
            <a href="/ui/customLogin">이미 계정이 있으신가요? 로그인</a>
        </div>
    </div>
</div>


<script>
    function register() {
        const $userIdError = $("#userIdError");
        const $passwordError = $("#passwordError");

        // 초기화
        $userIdError.addClass("d-none");
        $passwordError.addClass("d-none");


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
                        $userIdError.removeClass("d-none").text(errorMsg);
                    }
                    else if(errorField == 'password') {
                        $passwordError.removeClass("d-none").text(errorMsg);
                    } else if(errorField == 'existsByUser') {
                        Swal.fire("에러", errorMsg || "알 수 없는 오류", "error");
                    }

                }

            });
    }
</script>

</body>
</html>
