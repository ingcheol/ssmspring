package edu.sm.weather;

import edu.sm.util.WeatherUtil;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.parser.ParseException;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.IOException;

@SpringBootTest
@Slf4j
class Weather1Tests {
    @Value("{app.key.wkey}")
    String key;

    @Test
    void contextLoads() throws IOException, ParseException {
        String key = "PPVzwqp%2FYiiOp0ShY6gY4Vkm0b%2FPaPg1bEJgcEVMBYbMYAQ2lVC%2FBRbGmi4%2FXTeID5pJBs9ShXOQ%2BP1Ve%2FFTbw%3D%3D";
        String loc = "108";
        Object object = WeatherUtil.getWeather(loc,key);
        log.info("{}", object);
    }

}
