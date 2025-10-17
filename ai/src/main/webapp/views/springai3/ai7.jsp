<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
    let ai7 = {
        init:function(){
            this.previewCamera('video');
            this.startQuestion();
            $('#spinner').css('visibility','hidden');
        },
        previewCamera:function(videoId){
            const video = document.getElementById(videoId);
            //카메라를 활성화하고 <video>에서 보여주기
            navigator.mediaDevices.getUserMedia({ video: true })
                .then((stream) => {
                    video.srcObject = stream;
                    video.play();
                })
                .catch((error) => {
                    console.error('카메라 접근 에러:', error);
                });
        },
        startQuestion:function(){
            // 마이크 초기화
            springai.voice.initMic(this);
            let qForm = `
            <div class="media border p-3">
               <div  class="speakerPulse"
              style="width: 30px; height: 30px;
              background: url('/image/speaker-yellow.png') no-repeat center center / contain;"></div>음성으로 질문하세요
            </div>
    `;
            // 사용자가 음성을 입력할 차례임을 알려주는 UI 추가
            $('#result').prepend(qForm);
        },
        handleVoice: async function(mp3Blob){
            //스피너 보여주기
            $('#spinner').css('visibility','visible');

            // 멀티파트 폼 구성
            const formData = new FormData();
            formData.append("speech", mp3Blob, 'speech.mp3');

            // 녹화된 음성을 텍스트로 변환 요청
            const response = await fetch("/ai3/stt", {
                method: "post",
                headers: {
                    'Accept': 'text/plain'
                },
                body: formData
            });

            // 텍스트 질문을 채팅 패널에 보여주기
            const questionText = await response.text();
            console.log('Handle:'+questionText);

            let qForm = `
              <div class="media border p-3">
                <img src="/image/user.png" alt="John Doe" class="mr-3 mt-3 rounded-circle" style="width:60px;">
                <div class="media-body">
                  <h6>John Doe</h6>
                  <p>`+questionText+`</p>
                </div>
              </div>
         `;
            $('#result').prepend(qForm);

            // 현재 화면 캡처해서 질문과 함께 전송
            this.captureFrame("video", (pngBlob) => {
                this.sendWithImage(questionText, pngBlob);
            });
        },
        captureFrame:function(videoId, handleFrame){
            const video = document.getElementById(videoId);

            //캔버스를 생성해서 비디오 크기와 동일하게 맞춤
            const canvas = document.createElement('canvas');
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;

            // 캔버스로부터  2D로 드로잉하는 Context를 얻어냄
            const context = canvas.getContext('2d');

            // 비디오 프레임을 캔버스에 드로잉
            context.drawImage(video, 0, 0, canvas.width, canvas.height);

            // 드로잉된 프레임을 PNG 포맷의 blob 데이터로 얻기
            canvas.toBlob((blob) => {
                handleFrame(blob);
            }, 'image/png');
        },
        sendWithImage: async function(questionText, pngBlob){
            $('#spinner').css('visibility','visible');

            // 멀티파트 폼 구성하기
            const formData = new FormData();
            formData.append("question", questionText);
            formData.append('attach', pngBlob, 'frame.png');

            // 이미지 분석 요청 (텍스트 답변)
            const response = await fetch('/ai3/image-analysis', {
                method: "post",
                headers: {
                    'Accept': 'application/x-ndjson'
                },
                body: formData
            });

            let uuid = this.makeUi("result");

            const reader = response.body.getReader();
            const decoder = new TextDecoder("utf-8");
            let content = "";
            while (true) {
                const {value, done} = await reader.read();
                if (done) break;
                let chunk = decoder.decode(value);
                content += chunk;
                console.log(content);
                $('#'+uuid).html(content)
            }

            // 텍스트 답변을 음성으로 변환
            await this.textToSpeech(content);
        },
        textToSpeech: async function(answerText){
            // 텍스트를 음성으로 변환 요청
            const response = await fetch("/ai3/chat-text", {
                method: "post",
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept': 'application/json'
                },
                body: new URLSearchParams({ question: answerText })
            });

            // 응답 JSON 받기
            const answerJson = await response.json();
            console.log(answerJson);

            //음성 답변을 재생하기 위한 소스 설정
            const audioPlayer = document.getElementById("audioPlayer");
            audioPlayer.src = "data:audio/mp3;base64," + answerJson.audio;

            //음성 답변이 재생 완료되었을 때 콜백되는 함수 등록
            audioPlayer.addEventListener("ended", () => {
                // 스피너 숨기기
                $('#spinner').css('visibility','hidden');
                console.log("대화 종료");
                // 음성 질문 다시 받기
                this.startQuestion();
            }, { once: true });

            audioPlayer.play();
        },
        makeUi:function(target){
            let uuid = "id-" + crypto.randomUUID();

            let aForm = `
          <div class="media border p-3">
            <div class="media-body">
              <h6>GPT4 </h6>
              <p><pre id="`+uuid+`"></pre></p>
            </div>
            <img src="/image/assistant.png" alt="John Doe" class="ml-3 mt-3 rounded-circle" style="width:60px;">
          </div>
    `;
            $('#'+target).prepend(aForm);
            return uuid;
        }
    }

    $(()=>{
        ai7.init();
    });

</script>

<div class="col-sm-10">
    <h2>Spring AI 7</h2>
    <div class="row">
        <div class="col-sm-9">
            <div id="result" class="container p-3 my-3 border" style="overflow: auto;width:auto;height: 300px;">
            </div>
        </div>
        <div class="col-sm-3">
            <video id="video" src="" alt="미리보기 이미지" height="200" autoplay />
        </div>
    </div>
</div>