<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <title>투두 리스트</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script> <!--confirm 꾸며줌 -->

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/index.css">
    <link rel="stylesheet" href="/css/sidebar.css">
    <!-- full calender부분 -->
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar/index.global.min.js'></script>
<jsp:include page="sidebar.jsp" />

</head>
<body>

<div class="wrapper">

    <!-- 검색 버튼 -->
    <div class="top-search-btn" onclick="openSearchModal()">
        <i class="bi bi-search"></i>
    </div>

    <!-- 검색 모달 오버레이 -->
    <div id="searchModal" class="search-modal d-none">
        <div class="search-modal-backdrop" onclick="closeSearchModal()"></div>
        <div class="search-modal-box">
            <select id="searchFilter" class="search-filter">
                <option value="title">제목</option>
                <option value="description">설명</option>
                <option value="username">작성자</option>
            </select>

            <input type="text" id="searchInput" class="search-input" placeholder="검색어를 입력하세요..." autofocus>

            <button id="searchBtn" class="search-btn">
                <i class="bi bi-search"></i>
            </button>
        </div>

    </div>

    <div id="cardView">
        <div class="d-flex justify-content-between align-items-center my-4">
            <h3 class="fw-bold mb-0" id="todoList" name="todoList">할 일 목록</h3>



            <div class="dropdown">
                <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                    보기
                </button>
                <ul class="dropdown-menu">
                    <%-- today, completed, all --%>
                    <li><a class="dropdown-item filter-option" onclick="loadTodos('today')" data-filter="today">📅 오늘 할 일</a></li>
                    <li><a class="dropdown-item filter-option" onclick="loadTodos('completed')" data-filter="completed">✔️ 완료한 할 일</a></li>
                    <li><a class="dropdown-item filter-option" onclick="loadTodos('all')" data-filter="all">🔄 전체 할 일</a></li>
                </ul>
            </div>
        </div>

        <div id="todoTableBody" class="row">
            <!--할 일 리스트-->
        </div>
    </div>

    <!-- 캘린더 뷰 -->
    <div id="calendarView" class="d-none">
        <div id="calendar"></div>
    </div>
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

                <!-- 마감일 선택 -->
                <div class="mb-3">
                    <label class="form-label"><i class="bi bi-calendar-event"></i> 마감일</label>
                    <input type="date" id="dueDate" name="dueDate" class="form-control">
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

    //card형 만드는 함수
    function createTodoCard(todo) {
        const priorityColor = todo.priority.toLowerCase() === "high" ? "danger" :
            todo.priority.toLowerCase() === "medium" ? "warning" : "success";

        const createdDate = new Date(todo.createdAt);
        const formattedDate = `등록일 : \${createdDate.getMonth() + 1}월 \${createdDate.getDate()}일`;

        const completedIcon = todo.completed
            ? `<span class="completed-icon">✔️</span>`
            : `<span class="incomplete-icon">❌</span>`;

        const completedClass = todo.completed ? "completed-card" : "";

        let dDayText = "";
        if (todo.dueDate) {
            const due = new Date(todo.dueDate);
            const today = new Date();
            const diff = Math.ceil((due - today) / (1000 * 60 * 60 * 24));

            if (diff === 0) dDayText = "🔥 오늘 마감";
            else if (diff < 0) dDayText = `❗ 마감 \${-diff}일 지남`;
            else dDayText = `마감일 : D-\${diff}`;
        }

        const editableButton = todo.editable ? `
        <button class="btn btn-sm btn-outline-secondary" onclick="openEditModal(\${todo.id}, '\${todo.title}', '\${todo.description}', '\${todo.priority}', \${todo.completed})">✏ 수정</button>
        <button class="btn btn-sm btn-outline-danger" onclick="deleteTodo(\${todo.id})">🗑 삭제</button>
    ` : "";

            return `
            <div class="col-12 col-sm-6 col-md-4 mb-3">
                <div class="card \${completedClass}">
                    <div class="card-body position-relative">
                        <small class="created-date position-absolute top-0 end-0 me-2 mt-2 text-muted">\${formattedDate}</small>
                        <h5 class="card-title text-\${priorityColor} mb-1" onclick="toggleComplete(\${todo.id}, \${todo.completed})">
                            \${completedIcon} \${todo.title}
                        </h5>
                        <small class="d-block text-end text-muted mb-2" style="font-size: 0.85rem;">\${dDayText}</small>
                        <small class="d-block text-end text-muted mb-2" style="font-size: 0.85rem;">작성자 : \${todo.username || '익명'}</small>
                        <p class="card-text">\${todo.description}</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="badge bg-\${priorityColor}">\${todo.priority}</span>
                            <div>
                                \${editableButton}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }

    //card형으로 만든 data받아서 렌더링
    function renderTodoList(data) {
        $("#todoTableBody").empty();

        data.forEach(todo => {
            const card = createTodoCard(todo);
            $("#todoTableBody").append(card);
        });
    }

    function loadTodos(filterType="all") {

        axios.get(`/api/todos?filter=\${filterType}`)
            .then(res => {
                console.log('loadTodos', res);

                $("#todoTableBody").empty();

                if (filterType.trim().toLowerCase() == 'all') {
                    console.log('!!')
                    $('#todoList').text('할일 목록 - 전체');
                } else if (filterType.trim().toLowerCase() == 'completed') {
                    $('#todoList').text('할일 목록 - 완료');
                } else if (filterType.trim().toLowerCase() == 'today') {
                    $('#todoList').text('할일 목록 - 오늘');
                }

                renderTodoList(res.data.data);
            })
            .catch(error => console.error("할 일 목록 불러오기 실패:", error));
    }





    // 할 일 추가하기
    function createTodo() {
        event.preventDefault();

        const form = document.getElementById("editForm");  // 폼 요소 가져오기
        const formData = new FormData(form);  // FormData 객체 생성
        const todo = Object.fromEntries(formData);  // JSON 변환
        const id = todo.id;

        console.log('save', todo);

        if (id && id.trim() !== "") {
            axios.patch(`/api/todos/\${id}`, todo)
                .then(response => {
                    loadTodos(); // 목록 새로고침
                    resetForm(); // 입력 폼 초기화
                    $("#editModal").modal("hide");
                })
                .catch(error => console.error("할 일 수정 실패:", error));
        } else {
            axios.post(`/api/todos`, todo)
                .then(response => {
                    loadTodos();  // 목록 새로고침
                    resetForm();  // 입력 폼 초기화
                    $("#editModal").modal("hide");
                })
                .catch(error => console.error("할 일 추가 실패:", error));
        }
    }

    //  할 일 삭제하기
    function deleteTodo(id) {
        Swal.fire({
            title: '정말 삭제하시겠습니까?',
            text: '되돌릴 수 없습니다!',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#aaa',
            confirmButtonText: '삭제',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                axios.delete(`/api/todos/\${id}`)
                    .then(response => loadTodos())
                    .catch(error => console.error("할 일 삭제 실패:", error));
            }
        });

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
                    console.log('open modal', response.data.data);
                    const data = response.data.data;
                    $("#id").val(data.id);
                    $("#title").val(data.title);
                    $("#description").val(data.description);
                    $("#priority").val(data.priority);
                    $("#completed").prop("checked", data.completed);
                    $("#dueDate").val(data.dueDate || "");
                    $('#editModal').modal('show');
                }).catch(error => console.error("할 일 불러오기 실패 : ", error));
        }

        function fn_modalOpen() {
            resetForm();
            $('#editModal').modal('show');
        }

        // full calender 초기화
        function renderCalendar() {
            const calendarEl = document.getElementById("calendar");
            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: "dayGridMonth",
                locale: "ko",
                events: function (fetchInfo, successCallback, failureCallback) {
                    axios.get("/api/todos")
                        .then(res => {
                            const events = res.data
                                .filter(todo => todo.dueDate)
                                .map(todo => ({
                                    id: todo.id,
                                    title: todo.title,
                                    start: todo.dueDate,
                                    allDay: true
                                }));
                            successCallback(events);
                        })
                        .catch(err => failureCallback(err));
                },
                eventClick: function (info) {
                    alert("할 일: " + info.event.title);
                }
            });

            calendar.render();
        }

        //탭전환
        function showCardView() {
            $("#cardView").removeClass("d-none");
            $("#calendarView").addClass("d-none");
        }

        function showCalendarView() {
            $("#cardView").addClass("d-none");
            $("#calendarView").removeClass("d-none");

            if (!window.calendarRendered) {
                renderCalendar();
                window.calendarRendered = true;
            }
        }

        //검색모달
        function openSearchModal() {
            document.getElementById("searchModal").classList.remove("d-none");
            document.getElementById("searchInput").focus();
        }

        function closeSearchModal() {
            document.getElementById("searchModal").classList.add("d-none");
            document.getElementById("searchInput").value = "";
        }

        function searchTodo() {
            const keyword = document.getElementById("searchInput").value.trim();
            const filter = document.getElementById("searchFilter").value;

            if (keyword === "") return;

            axios.get(`/api/todos/search`, {
                params: {
                    keyword: keyword,
                    filter: filter
                }
            })
                .then(res => {
                    closeSearchModal();
                    console.log("검색 결과:", res.data);
                    renderTodoList(res.data.data);
                })
                .catch(err => {
                    console.error("검색 실패:", err);
                });
        }

        // 검색 실행(돋보기 아이콘 눌렀을 경우 && 엔터 눌렀을 경우)
        document.getElementById("searchBtn").addEventListener("click", searchTodo);
        document.getElementById("searchInput").addEventListener("keydown", function (e) {
            if (e.key === "Enter") {
                searchTodo();
            }
        });








</script>
</body>
</html>
