<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>일정</title>

    <!-- Toast UI Calendar -->
    <link rel="stylesheet" href="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.css" />
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

    .calendar-header {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        margin-bottom: 1.5rem;
    }

    .nav-btn {
        background: white;
        border: 1px solid #ddd;
        border-radius: 999px;
        padding: 6px 16px;
        font-weight: bold;
        color: #333;
        cursor: pointer;
    }

    .nav-btn:hover {
        background-color: #f1f1f1;
    }

    .calendar-title {
        font-size: 1.25rem;
        font-weight: 500;
        margin-left: 0.5rem;
    }

</style>


<body>


<div class="calendar-layout">
    <jsp:include page="sidebar.jsp" />

    <div class="calendar-content">
        <h2>📅 일정 </h2>
        <div class="calendar-header">
            <button id="todayBtn" class="nav-btn">Today</button>
            <button id="prevBtn" class="nav-btn">&lt;</button>
            <button id="nextBtn" class="nav-btn">&gt;</button>
            <span id="calendarTitle" class="calendar-title">..</span>
        </div>

        <div id="calendar"></div>
    </div>
</div>




</body>

<script>
    $(function () {

    })

    const calendar = new tui.Calendar('#calendar', {
        defaultView: 'month',
        calendars: [
            {
                id: 'HIGH',
                name: '중요',
                backgroundColor: '#ff6b6b',
                borderColor: '#ff6b6b'
            },
            {
                id: 'MEDIUM',
                name: '일상',
                backgroundColor: '#f9c74f',
                borderColor: '#f9c74f'
            },
            {
                id: 'LOW',
                name: '언젠가',
                backgroundColor: '#a3c9a8',
                borderColor: '#a3c9a8'
            }
        ],
        template: {
            popupDetailUser: (event) => {
                console.log('popupDetailUser called');
                return '';
            },
            popupDetailDate(event) {
                let data = event.raw;

                const start = new Date(data.createdAt);
                const start_parsing = start.toISOString().slice(0, 10);  // -> "2025-05-23"

                console.log('detaildate', data);

                return `\${start_parsing} - \${data.dueDate}`;
            },
            popupDetailState({ state }) {
                return '';
            },
            popupDetailTitle(event) {
                return `
                <div>
                    <strong>\${event.title}</strong>
                    <div style="font-size: 12px; color: gray;">작성자: \${event.raw.attendees}</div>
                </div>
            `;
            }
        },
        useDetailPopup: true,
        useCreationPopup: false
    });

    updateCalendarTitle();
    loadTodos();

    // 일정 로드 함수
    function loadTodos() {
        let date = $('#calendarTitle').text().split('.');
        axios.get(`/api/todos/by-date?year=\${date[0]}&month=\${date[1]}`)
            .then(res => {
                console.log('loadTodos', res);

                const priorityColorMap = {
                    HIGH: '#ff6b6b',
                    MEDIUM: '#f9c74f',
                    LOW: '#a3c9a8'
                }

                const priorityText = {
                    HIGH : '중요',
                    MEDIUM : '일상',
                    LOW : '언젠가'
                }

                const todos = res.data.data.map(todo => ({
                    id: String(todo.id),
                        calendarId: `\${todo.priority}`,
                        title: `[\${priorityText[todo.priority]}] \${todo.title}`,
                        category: 'allday',
                        start: todo.createdAt,
                        end: todo.dueDate,
                        raw: {
                        description: todo.description,
                            attendees: todo.username,
                            completed: todo.completed,
                            createdAt: todo.createdAt,
                            updatedAt: todo.updatedAt,
                            dueDate : todo.dueDate
                    }
                }));

                calendar.clear();
                calendar.createEvents(todos);
            })
            .catch(error => console.error("할 일 목록 불러오기 실패:", error));
    }

    // 월 이동할 때마다 일정 다시 로드
    calendar.on('viewDateRangeChange', function(e) {
        loadTodos();
    });

    calendar.on('clickSchedule', function(e) {
        const s = e.schedule;
        const raw = s.raw;

        alert(
            `제목: \${s.title}\n설명: \${raw.description}\n작성자: \${raw.username}\n우선순위: \${raw.priority}\n완료여부: \${raw.completed}\n작성일: \${raw.createdAt}`
        );
    });

    // 일정 아래 날짜 조정
    function updateCalendarTitle() {
        const date = calendar.getDate(); // 현재 기준일
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        $('#calendarTitle').text(year + '.' + month);
    }

    document.getElementById("todayBtn").addEventListener("click", () => {
        calendar.today();
        updateCalendarTitle();
        loadTodos();
    });
    document.getElementById("prevBtn").addEventListener("click", () => {
        calendar.prev();
        updateCalendarTitle();
        loadTodos();
    });
    document.getElementById("nextBtn").addEventListener("click", () => {
        calendar.next();
        updateCalendarTitle();
        loadTodos();
    });

    calendar.on("viewDateRangeChange", updateCalendarTitle);

</script>
</html>
