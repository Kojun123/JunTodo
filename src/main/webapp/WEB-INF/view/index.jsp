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
            <li class="active"><a href="#">오늘</a></li>
            <li><a href="#">다음</a></li>
            <li><a href="#">완료된 작업</a></li>
            <li><a href="#">설정</a></li>
        </ul>
    </aside>

    <!-- 메인 컨텐츠 -->
    <main class="content">
        <header class="content-header">
            <h2>오늘</h2>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#editModal">+ 작업 추가</button>
        </header>

        <div class="todo-list">
            <ul id="todoTableBody" class="list-group">
                <!--할 일 리스트-->
            </ul>
        </div>
    </main>
</div>

<!-- 수정/추가 모달 -->
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editModalLabel">할 일 추가/수정</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id = "editForm">
                    <input type="hidden" id="id" name="id">
                    <label>제목:</label>
                    <input type="text" id="title" name="title" class="form-control">
                    <label>설명:</label>
                    <input type="text" id="description" name="description" class="form-control">
                    <label>우선순위:</label>
                    <select id="modalPriority" name="modalPriority" class="form-select">
                        <option value="low">낮음</option>
                        <option value="medium">보통</option>
                        <option value="high">높음</option>
                    </select>
                    <label>완료 여부:</label>
                    <input type="checkbox" name="completed" id="completed">
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" onclick="createTodo()">저장</button>
            </div>
        </div>
    </div>
</div>


<script>
    $(document).ready(function() {
        loadTodos();
    });

    function loadTodos() {
        $.ajax({
            url: "/api/todos",
            type: "GET",
            dataType: "json",
            success: function(todos) {
                console.log("loadTodos", todos);
                $("#todoTableBody").empty();
                todos.forEach(todo => {
                    let priorityClass = todo.priority === "high" ? "text-danger" :
                        todo.priority === "medium" ? "text-warning" : "text-success";

                    let listItem = `
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <input type="checkbox" class="form-check-input me-2" onchange="toggleComplete(\${todo.id}, this)" \${todo.completed ? 'checked' : ''}>
                                    <span class="\${priorityClass}">\${todo.title}</span> - \${todo.description}
                                </div>
                                <div>
                                    <button class="btn btn-sm btn-outline-secondary" onclick="openEditModal(\${todo.id}, '\${todo.title}', '\${todo.description}', '\${todo.priority}', \${todo.completed})">✏ 수정</button>
                                    <button class="btn btn-sm btn-outline-danger" onclick="deleteTodo(\${todo.id})">🗑 삭제</button>
                                </div>
                            </li>
                        `;
                    $("#todoTableBody").append(listItem);
                });
            }
        });
    }


    // 할 일 추가하기
    function createTodo() {
        event.preventDefault();

        const form = document.getElementById("editForm");  // 폼 요소 가져오기
        const formData = new FormData(form);  // FormData 객체 생성
        console.log('!!',formData)
        const todo = Object.fromEntries(formData);  // JSON 변환
        console.log('save', todo);

        axios.post("/api/todos", todo)
            .then(response => {
                loadTodos();  // 목록 새로고침
                resetForm();  // 입력 폼 초기화
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
        axios.delete(`/api/todos/${id}`)
            .then(response => loadTodos())
            .catch(error => console.error("할 일 삭제 실패:", error));
    }

    //  완료 상태 변경 (체크박스 클릭 시)
    function toggleComplete(id, checkbox) {
        axios.patch(`/api/todos/${id}`, { completed: checkbox.checked })
            .then(response => loadTodos())
            .catch(error => console.error("완료 상태 변경 실패:", error));
    }

    function resetForm() {
        $("#todoId").val("");          // 숨겨진 ID 필드 초기화
        $("#title").val("");           // 제목 입력 필드 초기화
        $("#description").val("");     // 설명 입력 필드 초기화
        $("#priority").val("low");     // 우선순위를 기본값("low")으로 설정
        $("#modalCompleted").prop("checked", false); // 완료 체크박스 초기화
    }
</script>
</body>
</html>
