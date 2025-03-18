<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>투두 리스트</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/index.css">

</head>
<body>
<div class="wrapper">
    <!-- 왼쪽 사이드바 -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <h2>📋 TODO</h2>
        </div>
        <ul class="sidebar-menu">
            <%-- today, completed, all --%>
            <li class="active"><a href="#" onclick="loadTodos('today')">📅 오늘</a></li>
<%--            <li><a href="#">다음</a></li>--%>
            <li><a href="#" onclick="loadTodos('completed')">✔️ 완료된 할 일</a></li>
            <li><a href="#" onclick="loadTodos('all')">🔄 전체 보기</a></li>
        </ul>
    </aside>

    <!-- 메인 컨텐츠 -->
    <main class="content">
<%--        <header class="content-header">--%>
<%--            <h2>오늘</h2>--%>
<%--            <button class="btn btn-primary" data-bs-toggle="modal" onclick="fn_modalOpen()" >+ 작업 추가</button>--%>
<%--        </header>--%>

        <div class="todo-list">
            <ul id="todoTableBody" class="row">
                <!--할 일 리스트-->
            </ul>
        </div>
    </main>
</div>

<button class="floating-add-btn" onclick="fn_modalOpen()">
    +
</button>


<!--  수정/추가 모달 -->
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content shadow-lg">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="editModalLabel">📌 할 일 추가/수정</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id = "editForm">
                <input type="hidden" id="id" name="id">

                <!--  제목 입력 -->
                <div class="mb-3">
                    <label class="form-label"><i class="bi bi-pencil-square"></i> 제목</label>
                    <input type="text" id="title" name="title" class="form-control" placeholder="할 일 제목 입력">
                </div>

                <!--  설명 입력 -->
                <div class="mb-3">
                    <label class="form-label"><i class="bi bi-chat-left-text"></i> 설명</label>
                    <input type="text" id="description" name="description" class="form-control" placeholder="할 일에 대한 설명">
                </div>

                <!--  우선순위 선택 -->
                <div class="mb-3">
                    <label class="form-label"><i class="bi bi-flag"></i> 우선순위</label>
                    <select id="priority" name="priority" class="form-select">
                        <option value="LOW">🟢 낮음</option>
                        <option value="MEDIUM">🟡 보통</option>
                        <option value="HIGH">🔴 높음</option>
                    </select>
                </div>

                <!--  완료 여부 (스위치 토글) -->
                <div class="form-check form-switch mb-3">
                    <input class="form-check-input" type="checkbox" id="completed" name="completed">
                    <label class="form-check-label" for="completed">✔️ 완료 여부</label>
                </div>
                </form>
            </div>
            <div class="modal-footer d-flex justify-content-between">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">❌ 닫기</button>
                <button type="button" class="btn btn-success" onclick="createTodo()"> 저장</button>
            </div>
        </div>
    </div>
</div>



<script>
    $(document).ready(function() {
        loadTodos();
    });

    function loadTodos(filterType="all") {
        axios.get(`/api/todos?filter=\${filterType}`)
            .then(response => {
                $("#todoTableBody").empty();
                response.data.forEach(todo => {
                    let priorityColor = todo.priority === "high" ? "danger" :
                        todo.priority === "medium" ? "warning" : "success";

                    let createdDate = new Date(todo.createdAt);
                    let formattedDate = `\${createdDate.getMonth() + 1}월 \${createdDate.getDate()}일`;

                    // 완료 여부 아이콘 변경
                    let completedIcon = todo.completed
                        ? `<span class="completed-icon">✔️</span>`
                        : `<span class="incomplete-icon">❌</span>`;

                    let completedClass = todo.completed ? "completed-card" : "";

                    let card = `
                    <div class="col-md-4">
                        <div class="card \${completedClass} mb-3">
                           <div class="card-body position-relative">
                                <small class="created-date position-absolute top-0 end-0 me-2 mt-2 text-muted">\${formattedDate}</small>
                                <h5 class="card-title text-\${priorityColor}" onclick="toggleComplete(\${todo.id}, \${todo.completed})">
                                    \${completedIcon} \${todo.title}
                                </h5>
                                <p class="card-text">\${todo.description}</p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="badge bg-\${priorityColor}">\${todo.priority}</span>
                                    <div>
                                        <button class="btn btn-sm btn-outline-secondary" onclick="openEditModal(\${todo.id}, '\${todo.title}', '\${todo.description}', '\${todo.priority}', \${todo.completed})">✏ 수정</button>
                                        <button class="btn btn-sm btn-outline-danger" onclick="deleteTodo(\${todo.id})">🗑 삭제</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                `;
                    $("#todoTableBody").append(card);
                });
            })
            .catch(error => console.error("할 일 목록 불러오기 실패:", error));
    }





    // 할 일 추가하기
    function createTodo() {
        event.preventDefault();

        const form = document.getElementById("editForm");  // 폼 요소 가져오기
        const formData = new FormData(form);  // FormData 객체 생성
        const todo = Object.fromEntries(formData);  // JSON 변환

        // todo.forEach(item => {
        //    if(item.completed) {
        //        $("#id").val(item.id);
        //
        //
        //    }
        // });

        console.log('save', todo);

        axios.post("/api/todos", todo)
            .then(response => {
                loadTodos();  // 목록 새로고침
                resetForm();  // 입력 폼 초기화
                $("#editModal").modal("hide");
            })
            .catch(error => console.error("할 일 추가 실패:", error));
    }

    //  할 일 수정하기
    function updateTodo(id, todo) {
        axios.put(`/api/todos/${id}`, todo)
            .then(response => {
                loadTodos();
                resetForm();
            })
            .catch(error => console.error("할 일 수정 실패:", error));
    }

    //  할 일 삭제하기
    function deleteTodo(id) {
        axios.delete(`/api/todos/\${id}`)
            .then(response => loadTodos())
            .catch(error => console.error("할 일 삭제 실패:", error));
    }

    //  완료 상태 변경 (체크박스 클릭 시)
    function toggleComplete(id, currentStatus) {
        axios.patch(`/api/todos/${id}`, { completed: !currentStatus })
            .then(response => loadTodos())  // 변경 후 목록 새로고침
            .catch(error => console.error("완료 상태 변경 실패:", error));
    }


    // 수정&추가 모달 폼초기화
    function resetForm() {
        $("#id").val("");          // 숨겨진 ID 필드 초기화
        $("#title").val("");           // 제목 입력 필드 초기화
        $("#description").val("");     // 설명 입력 필드 초기화
        $("#priority").val("LOW");     // 우선순위를 기본값("low")으로 설정
        $("#completed").prop("checked", false); // 완료 체크박스 초기화
    }

    // 수정모달오픈
    function openEditModal(id) {
        axios.get(`/api/todos/\${id}`)
            .then(response => {
                resetForm();
                console.log('open modal', response.data);
                const data = response.data;
                $("#id").val(data.id);
                $("#title").val(data.title);
                $("#description").val(data.description);
                $("#priority").val(data.priority);
                $("#completed").prop("checked", data.completed);

                $('#editModal').modal('show');
            }).catch(error => console.error("할 일 불러오기 실패 : ", error));
    }

    function fn_modalOpen() {
        resetForm();
        $('#editModal').modal('show');
    }

</script>
</body>
</html>
