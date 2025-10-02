package edu.sm.controller;

import edu.sm.sse.SseEmittersLogs;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;

@RestController
public class AdminSseController {

    private final SseEmittersLogs sseEmittersLogs;

    // @RequiredArgsConstructor 대신 생성자를 직접 작성하여 의존성을 주입합니다.
    @Autowired
    public AdminSseController(SseEmittersLogs sseEmittersLogs) {
        this.sseEmittersLogs = sseEmittersLogs;
    }

    @GetMapping(value = "/connect-logs/{id}", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public ResponseEntity<SseEmitter> connect(@PathVariable("id") String clientId) {
        SseEmitter emitter = new SseEmitter(60L * 1000 * 30); // 30분 타임아웃
        sseEmittersLogs.add(clientId, emitter);
        try {
            emitter.send(SseEmitter.event()
                    .name("connect")
                    .data("Connected with client ID: " + clientId));
        } catch (IOException e) {
            emitter.complete();
        }
        return ResponseEntity.ok(emitter);
    }

    @PostMapping("/internal/log")
    public ResponseEntity<Void> receiveLog(@RequestBody String data) {
        sseEmittersLogs.sendLogs(data);
        return ResponseEntity.ok().build();
    }
}
