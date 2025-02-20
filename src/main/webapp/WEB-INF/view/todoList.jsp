<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>Todo List</title>
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <h2>할 일 목록</h2>
    <a href="/todos/new">새 할 일 추가</a>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>제목</th>
            <th>설명</th>
            <th>완료 여부</th>
            <th>관리</th>
        </tr>
        <c:forEach var="todo" items="${todos}">
            <tr>
                <td>${todo.id}</td>
                <td>${todo.title}</td>
                <td>${todo.description}</td>
                <td>${todo.completed ? '완료' : '미완료'}</td>
                <td>
                    <a href="/todos/${todo.id}/edit">수정</a>
                    <a href="/todos/${todo.id}/delete" onclick="return confirm('삭제하시겠습니까?')">삭제</a>
                </td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>
