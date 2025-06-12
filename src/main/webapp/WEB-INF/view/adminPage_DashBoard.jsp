<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <title>관리자 페이지</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script> <!--confirm 꾸며줌 -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/sidebar.css">

    <style>
        body {
            background: #f0f0f0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .avatar {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
        }
    </style>
</head>

<body class="bg-light">
<jsp:include page="sidebar.jsp" />

<div class="container-fluid p-4">
    <h2 class="mb-4">관리자 대시보드</h2>

    <!-- 구역1 -->
    <div class="row g-4">
        <div class="col-lg-6">
            <div class="card shadow-sm">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span>완료된 todo비율 && todo 우선순위 비율</span>
                    <div>
                        <span class="badge bg-danger">완료된 todo비율</span>
                        <span class="badge bg-secondary">todo 우선순위 비율</span>
                    </div>
                </div>
                <div class="card-body">
                    <canvas id="visitorChart" height="160"></canvas>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="card shadow-sm">
                <div class="card-header">일자별 요약을 넣을까</div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-sm align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th>일자</th>
                                <th>페이지뷰</th>
                                <th>방문자</th>
                                <th>가입</th>
                                <th>새 글</th>
                                <th>댓글</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr><td>2025-06-12</td><td>3</td><td>2</td><td>0</td><td>1</td><td>0</td></tr>
                            <tr><td>2025-06-11</td><td>10</td><td>8</td><td>1</td><td>3</td><td>2</td></tr>
                            <tr><td>2025-06-10</td><td>2</td><td>1</td><td>0</td><td>0</td><td>0</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 구역2 -->
    <div class="row g-4 mt-0">
        <div class="col-lg-6">
            <div class="card shadow-sm">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span>유저 정보(마지막 로그인시간, 신규 가입자 그런 통계?)</span>
                    <a href="#" class="small">더보기</a>
                </div>
                <ul class="list-group list-group-flush">
                    <!-- 샘플 -->
                    <li class="list-group-item d-flex align-items-center">
                        <div class="avatar bg-secondary text-white me-3">A</div>
                        <div>
                            <div class="fw-semibold">회원1</div>
                            <small class="text-muted">2025-06-11 10:12</small>
                        </div>
                    </li>
                    <li class="list-group-item d-flex align-items-center">
                        <div class="avatar bg-secondary text-white me-3">B</div>
                        <div>
                            <div class="fw-semibold">회원2</div>
                            <small class="text-muted">2025-06-10 15:42</small>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="card shadow-sm">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span>컨텐츠 알림</span>
                    <span class="badge bg-danger">1</span>
                </div>
                <ul class="list-group list-group-flush">

                    <li class="list-group-item">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <div class="fw-semibold">[게시판] 작성 위치별 기능 설명</div>
                                <small class="text-muted">관리자 2025-06-12 11:48</small>
                            </div>
                            <span class="badge bg-danger">N</span>
                        </div>
                    </li>
                    <li class="list-group-item">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <div class="fw-semibold">[게시판] 작성 가이드 업데이트</div>
                                <small class="text-muted">관리자 2025-06-11 14:22</small>
                            </div>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>


<script>
    const ctx = document.getElementById('visitorChart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['06-01', '06-05', '06-10', '06-15', '06-20', '06-25', '06-30'],
            datasets: [
                {
                    label: '페이지뷰',
                    data: [1, 4, 3, 10, 2, 3, 0],
                    fill: true,
                    tension: 0.3
                },
                {
                    label: '방문자',
                    data: [0, 4, 2, 8, 1, 2, 0],
                    fill: true,
                    tension: 0.3
                }
            ]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 2
                    }
                }
            }
        }
    });
</script>
</body>
</html>
