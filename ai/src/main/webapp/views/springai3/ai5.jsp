<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
    let ai5 = {
        generatedImageData: null, // 생성된 이미지 데이터 저장
        currentStep: 1, // 1: 이미지 생성 대기, 2: 이미지 분석 대기

        init: function() {
            // 마이크 초기화
            springai.voice.initMic(this);

            $('#spinner').css('visibility', 'hidden');
            this.startImageGeneration();
        },

        // 1단계: 음성으로 이미지 생성 설명 받기
        startImageGeneration: function() {
            this.currentStep = 1;
            let qForm = `
                <div class="media border p-3">
                    <div class="speakerPulse"
                         style="width: 30px; height: 30px;
                         background: url('/image/speaker-yellow.png') no-repeat center center / contain;">
                    </div>
                    만들고자 하는 이미지를 음성으로 설명하세요
                </div>
            `;
            $('#result').prepend(qForm);
        },

        // 2단계: 음성으로 이미지 분석 요청 받기
        startImageAnalysis: function() {
            this.currentStep = 2;
            let qForm = `
                <div class="media border p-3">
                    <div class="speakerPulse"
                         style="width: 30px; height: 30px;
                         background: url('/image/speaker-yellow.png') no-repeat center center / contain;">
                    </div>
                    생성된 이미지에 대해 질문하세요
                </div>
            `;
            $('#result').prepend(qForm);
        },

        // 음성 입력 처리
        handleVoice: async function(mp3Blob) {
            $('#spinner').css('visibility', 'visible');

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

            const questionText = await response.text();
            console.log('음성 인식 결과: ' + questionText);

            // 사용자 질문 UI 추가
            let qForm = `
                <div class="media border p-3">
                    <img src="/image/user.png" alt="User" class="mr-3 mt-3 rounded-circle" style="width:60px;">
                    <div class="media-body">
                        <h6>User</h6>
                        <p>${questionText}</p>
                    </div>
                </div>
            `;
            $('#result').prepend(qForm);

            // 현재 단계에 따라 처리
            if (this.currentStep === 1) {
                // 1단계: 이미지 생성
                await this.generateImage(questionText);
            } else if (this.currentStep === 2) {
                // 2단계: 이미지 분석
                await this.analyzeImage(questionText);
            }
        },

        // 이미지 생성
        generateImage: async function(description) {
            const response = await fetch('/ai3/image-generate', {
                method: "post",
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept': 'text/plain'
                },
                body: new URLSearchParams({ question: description })
            });

            const b64Json = await response.text();

            if (!b64Json.includes("Error")) {
                // 생성된 이미지 저장
                this.generatedImageData = b64Json;

                // 이미지 표시
                const base64Src = "data:image/png;base64," + b64Json;
                const generatedImage = document.getElementById("generatedImage");
                generatedImage.src = base64Src;
                generatedImage.style.display = "block";

                // AI 응답 UI 추가
                let aForm = `
                    <div class="media border p-3">
                        <div class="media-body">
                            <h6>GPT4</h6>
                            <p>이미지가 생성되었습니다.</p>
                        </div>
                        <img src="/image/assistant.png" alt="AI" class="ml-3 mt-3 rounded-circle" style="width:60px;">
                    </div>
                `;
                $('#result').prepend(aForm);

                $('#spinner').css('visibility', 'hidden');

                // 2단계로 전환
                this.startImageAnalysis();
            } else {
                alert(b64Json);
                $('#spinner').css('visibility', 'hidden');
                this.startImageGeneration();
            }
        },

        // 이미지 분석
        analyzeImage: async function(question) {
            // base64를 Blob으로 변환
            const byteCharacters = atob(this.generatedImageData);
            const byteNumbers = new Array(byteCharacters.length);
            for (let i = 0; i < byteCharacters.length; i++) {
                byteNumbers[i] = byteCharacters.charCodeAt(i);
            }
            const byteArray = new Uint8Array(byteNumbers);
            const imageBlob = new Blob([byteArray], { type: 'image/png' });

            // FormData 생성
            const formData = new FormData();
            formData.append("question", question);
            formData.append("attach", imageBlob, "generated.png");

            // 이미지 분석 요청 (스트리밍)
            const response = await fetch('/ai3/image-analysis', {
                method: "post",
                body: formData
            });

            // AI 답변 UI 생성
            let uuid = this.makeUi("result");

            // 스트리밍 응답 처리
            const reader = response.body.getReader();
            const decoder = new TextDecoder();
            let answerText = "";

            while (true) {
                const { value, done } = await reader.read();
                if (done) break;

                const chunk = decoder.decode(value);
                answerText += chunk;
                $('#' + uuid).html(answerText);
            }

            // 텍스트를 음성으로 변환
            await this.speakAnswer(answerText);

            $('#spinner').css('visibility', 'hidden');

            // 다시 1단계로 돌아가기
            this.startImageGeneration();
        },

        // 텍스트를 음성으로 출력
        speakAnswer: async function(text) {
            const response = await fetch('/ai3/tts', {
                method: "post",
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: new URLSearchParams({ text: text })
            });

            const audioBlob = await response.blob();
            const audioUrl = URL.createObjectURL(audioBlob);

            const audioPlayer = document.getElementById("audioPlayer");
            audioPlayer.src = audioUrl;

            // 음성 재생
            await audioPlayer.play();
        },

        // AI 응답 UI 생성
        makeUi: function(target) {
            let uuid = "id-" + crypto.randomUUID();

            let aForm = `
                <div class="media border p-3">
                    <div class="media-body">
                        <h6>GPT4</h6>
                        <p><pre id="${uuid}"></pre></p>
                    </div>
                    <img src="/image/assistant.png" alt="AI" class="ml-3 mt-3 rounded-circle" style="width:60px;">
                </div>
            `;
            $('#' + target).prepend(aForm);
            return uuid;
        }
    }

    $(() => {
        ai5.init();
    });
</script>

<div class="col-sm-10">
    <h2>Spring AI 5 - 음성 이미지 생성 및 분석</h2>
    <div class="row">
        <div class="col-sm-8">
            <h4>음성으로 이미지를 생성하고 분석하세요</h4>
            <audio id="audioPlayer" controls style="display:none;"></audio>
        </div>
        <div class="col-sm-2">
        </div>
        <div class="col-sm-2">
            <button class="btn btn-primary" disabled>
                <span class="spinner-border spinner-border-sm" id="spinner"></span>
                Loading..
            </button>
        </div>
    </div>

    <div class="row mt-3">
        <div class="col-sm-12">
            <img id="generatedImage" src="" class="img-fluid" alt="Generated Image" style="display:none; max-width: 100%; height: auto;" />
        </div>
    </div>

    <div id="result" class="container p-3 my-3 border" style="overflow: auto; width:auto; height: 600px;">
    </div>
</div>