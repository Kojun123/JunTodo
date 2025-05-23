<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>일정</title>

    <!-- Toast UI Calendar CSS -->
    <link rel="stylesheet" href="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.css" />

    <!-- Toast UI Calendar JS -->
    <script src="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.js"></script>

    <!-- jQuery & Axios -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

    <!-- boot strap -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <!--confirm 꾸며줌 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <link rel="stylesheet" href="/css/sidebar.css">
</head>

<style>
    .calendar-layout {
        display: flex;
        flex-direction: row;
        min-height: 100vh;
        background-color: #f8f9fa;
    }

    /* 기존 sidebar 디자인 유지하며 위치만 정리 */
    .calendar-layout .todo-sidebar {
        flex-shrink: 0;
        height: auto;
        min-height: 100vh;
        background-color: white;
        z-index: 10;
        box-shadow: 2px 0 4px rgba(0,0,0,0.05);
    }

    .calendar-content {
        flex-grow: 1;
        padding: 2rem;
    }

    #calendar {
        height: 800px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }

    a {
        text-decoration: none;
        color: #007bff;
        font-weight: 500;
    }

    a:hover {
        text-decoration: underline;
    }
</style>


<body>


<div class="calendar-layout">
    <jsp:include page="sidebar.jsp" />

    <div class="calendar-content">
        <h2>📅 일정 </h2>
        <div id="calendar"></div>
    </div>
</div>




</body>

<script>
    const Calendar = tui.Calendar;

    const calendar = new Calendar('#calendar', {
        defaultView: 'month',
        useDetailPopup: true,
        useCreationPopup: false
    });

    axios.get('/api/todos') // 실제 API 주소로 수정!
        .then(response => {
            const todos = response.data;

            const schedules = todos.map(todo => ({
                id: String(todo.id),
                calendarId: '1',
                title: todo.title,
                category: 'allday',
                start: todo.due_date,
                end: todo.due_date
            }));

            calendar.createSchedules(schedules);
        })
        .catch(error => {
            console.error('할 일 불러오기 실패:', error);
        });

    calendar.on('clickSchedule', function(event) {
        const todo = event.schedule;
        alert(`제목: ${todo.title}\n날짜: ${todo.start.toDate().toLocaleDateString()}`);
    });
</script>
</html>
