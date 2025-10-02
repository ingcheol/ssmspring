package edu.sm.app.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class LoggerService2 {
    public void save2(String data) {
        String[] values = data.split(",");
        // 첫 번째 값만 로그로 남깁니다.
        if (values.length > 1) {
            log.info(values[1].trim());
        }
    }
}
