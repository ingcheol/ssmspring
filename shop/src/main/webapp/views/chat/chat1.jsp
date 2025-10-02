<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <title>Chat Center</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
  <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.2/sockjs.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

  <style>
    .chat-box {
      height: 300px;
      overflow-y: auto;
      border: 1px solid #ddd;
      padding: 10px;
      background-color: #f9f9f9;
      margin-bottom: 15px;
    }

    .message {
      background-color: white;
      padding: 8px;
      margin-bottom: 8px;
      border-radius: 5px;
      border-left: 3px solid #007bff;
    }

    #all {
      width: 400px;
      height: 200px;
      overflow: auto;
      border: 2px solid red;
      padding: 10px;
    }

    #me {
      width: 400px;
      height: 200px;
      overflow: auto;
      border: 2px solid blue;
    }

    #to {
      width: 400px;
      height: 200px;
      overflow: auto;
      border: 2px solid green;
    }

    /* 채팅 메시지 스타일 */
    .chat-message {
      margin-bottom: 10px;
      clear: both;
    }

    .my-message {
      text-align: right;
      color: #007bff;
      font-weight: bold;
    }

    .other-message {
      text-align: left;
      color: #333;
    }
  </style>

  <script>
    let chat1 = {
      id:'',
      stompClient:null,
      init:function(){
        this.id = $('#user_id').text();
        $('#connect').click(()=>{
          this.connect();
        });
        $('#disconnect').click(()=>{
          this.disconnect();
        });
        $('#sendall').click(()=>{
          let msg = JSON.stringify({
            'sendid' : this.id,
            'content1' : $("#alltext").val()
          });
          this.stompClient.send("/receiveall", {}, msg);

          // 내 메시지를 오른쪽에 표시
          $("#all").append(
                  '<div class="chat-message my-message">' +
                  this.id + ': ' + $("#alltext").val() +
                  '</div>'
          );

          $("#alltext").val('');
          // 스크롤을 맨 아래로
          $("#all").scrollTop($("#all")[0].scrollHeight);
        });
        $('#sendme').click(()=>{
          let msg = JSON.stringify({
            'sendid' : this.id,
            'content1' : $("#metext").val()
          });
          this.stompClient.send("/receiveme", {}, msg);
          $("#metext").val('');
        });
        $('#sendto').click(()=>{
          var msg = JSON.stringify({
            'sendid' : this.id,
            'receiveid' : $('#target').val(),
            'content1' : $('#totext').val()
          });
          this.stompClient.send('/receiveto', {}, msg);
          $("#totext").val('');
        });

        // Enter key handlers
        $('#alltext').keypress((e) => {
          if (e.which === 13) $('#sendall').click();
        });
        $('#metext').keypress((e) => {
          if (e.which === 13) $('#sendme').click();
        });
        $('#totext').keypress((e) => {
          if (e.which === 13) $('#sendto').click();
        });
      },
      connect:function(){
        let sid = this.id;
        let socket = new SockJS('${websocketurl}chat');
        this.stompClient = Stomp.over(socket);
        let stompClient = this.stompClient;
        this.setConnected(true);
        stompClient.connect({}, function(frame) {
          console.log('Connected: ' + frame);
          stompClient.subscribe('/send', function(msg) {
            const message = JSON.parse(msg.body);
            // 다른 사람 메시지는 왼쪽에 표시 (내가 보낸 메시지가 아닐 때만)
            if (message.sendid !== sid) {
              $("#all").append(
                      '<div class="chat-message other-message">' +
                      message.sendid + ': ' + message.content1 +
                      '</div>'
              );
              // 스크롤을 맨 아래로
              $("#all").scrollTop($("#all")[0].scrollHeight);
            }
          });
          stompClient.subscribe('/send/'+sid, function(msg) {
            $("#me").prepend(
                    "<h4>" + JSON.parse(msg.body).sendid +":"+
                    JSON.parse(msg.body).content1+ "</h4>");
          });
          stompClient.subscribe('/send/to/'+sid, function(msg) {
            $("#to").prepend(
                    "<h4>" + JSON.parse(msg.body).sendid +":"+
                    JSON.parse(msg.body).content1
                    + "</h4>");
          });
        });
      },
      disconnect:function(){
        if (this.stompClient !== null) {
          this.stompClient.disconnect();
        }
        this.setConnected(false);
        console.log("Disconnected");
      },
      setConnected:function(connected){
        if (connected) {
          $("#status").text("Connected").removeClass("text-danger").addClass("text-success");
        } else {
          $("#status").text("Disconnected").removeClass("text-success").addClass("text-danger");
        }
      }
    }

    $(()=>{
      chat1.init();
    })
  </script>
</head>
<body>

<div class="container mt-4">
  <h2>Chat Center</h2>

  <!-- 사용자 정보 및 연결 상태 -->
  <div class="card mb-4">
    <div class="card-body">
      <h5>User: <span id="user_id" class="text-primary">${sessionScope.cust.custId}</span></h5>
      <h6>Status: <span id="status" class="text-danger">Disconnected</span></h6>
      <button id="connect" class="btn btn-success btn-sm">Connect</button>
      <button id="disconnect" class="btn btn-danger btn-sm">Disconnect</button>
    </div>
  </div>

  <!-- 탭 메뉴 -->
  <ul class="nav nav-tabs" id="chatTabs" role="tablist">
    <li class="nav-item">
      <a class="nav-link active" id="all-tab" data-toggle="tab" href="#all-chat" role="tab">전체 채팅</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" id="me-tab" data-toggle="tab" href="#me-chat" role="tab">개인 채팅</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" id="to-tab" data-toggle="tab" href="#to-chat" role="tab">직접 메시지</a>
    </li>
  </ul>

  <!-- 탭 내용 -->
  <div class="tab-content" id="chatTabContent">
    <!-- 전체 채팅 -->
    <div class="tab-pane fade show active" id="all-chat" role="tabpanel">
      <div class="card">
        <div class="card-header bg-primary text-white">
          <h5 class="mb-0">전체 채팅</h5>
        </div>
        <div class="card-body">
          <div id="all"></div>
          <div class="input-group">
            <input type="text" class="form-control" id="alltext" placeholder="메시지를 입력하세요...">
            <div class="input-group-append">
              <button class="btn btn-primary" id="sendall">전송</button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 개인 채팅 -->
    <div class="tab-pane fade" id="me-chat" role="tabpanel">
      <div class="card">
        <div class="card-header bg-info text-white">
          <h5 class="mb-0">개인 채팅</h5>
        </div>
        <div class="card-body">
          <div id="me"></div>
          <div class="input-group">
            <input type="text" class="form-control" id="metext" placeholder="개인 메시지를 입력하세요...">
            <div class="input-group-append">
              <button class="btn btn-info" id="sendme">전송</button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 직접 메시지 -->
    <div class="tab-pane fade" id="to-chat" role="tabpanel">
      <div class="card">
        <div class="card-header bg-success text-white">
          <h5 class="mb-0">직접 메시지</h5>
        </div>
        <div class="card-body">
          <div id="to"></div>
          <div class="form-row">
            <div class="col-3">
              <input type="text" class="form-control" id="target" placeholder="받는 사람">
            </div>
            <div class="col-7">
              <input type="text" class="form-control" id="totext" placeholder="직접 메시지를 입력하세요...">
            </div>
            <div class="col-2">
              <button class="btn btn-success btn-block" id="sendto">전송</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

</body>
</html>