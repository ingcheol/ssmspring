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
class Weather4Tests {
    @Value("{app.key.owkey}")
    String key;

    @Test
    void contextLoads() throws IOException, ParseException {
        String loc = "1839726";
        Object object = WeatherUtil.getWeather2Forecast(loc,key);
        log.info("{}", object);
    }

}
