package edu.sm.controller;

import edu.sm.app.service.LoggerService1;
import edu.sm.app.service.LoggerService2;
import edu.sm.app.service.LoggerService3;
import edu.sm.app.service.LoggerService4;
import edu.sm.app.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.util.Random;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@RestController
@RequiredArgsConstructor
public class MainRestController {

    private final LoggerService1 loggerService1;
    private final LoggerService2 loggerService2;
    private final LoggerService3 loggerService3;
    private final LoggerService4 loggerService4;

    @Value("${app.key.wkey}")
    String wkey;

    private final RestTemplate restTemplate = new RestTemplate();
    private final Random random = new Random();

    @RequestMapping("/savedata")
    public Object savedata(@RequestParam("data") String data) throws IOException {

        loggerService1.save1(data);
        loggerService2.save2(data);
        loggerService3.save3(data);
        loggerService4.save4(data);

        // TODO: 이 부분을 실제 4개의 모니터링 값으로 교체해야 합니다.
        String cardData = IntStream.range(0, 4)
                                   .mapToObj(i -> String.valueOf(random.nextInt(101)))
                                   .collect(Collectors.joining(","));


        String mainsseUrl = "http://127.0.0.1:8088/internal/log";
        try {
            restTemplate.postForEntity(mainsseUrl, cardData, String.class);
        } catch (Exception e) {
            System.err.println("Error sending data to admin service: " + e.getMessage());
        }

        return "OK";
    }

}
