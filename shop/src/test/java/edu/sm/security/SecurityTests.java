package edu.sm.security;

import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@SpringBootTest
@Slf4j
class SecurityTests {
    @Autowired
    BCryptPasswordEncoder encoder;
    @Test
    void contextLoads() {
        String pwd = "111111";
        String encpwd = encoder.encode(pwd);
        log.info("pwd:{}", pwd);
        log.info("encPwd:{}", encpwd);
        boolean matches = encoder.matches("111111", encpwd);
        log.info("matches:{}", matches);


    }

}
