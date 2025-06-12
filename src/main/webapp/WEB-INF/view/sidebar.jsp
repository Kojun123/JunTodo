<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">


<div class="calendar-layout">
    <aside class="todo-sidebar" id="sidebar">
        <div class="dropdown profile-box">
            <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle"
               id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                <img src="https://i.pravatar.cc/32" alt="profile" class="rounded-circle me-2" width="32" height="32">
                <p id="currentUser"><strong>닉네임 님</strong></p>
            </a>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <li><a class="dropdown-item" href="/ui/settings">내 정보</a></li>
<%--                <li><a id="adminPage" class="dropdown-item" href="/ui/admin">관리자페이지</a></li>--%>
                <li><hr class="dropdown-divider"></li>
<%--                <sec:authorize access="isAuthenticated()">--%>
<%--                    현재 세션 권한 →--%>
<%--                    <sec:authentication property="authorities"/>--%>
<%--                </sec:authorize>--%>
                <li><a class="dropdown-item text-danger" href="#" onclick="fn_logout()">로그아웃</a></li>
                <sec:authorize access="hasAuthority('ADMIN')">
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="/ui/admin/DashBoard" onclick="">관리자 페이지</a></li>
                </sec:authorize>
            </ul>
        </div>

        <ul class="sidebar-menu mt-4">
            <li><a href="/"><i class="bi bi-calendar-day me-2 text-danger"></i><span>DashBoard</span></a></li>
            <li><a href="/ui/todoCalendar"><i class="bi bi-calendar2-week me-2"></i> <span>캘린더뷰</span></a></li>
<%--            <li><a href="#"><i class="bi bi-sliders2 me-2"></i> <span>필터 & 라벨</span></a></li>--%>
        </ul>

        <hr>

    </aside>

    <button id="sidebarToggle" class="btn btn-sm btn-light">
        <i class="bi bi-chevron-left"></i>
    </button>

    <!-- 나머지 페이지 내용이 들어가는 곳 -->
    <div class="calendar-content">
        <!-- 일정 등 콘텐츠 -->
    </div>
</div>

<script>
    const currentUser = localStorage.getItem("nickname");

    if (currentUser) {
        $("#currentUser").html(`<strong>\${currentUser}님</strong>`);
    }

    function fn_logout() {
        axios.post('/logout')
            .then(() => {
                window.location.href = '/ui/customLogin';
            })
            .catch(err => {console.error('Logout failed : ', err)});
    }

    //사이드바 토글
    document.getElementById("sidebarToggle").addEventListener("click", () => {
        const sidebar = document.getElementById("sidebar");
        sidebar.classList.toggle("collapsed");

        localStorage.setItem("sidebarCollapsed", sidebar.classList.contains("collapsed"));
    });

    $(document).ready(function () {
        $(function () {
            const sidebar = document.getElementById("sidebar");
            const collapsed = localStorage.getItem("sidebarCollapsed") === "true";
            if (collapsed) {
                sidebar.classList.add("collapsed");
            } else {
                sidebar.classList.remove("collapsed");
            }
        });

    });
</script>

