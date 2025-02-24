<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>할 일 목록</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="index.css">
</head>
<body>
<div class="container">
    <h2>📝 할 일 목록</h2>

    <form id="todoForm" class="mb-4">
        <input type="hidden" id="todoId">
        <div class="input-group">
            <input type="text" id="title" class="form-control" placeholder="할 일 제목" required>
            <input type="text" id="description" class="form-control" placeholder="설명">
            <button type="submit" class="btn btn-primary">추가 / 수정</button>
        </div>
    </form>

    <table class="table table-bordered">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>제목</th>
            <th>설명</th>
            <th>완료 여부</th>
            <th>관리</th>
        </tr>
        </thead>
        <tbody id="todoTableBody"></tbody>
    </table>
</div>

<script>
    $(document).ready(function() {
        loadTodos();

        $("#todoForm").submit(function(event) {
            event.preventDefault();
            const id = $("#todoId").val();
            const todo = {
                title: $("#title").val(),
                description: $("#description").val(),
                completed: false
            };

            if (id) {
                updateTodo(id, todo);
            } else {
                createTodo(todo);
            }
        });
    });

    function loadTodos() {
        $.ajax({
            url: "/api/todos",
            type: "GET",
            dataType: "json",
            success: function(todos) {
                $("#todoTableBody").empty();
                todos.forEach(todo => {
                    let row = `
                            <tr \${todo.completed ? 'class="completed"' : ''}>
                                <td>\${todo.id}</td>
                                <td>\${todo.title}</td>
                                <td>\${todo.description}</td>
                                <td>
                                    <input type="checkbox" onclick="toggleComplete(\${todo.id})" \${todo.completed ? 'checked' : ''}>
                                </td>
                                <td>
                                    <button class="btn btn-warning btn-sm" onclick="editTodo(\${todo.id}, '\${todo.title}', '\${todo.description}')">수정</button>
                                    <button class="btn btn-danger btn-sm" onclick="deleteTodo(\${todo.id})">삭제</button>
                                </td>
                            </tr>
                        `;
                    $("#todoTableBody").append(row);
                });
            },
            error: function(xhr) {
                alert("할 일 목록 불러오기 실패: " + xhr.statusText);
            }
        });
    }

    function createTodo(todo) {
        $.ajax({
            url: "/api/todos",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(todo),
            success: function() {
                loadTodos();
                resetForm();
            },
            error: function(xhr) {
                alert("할 일 추가 실패: " + xhr.statusText);
            }
        });
    }

    function updateTodo(id, todo) {
        $.ajax({
            url: `/api/todos/\${id}`,
            type: "PUT",
            contentType: "application/json",
            data: JSON.stringify(todo),
            success: function() {
                loadTodos();
                resetForm();
            },
            error: function(xhr) {
                alert("할 일 수정 실패: " + xhr.statusText);
            }
        });
    }

    function deleteTodo(id) {
        $.ajax({
            url: `/api/todos/\${id}`,
            type: "DELETE",
            success: function() {
                loadTodos();
            },
            error: function(xhr) {
                alert("할 일 삭제 실패: " + xhr.statusText);
            }
        });
    }

    function editTodo(id, title, description) {
        $("#todoId").val(id);
        $("#title").val(title);
        $("#description").val(description);
    }

    function toggleComplete(id) {
        $.ajax({
            url: `/api/todos/\${id}`,
            type: "PATCH",
            success: function() {
                loadTodos();
            },
            error: function(xhr) {
                alert("완료 상태 변경 실패: " + xhr.statusText);
            }
        });
    }

    function resetForm() {
        $("#todoId").val("");
        $("#title").val("");
        $("#description").val("");
    }
</script>
</body>
</html>
