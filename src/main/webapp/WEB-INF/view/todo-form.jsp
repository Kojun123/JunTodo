<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>할 일 관리</title>
</head>
<body>
    <h2>${todo.id == null ? '새 할 일 추가' : '할 일 수정'}</h2>
    <form action="${todo.id == null ? '/todos' : '/todos/' + todo.id + '/update'}" method="post">
        <input type="hidden" name="id" value="${todo.id}">
        <label>제목: <input type="text" name="title" value="${todo.title}"></label><br>
        <label>설명: <input type="text" name="description" value="${todo.description}"></label><br>
        <label>완료 여부: <input type="checkbox" name="completed" ${todo.completed ? 'checked' : ''}></label><br>
        <button type="submit">저장</button>
    </form>
    <a href="/todos">목록으로 돌아가기</a>
</body>
</html>
