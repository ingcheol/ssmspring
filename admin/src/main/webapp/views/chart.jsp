<style>
    .chart-container {
        width: auto;
        height: 320px;
        border: 2px solid red;
        margin-bottom: 1.5rem;
    }
</style>

<script>
    // 페이지가 완전히 로드된 후 모든 스크립트를 실행합니다.
    $(function() {
        // =================================================
        // 1. 기존 Highcharts 초기화 코드
        // =================================================
        const charts = {
            init: function() {
                this.createChart('container1', 'https://10.20.38.210:8444//logs/maininfo.log', 'Live Data 1');
                this.createChart('container2', 'https://10.20.38.210:8444//logs/maininfo2.log', 'Live Data 2');
                this.createChart('container3', 'https://10.20.38.210:8444//logs/maininfo3.log', 'Live Data 3');
                this.createChart('container4', 'https://10.20.38.210:8444//logs/maininfo4.log', 'Live Data 4');
            },
            createChart: function(containerId, url, title) {
                Highcharts.chart(containerId, {
                    chart: { type: 'areaspline' },
                    title: { text: title },
                    data: {
                        csvURL: url,
                        enablePolling: true,
                        dataRefreshRate: 2
                    }
                });
            }
        };
        charts.init();

        // =================================================
        // 2. 실시간 카드 업데이트를 위한 SSE 코드 (가장 단순한 방식으로 수정)
        // =================================================
        const clientId = 'admin-client-' + Math.random().toString(36).substr(2, 9);
        const sseUrl = 'https://10.20.38.210:8444/connect-logs/' + clientId;
        const eventSource = new EventSource(sseUrl);

        eventSource.onopen = function() {
            console.log('SSE connection established.');
        };
        eventSource.onerror = function(e) {
            console.error('SSE connection failed.', e);
            eventSource.close();
        };

        eventSource.addEventListener('log-data', function(event) {
            const data = event.data;
            const values = data.split(',');

            if (values.length === 4) {
                console.log("Received and processing values:", values);

                // --- 카드 1 직접 업데이트 ---
                let val1 = parseInt(values[0].trim(), 10);
                if (!isNaN(val1)) {
                    document.getElementById('msg1').textContent = val1 + '%';
                    document.getElementById('progress1').style.width = val1 + '%';
                    document.getElementById('progress1').setAttribute('aria-valuenow', val1);
                }

                // --- 카드 2 직접 업데이트 ---
                let val2 = parseInt(values[1].trim(), 10);
                if (!isNaN(val2)) {
                    document.getElementById('msg2').textContent = val2 + '%';
                    document.getElementById('progress2').style.width = val2 + '%';
                    document.getElementById('progress2').setAttribute('aria-valuenow', val2);
                }

                // --- 카드 3 직접 업데이트 ---
                let val3 = parseInt(values[2].trim(), 10);
                if (!isNaN(val3)) {
                    document.getElementById('msg3').textContent = val3 + '%';
                    document.getElementById('progress3').style.width = val3 + '%';
                    document.getElementById('progress3').setAttribute('aria-valuenow', val3);
                }

                // --- 카드 4 직접 업데이트 ---
                let val4 = parseInt(values[3].trim(), 10);
                if (!isNaN(val4)) {
                    document.getElementById('msg4').textContent = val4 + '%';
                    document.getElementById('progress4').style.width = val4 + '%';
                    document.getElementById('progress4').setAttribute('aria-valuenow', val4);
                }
            }
        });
    });
</script>

<!-- HTML 부분 (변경 없음) -->
<div class="row ">
    <!-- Card 1 -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-info shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Tasks 1</div>
                        <div class="row no-gutters align-items-center">
                            <div class="col-auto">
                                <div id="msg1" class="h5 mb-0 mr-3 font-weight-bold text-gray-800">--%</div>
                            </div>
                            <div class="col">
                                <div class="progress progress-sm mr-2">
                                    <div id="progress1" class="progress-bar bg-info" role="progressbar" style="width: 0%" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-auto"><i class="fas fa-clipboard-list fa-2x text-gray-300"></i></div>
                </div>
            </div>
        </div>
    </div>
    <!-- Card 2 -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-info shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Tasks 2</div>
                        <div class="row no-gutters align-items-center">
                            <div class="col-auto">
                                <div id="msg2" class="h5 mb-0 mr-3 font-weight-bold text-gray-800">--%</div>
                            </div>
                            <div class="col">
                                <div class="progress progress-sm mr-2">
                                    <div id="progress2" class="progress-bar bg-info" role="progressbar" style="width: 0%" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-auto"><i class="fas fa-clipboard-list fa-2x text-gray-300"></i></div>
                </div>
            </div>
        </div>
    </div>
    <!-- Card 3 -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-info shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Tasks 3</div>
                        <div class="row no-gutters align-items-center">
                            <div class="col-auto">
                                <div id="msg3" class="h5 mb-0 mr-3 font-weight-bold text-gray-800">--%</div>
                            </div>
                            <div class="col">
                                <div class="progress progress-sm mr-2">
                                    <div id="progress3" class="progress-bar bg-info" role="progressbar" style="width: 0%" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-auto"><i class="fas fa-clipboard-list fa-2x text-gray-300"></i></div>
                </div>
            </div>
        </div>
    </div>
    <!-- Card 4 -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-warning shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Tasks 4</div>
                        <div class="row no-gutters align-items-center">
                            <div class="col-auto">
                                <div id="msg4" class="h5 mb-0 mr-3 font-weight-bold text-gray-800">--%</div>
                            </div>
                            <div class="col">
                                <div class="progress progress-sm mr-2">
                                    <div id="progress4" class="progress-bar bg-warning" role="progressbar" style="width: 0%" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-auto"><i class="fas fa-clipboard-list fa-2x text-gray-300"></i></div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="container-fluid">
    <div class="row">
        <div class="col-xl-6 col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Car 1</h6>
                </div>
                <div class="card-body"><div id="container1" class="chart-container"></div></div>
            </div>
        </div>
        <div class="col-xl-6 col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Car 2</h6>
                </div>
                <div class="card-body"><div id="container2" class="chart-container"></div></div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-xl-6 col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Car 3</h6>
                </div>
                <div class="card-body"><div id="container3" class="chart-container"></div></div>
            </div>
        </div>
        <div class="col-xl-6 col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Car 4</h6>
                </div>
                <div class="card-body"><div id="container4" class="chart-container"></div></div>
            </div>
        </div>
    </div>
</div>