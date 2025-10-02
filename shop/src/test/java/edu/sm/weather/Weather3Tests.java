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
class Weather3Tests {
    @Value("{app.key.owkey}")
    String key;

    @Test
    void contextLoads() throws IOException, ParseException {
        String loc = "1835848";
        Object object = WeatherUtil.getWeather2(loc,key);
        log.info("{}", object);
    }

}
