<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  #to{
    height:360px; overflow:auto;
    display:flex; flex-direction:column-reverse; gap:.5rem;
    padding:.75rem; background:#f8f9fa; border:1px solid #e9ecef; border-radius:.5rem;
  }
  .msg{display:flex;flex-direction:column;max-width:75%}
  .msg.me{align-self:flex-end;text-align:right}
  .msg.other{align-self:flex-start;text-align:left}
  .bubble{display:inline-block;padding:.5rem .75rem;border-radius:1rem;background:#e9ecef;color:#212529;word-break:break-word;white-space:pre-wrap}
  .msg.me .bubble{background:#007bff;color:#fff}
  .small-meta{font-size:.75rem;opacity:.7;margin-bottom:.25rem}
</style>

<script>
  let livechat = {
    id:'', stompClient:null,

    init:function(){
      this.id = $('#user_id').text();
      this.connect();

      $('#sendto').on('click', ()=> this.send());
      $('#totext').on('keydown', (e)=>{ if(e.key==='Enter'){ e.preventDefault(); this.send(); }});
    },

    send:function(){
      const text = $('#totext').val().trim();
      if(!text || !this.stompClient) return;

      // 내 메시지 즉시 표시
      $('#to').prepend(this.createMessageEl(text, true));
      this.keepBottom();

      // 서버 전송
      const msg = JSON.stringify({
        sendid: this.id,
        receiveid: $('#target').val(),
        content1: text
      });
      this.stompClient.send('/adminreceiveto', {}, msg);

      // 입력 초기화
      $('#totext').val('').focus();
    },

    connect:function(){
      const sid = this.id;
      const socket = new SockJS('${websocketurl}adminchat');
      this.stompClient = Stomp.over(socket);
      this.setConnected(true);

      this.stompClient.connect({}, () => {
        this.stompClient.subscribe('/adminsend/to/' + sid, (frame) => {
          const data = JSON.parse(frame.body || '{}');
          const isMe = (data.sendid === sid);
          $('#to').prepend(this.createMessageEl(data.content1 || '', isMe, data.sendid));
          this.keepBottom();
        });
      });
    },

    createMessageEl:function(text, isMe, senderOpt){
      const wrap = document.createElement('div');
      wrap.className = 'msg ' + (isMe ? 'me' : 'other');

      const meta = document.createElement('div');
      meta.className = 'small-meta';
      const sender = isMe ? this.id : (senderOpt || $('#target').val());
      meta.textContent = sender + ' · ' + new Date().toLocaleTimeString();

      const bubble = document.createElement('div');
      bubble.className = 'bubble';
      bubble.textContent = text;

      wrap.appendChild(meta);
      wrap.appendChild(풍선껌);
      return wrap;
    },

    keepBottom:function(){ document.getElementById('to').scrollTop = 0; },
    setConnected:function(connected){ $("#status").text(connected ? "Connected" : "Disconnected"); }
  };

  $(()=> {
    livechat.init()
  });
</script>

<div class="col-sm-10">
  <h2>Admin LiveChat</h2>
  <div class="card shadow-sm">
    <div class="card-header d-flex justify-content-between align-items-center">
      <div>
        <small class="text-muted">상태: <span id="status">Status</span>
        </small>
      </div>
      <div class="text-right">
        <span class="text-muted">Me: </span>
        <strong id="user_id">${sessionScope.admin.adminId}</strong>
      </div>
    </div>

    <div class="card-body">
      <div class="table-responsive">
        <div class="col-sm-12 col-md-10 col-lg-8 mx-auto">

          <div class="form-group">
            <label for="target" class="mb-1">대상 ID</label>
            <div class="input-group">
              <div class="input-group-prepend"><span class="input-group-text">To</span></div>
              <input disabled type="text" id="target" class="form-control" value="${cust.custId}">
            </div>
          </div>

          <div id="to" class="mb-3"></div>

          <div class="input-group">
            <input type="text" id="totext" class="form-control" placeholder="메시지를 입력하세요">
            <div class="input-group-append">
              <button id="sendto" class="btn btn-primary" type="button">Send</button>
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>
</div>