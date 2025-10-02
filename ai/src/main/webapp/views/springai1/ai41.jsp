<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .menu-card {
        background: white;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        padding: 15px;
        margin-bottom: 15px;
        display: flex;
        align-items: center;
        transition: transform 0.2s;
    }
    .menu-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }
    .menu-image {
        width: 100px;
        height: 100px;
        object-fit: cover;
        border-radius: 8px;
        margin-right: 20px;
    }
    .menu-info {
        flex: 1;
    }
    .menu-name {
        font-size: 1.3em;
        font-weight: bold;
        color: #333;
        margin-bottom: 5px;
    }
    .menu-price {
        font-size: 1.2em;
        color: #e74c3c;
        font-weight: bold;
    }
    .menu-quantity {
        background: #3498db;
        color: white;
        padding: 5px 15px;
        border-radius: 20px;
        font-size: 0.9em;
        display: inline-block;
        margin-top: 5px;
    }
    .total-price {
        background: #2ecc71;
        color: white;
        padding: 15px;
        border-radius: 8px;
        text-align: center;
        font-size: 1.5em;
        font-weight: bold;
        margin-top: 20px;
    }
    .order-container {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 10px;
    }
</style>

<script>
    let ai41 = {
        init:function(){
            $('#send').click(()=>{
                this.send();
            });
            $('#spinner').css('visibility','hidden');
        },
        send: async function(){
            $('#spinner').css('visibility','visible');

            let question = $('#question').val();
            let qForm = '<div class="media border p-3 bg-light" style="border-radius: 10px; margin-bottom: 15px;">' +
                '<img src="/image/user.png" alt="고객" class="mr-3 mt-3 rounded-circle" style="width:60px;">' +
                '<div class="media-body">' +
                '<h6 style="color: #2c3e50;">고객 주문</h6>' +
                '<p style="font-size: 1.1em;">' + question + '</p>' +
                '</div>' +
                '</div>';

            $('#result').prepend(qForm);

            const response = await fetch('/ai1/few-shot-prompt', {
                method: "post",
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept': 'application/x-ndjson'
                },
                body: new URLSearchParams({ question })
            });

            const jsonString = await response.text();
            const jsonObject = JSON.parse(jsonString);

            this.displayMenuItems(jsonObject);

            $('#spinner').css('visibility','hidden');
        },
        displayMenuItems: function(orderData) {
            let menuHtml = '<div class="order-container">';
            menuHtml += '<h5 style="margin-bottom: 20px; color: #2c3e50;">📋 주문 내역</h5>';

            if (orderData.items && orderData.items.length > 0) {
                orderData.items.forEach(item => {
                    let formattedPrice = this.formatPrice(item.price);
                    let formattedTotal = this.formatPrice(item.price * item.quantity);

                    menuHtml += '<div class="menu-card">' +
                        '<img src="' + item.image + '" alt="' + item.name + '" class="menu-image" />' +
                        '<div class="menu-info">' +
                        '<div class="menu-name">' + item.name + '</div>' +
                        '<div class="menu-price">' + formattedPrice + '원</div>' +
                        '<span class="menu-quantity">수량: ' + item.quantity + '개</span>' +
                        '</div>' +
                        '<div style="text-align: right; font-size: 1.2em; color: #e74c3c; font-weight: bold;">' +
                        formattedTotal + '원' +
                        '</div>' +
                        '</div>';
                });

                if (orderData.totalPrice) {
                    let formattedTotalPrice = this.formatPrice(orderData.totalPrice);
                    menuHtml += '<div class="total-price">' +
                        '총 금액: ' + formattedTotalPrice + '원' +
                        '</div>';
                }
            } else {
                menuHtml += '<p>주문 내역이 없습니다.</p>';
            }

            menuHtml += '</div>';

            $('#result').prepend(menuHtml);
        },
        formatPrice: function(price) {
            return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        }
    }

    $(()=>{
        ai41.init();
    });
</script>

<div class="col-sm-10">
    <h2>🍱 김밥집 AI 주문 시스템</h2>

    <div class="row mt-4">
        <div class="col-sm-8">
            <label for="question" class="font-weight-bold">주문 내용 입력:</label>
            <textarea id="question" class="form-control" rows="3"
                      placeholder="예) 참치김밥 2줄이랑 치즈김밥 1줄, 돈까스 하나 주세요">참치김밥 2줄이랑 치즈김밥 1줄 주세요</textarea>
        </div>
        <div class="col-sm-2">
            <label class="font-weight-bold">&nbsp;</label>
            <button type="button" class="btn btn-primary btn-block" id="send">
                🍱 주문하기
            </button>
        </div>
        <div class="col-sm-2">
            <label class="font-weight-bold">&nbsp;</label>
            <button class="btn btn-secondary btn-block" disabled>
                <span class="spinner-border spinner-border-sm" id="spinner"></span>
                처리중..
            </button>
        </div>
    </div>

    <div id="result" class="container p-3 my-4" style="overflow: auto; width:auto; max-height: 600px;">
        <div class="text-center text-muted">
            <i class="fas fa-arrow-up" style="font-size: 2em;"></i>
            <p>위에서 주문을 입력해주세요</p>
        </div>
    </div>
</div>