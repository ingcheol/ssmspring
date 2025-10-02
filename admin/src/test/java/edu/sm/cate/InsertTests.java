package edu.sm.cate;

import edu.sm.app.dto.Cate;
import edu.sm.app.service.CateService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@Slf4j
class InsertTests {
    @Autowired
    CateService cateService;
    @Test
    void contextLoads() {
        Cate cate = Cate.builder().cateId(50).cateName("가방").build();
        try {
            cateService.register(cate);
            log.info("Ok");
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
