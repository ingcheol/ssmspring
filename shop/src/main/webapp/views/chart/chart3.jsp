<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Monthly Sales Chart</title>
  <!-- Highcharts 라이브러리 로드 -->
  <script src="https://code.highcharts.com/highcharts.js"></script>
  <script src="https://code.highcharts.com/modules/accessibility.js"></script>

  <style>
    .chart-container {
      width: 900px;
      height: 500px;
      border: 2px solid #3498db;
      margin: 20px auto;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }

    .loading {
      text-align: center;
      padding: 20px;
      color: #666;
      font-size: 16px;
    }

    .error {
      color: red;
      font-weight: bold;
      padding: 20px;
      text-align: center;
    }

    body {
      font-family: 'Arial', sans-serif;
      background-color: #f5f5f5;
    }

    .header {
      text-align: center;
      margin: 30px 0;
    }

    .header h1 {
      color: #2c3e50;
      margin-bottom: 10px;
    }

    .header p {
      color: #7f8c8d;
      font-size: 14px;
    }

    .chart-options {
      text-align: center;
      margin: 20px 0;
    }

    .chart-options button {
      margin: 0 10px;
      padding: 10px 20px;
      background-color: #3498db;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      font-size: 14px;
    }

    .chart-options button:hover {
      background-color: #2980b9;
    }

    .chart-options button.active {
      background-color: #e74c3c;
    }
  </style>
</head>
<body>

<div class="header">
  <h1>월별 매출 합 평균</h1>
  <p>월별 매출 합 평균</p>
</div>

<div class="chart-options">
  <button id="monthlyBtn" class="active" onclick="showMonthlyChart()">월별 매출 합</button>
  <button id="individualBtn" onclick="showIndividualChart()">월별 매출 평균</button>
</div>

<!-- 로딩 메시지 -->
<div id="loading" class="loading">📈 데이터를 불러오는 중...</div>

<!-- Chart가 생성될 div 태그 -->
<div id="container" class="chart-container"></div>

<script>
  let ordersData = []; // 전역 변수로 데이터 저장

  // 페이지 로드 후 실행
  document.addEventListener('DOMContentLoaded', function() {
    console.log('페이지 로드 완료, 데이터 요청 시작');
    loadOrdersData();
  });

  // 주문 데이터 로드
  function loadOrdersData() {
    fetch('/getorders')
            .then(response => {
              console.log('서버 응답 상태:', response.status);

              if (!response.ok) {
                throw new Error(`HTTP ${response.status}: 데이터를 가져오는 데 실패했습니다.`);
              }
              return response.json();
            })
            .then(data => {
              console.log('받아온 데이터:', data);
              ordersData = data;

              // 로딩 메시지 숨기기
              document.getElementById('loading').style.display = 'none';

              if (!data || data.length === 0) {
                document.getElementById('container').innerHTML = '<div class="error">표시할 주문 데이터가 없습니다.</div>';
                return;
              }

              // 기본적으로 월별 차트 표시
              showMonthlyChart();
            })
            .catch(error => {
              console.error('데이터 로드 중 오류 발생:', error);

              // 로딩 메시지 숨기기
              document.getElementById('loading').style.display = 'none';

              document.getElementById('container').innerHTML =
                      '<div class="error">데이터 로드 실패: ' + error.message + '</div>';
            });
  }

  // 월별 매출 차트 표시
  function showMonthlyChart() {
    setActiveButton('monthlyBtn');

    // 월별 데이터 집계
    const monthlyData = {};
    const monthNames = ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'];

    // 월별 매출 초기화
    monthNames.forEach(month => {
      monthlyData[month] = 0;
    });

    // 데이터 집계
    ordersData.forEach(order => {
      if (order.orderRegdate && order.orderPrice) {
        const date = new Date(order.orderRegdate);
        const month = date.getMonth(); // 0부터 시작
        const monthName = monthNames[month];
        monthlyData[monthName] += order.orderPrice;
      }
    });

    const categories = Object.keys(monthlyData);
    const values = Object.values(monthlyData);

    console.log('월별 집계 데이터:', monthlyData);

    Highcharts.chart('container', {
      title: {
        text: '2025년 월별 매출 현황',
        style: {
          fontSize: '18px',
          fontWeight: 'bold'
        }
      },

      subtitle: {
        text: '단위: 원'
      },

      accessibility: {
        point: {
          valueDescriptionFormat: '{xDescription}: {value:,.0f}원'
        }
      },

      xAxis: {
        title: {
          text: '월'
        },
        categories: categories
      },

      yAxis: {
        title: {
          text: '매출 금액 (원)'
        },
        labels: {
          formatter: function() {
            return (this.value / 10000).toFixed(0) + '만원';
          }
        }
      },

      tooltip: {
        headerFormat: '<b>{point.x}</b><br/>',
        pointFormat: '매출: <b>{point.y:,.0f}원</b>',
        shared: false
      },

      plotOptions: {
        line: {
          dataLabels: {
            enabled: true,
            formatter: function() {
              return (this.y / 10000).toFixed(0) + '만';
            }
          },
          marker: {
            enabled: true,
            radius: 6
          }
        }
      },

      series: [{
        name: '월별 매출',
        type: 'line',
        data: values,
        color: '#e74c3c',
        lineWidth: 3,
        marker: {
          fillColor: '#e74c3c',
          lineWidth: 2,
          lineColor: '#c0392b'
        }
      }],

      credits: {
        enabled: false
      }
    });
  }

  // 개별 주문 차트 표시
  function showIndividualChart() {
    setActiveButton('individualBtn');

    // 개별 주문 데이터 준비
    const orderIds = ordersData.map(order => order.orderId);
    const orderPrices = ordersData.map(order => order.orderPrice || 0);

    console.log('개별 주문 데이터:', { orderIds, orderPrices });

    Highcharts.chart('container', {
      title: {
        text: '개별 주문 금액 분석',
        style: {
          fontSize: '18px',
          fontWeight: 'bold'
        }
      },

      subtitle: {
        text: '단위: 원'
      },

      accessibility: {
        point: {
          valueDescriptionFormat: '주문 {xDescription}: {value:,.0f}원'
        }
      },

      xAxis: {
        title: {
          text: '주문 ID'
        },
        categories: orderIds
      },

      yAxis: {
        title: {
          text: '주문 금액 (원)'
        },
        labels: {
          formatter: function() {
            return (this.value / 10000).toFixed(0) + '만원';
          }
        }
      },

      tooltip: {
        headerFormat: '<b>주문 ID: {point.x}</b><br/>',
        pointFormat: '금액: <b>{point.y:,.0f}원</b>',
        shared: false
      },

      plotOptions: {
        column: {
          dataLabels: {
            enabled: true,
            formatter: function() {
              return (this.y / 10000).toFixed(0) + '만';
            }
          },
          colorByPoint: true
        }
      },

      series: [{
        name: '주문 금액',
        type: 'column',
        data: orderPrices,
        showInLegend: false
      }],

      credits: {
        enabled: false
      }
    });
  }

  // 버튼 활성화 상태 변경
  function setActiveButton(activeId) {
    document.getElementById('monthlyBtn').classList.remove('active');
    document.getElementById('individualBtn').classList.remove('active');
    document.getElementById(activeId).classList.add('active');
  }
</script>

</body>
</html>