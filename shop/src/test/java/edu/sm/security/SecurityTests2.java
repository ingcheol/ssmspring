package edu.sm.security;

import lombok.extern.slf4j.Slf4j;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@SpringBootTest
@Slf4j
class SecurityTests2 {
    @Autowired
    StandardPBEStringEncryptor encoder;
    @Test
    void contextLoads() {
     String txt = "서울시 강남구 역삼동 171번지";
     String enTxt = encoder.encrypt(txt);
     log.info("txt:{}", txt);
     log.info("enTxt:{}", enTxt);
     String decTxt = encoder.decrypt(enTxt);
     log.info("decTxt:{}", decTxt);


    }

}
