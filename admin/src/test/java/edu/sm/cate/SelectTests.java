package edu.sm.cate;

import edu.sm.app.dto.Cate;
import edu.sm.app.service.CateService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@Slf4j
class SelectTests {
    @Autowired
    CateService cateService;
    @Test
    void contextLoads() {
        try {;
            cateService.get().forEach((c)->log.info(c.toString()));
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
