package edu.sm.controller;


import edu.sm.app.dto.Hotel;
import edu.sm.app.dto.ReviewClassification;
import edu.sm.app.springai.service2.*;
import edu.sm.app.springai.service3.AiImageService;
import edu.sm.app.springai.service3.AiSttService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import reactor.core.publisher.Flux;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@RestController
@RequestMapping("/ai3")
@Slf4j
@RequiredArgsConstructor
public class Ai3Controller {

    final private AiSttService aisttService;
    final private AiImageService aiImageService;

    @RequestMapping(value = "/stt")
    public String stt(@RequestParam("speech") MultipartFile speech) throws IOException {
        String text = aisttService.stt(speech);
        return text;
    }
    @RequestMapping(value = "/target")
    public String target(@RequestParam("questionText")  String questionText) throws IOException {
        Map<String, String> views = new ConcurrentHashMap<>();
        log.info("|"+questionText+"|");

        views.put("로그인", "/login");
        views.put("상품", "/items");

        String result = views.get(questionText.trim());
        log.info(result);

        return result;
    }

    @RequestMapping(value = "/tts")
    public byte[] tts(@RequestParam("text") String text) {
        byte[] bytes = aisttService.tts(text);
        return bytes;
    }

    @RequestMapping(value = "/chat-text")
    public Map<String, String> chatText(@RequestParam("question") String question) {
        Map<String, String> response = aisttService.chatText(question);
        return response;
    }


    @RequestMapping(value = "/image-analysis")
    public Flux<String> imageAnalysis(
            @RequestParam("question") String question,
            @RequestParam(value="attach", required = false) MultipartFile attach) throws IOException {
        // 이미지가 업로드 되지 않았을 경우
        if (attach == null || !attach.getContentType().contains("image/")) {
            Flux<String> response = Flux.just("이미지를 올려주세요.");
            return response;
        }

        Flux<String> flux = aiImageService.imageAnalysis(question, attach.getContentType(), attach.getBytes());
        return flux;
    }

    @RequestMapping( value = "/image-generate" )
    public String imageGenerate(@RequestParam("question") String question) {
        log.info("start imageGenerate-------------");
        try {
            String b64Json = aiImageService.generateImage(question);
            return b64Json;
        } catch(Exception e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        }
    }
}