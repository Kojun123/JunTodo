<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>할 일 목록</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <h2>할 일 목록</h2>

    <form id="todoForm">
        <input type="hidden" id="todoId">
        <label>제목: <input type="text" id="title"></label>
        <label>설명: <input type="text" id="description"></label>
        <button type="submit">추가/수정</button>
    </form>

    <table border="1">
        <thead>
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
</html>
    <script>
        $(document).ready(function() {
            loadTodos();  // 페이지 로드 시 할 일 목록 불러오기

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

function escapeHtml(text) {
    if (!text) return "내용 없음"; // null 또는 undefined 방지
    return text.replace(/&/g, "&amp;")
               .replace(/</g, "&lt;")
               .replace(/>/g, "&gt;")
               .replace(/"/g, "&quot;")
               .replace(/'/g, "&#039;");
}


     function loadTodos() {
         $.ajax({
             url: "/api/todos",
             type: "GET",
             dataType: "json",
             success: function(todos) {
                 $("#todoTableBody").empty(); // 기존 목록 초기화

                 todos.forEach(function(todo) {
                     var safeId = String(todo.id);
                     var safeTitle = escapeHtml(String(todo.title));
                     var safeDescription = escapeHtml(String(todo.description));
                     var safeCompleted = todo.completed ? '완료' : '미완료';

                     var row = "<tr>" +
                         "<td>" + safeId + "</td>" +
                         "<td>" + safeTitle + "</td>" +
                         "<td>" + safeDescription + "</td>" +
                         "<td>" + safeCompleted + "</td>" +
                         "<td>" +
                             "<button onclick=\"editTodo(" + safeId + ", '" + safeTitle + "', '" + safeDescription + "')\">수정</button> " +
                             "<button onclick=\"deleteTodo(" + safeId + ")\">삭제</button>" +
                         "</td>" +
                         "</tr>";

                     console.log("생성된 HTML:", row); // ✅ 최종 HTML 확인
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
                url: `/api/todos/${id}`,
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
                url: `/api/todos/${id}`,
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

        function resetForm() {
            $("#todoId").val("");
            $("#title").val("");
            $("#description").val("");
        }
    </script>
</body>
</html>
