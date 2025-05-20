<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

<aside class="todo-sidebar collapsed" id="sidebar">

    <button id="sidebarToggle" class="btn btn-sm btn-light ms-2 mt-2">
        <i class="bi bi-chevron-left"></i>
    </button>

    <div class="dropdown profile-box">
        <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle"
           id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
            <!-- https://i.pravatar.cc/32 -> 랜덤 유저 프로필 api 6주면 고정 -->
            <img src="https://i.pravatar.cc/32" alt="profile" class="rounded-circle me-2" width="32" height="32">
            <p id="currentUser"><strong>닉네임 님</strong></p>
        </a>
        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
            <li><a class="dropdown-item" href="/ui/settings">내 정보</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item text-danger" href="#" onclick="fn_logout()">로그아웃</a></li>
        </ul>
    </div>

    <ul class="sidebar-menu mt-4">
        <li><a href="/"><i class="bi bi-calendar-day me-2 text-danger"></i><span>DashBoard</span></a></li>
        <li><a href="#"><i class="bi bi-search me-2"></i> 검색</a></li>
        <li><a href="#"><i class="bi bi-inbox me-2"></i> 관리함</a></li>
        <li><a href="#"><i class="bi bi-calendar2-week me-2"></i> 다음</a></li>
        <li><a href="#"><i class="bi bi-sliders2 me-2"></i> 필터 & 라벨</a></li>
    </ul>

    <hr>

    <%--    <ul class="sidebar-projects">--%>
    <%--        <li><span class="text-muted small">프로젝트</span></li>--%>
    <%--        <li><a href="#"><span class="dot dot-red"></span> 피트니스</a></li>--%>
    <%--        <li><a href="#"><span class="dot dot-yellow"></span> 식품</a></li>--%>
    <%--        <li><a href="#"><span class="dot dot-blue"></span> 약속</a></li>--%>
    <%--        <li><a href="#"><span class="dot dot-green"></span> 새로 온 브랜드</a></li>--%>
    <%--    </ul>--%>
</aside>

<script>
    const currentUser = localStorage.getItem("nickname");

    if (currentUser) {
        $("#currentUser").html(`<strong>\${currentUser}님</strong>`);
    }

    function fn_logout() {
        axios.post('/logout')
            .then(() => {
                window.location.href = '/customLogin';
            })
            .catch(err => {console.error('Logout failed : ', err)});
    }


    //사이드바 토글
    document.getElementById("sidebarToggle").addEventListener("click", () => {
        const sidebar = document.getElementById("sidebar");
        sidebar.classList.toggle("collapsed");

        localStorage.setItem("sidebarCollapsed", sidebar.classList.contains("collapsed"));
    });


    window.addEventListener("DOMContentLoaded", () => {
        const sidebar = document.getElementById("sidebar");
        const collapsed = localStorage.getItem("sidebarCollapsed") === "true";
        if (collapsed) {
            sidebar.classList.add("collapsed");
        }
    });
</script>

