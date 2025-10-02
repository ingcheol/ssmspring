package edu.sm.controller;

import edu.sm.app.dto.Hotel;
import edu.sm.app.dto.Menu;
import edu.sm.app.dto.ReviewClassification;
import edu.sm.app.springai.service1.*;
import edu.sm.app.springai.service2.*;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.messages.Message;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/ai2")
@Slf4j
@RequiredArgsConstructor
public class Ai2Controller {

    final private AiServiceListOutputConverter aiServiceloc;
    final private AiServiceBeanOutputConverter aiServiceboc;
    final private AiServiceMapOutputConverter aiServicemoc;
    final private AiServiceParameterizedTypeReference aiServiceptr;
    final private AiServiceSystemMessage aiServicesm;
    final private AiServiceMenu aiServiceMenu;



    // ##### 요청 매핑 메소드 #####
    @RequestMapping(value = "/list-output-converter")
    public List<String> listOutputConverter(@RequestParam("city") String city) {
        List<String> hotelList = aiServiceloc.listOutputConverterHighLevel(city);
        // List<String> hotelList = aiServiceloc.listOutputConverterHighLevel(city);
        return hotelList;
    }
    @RequestMapping(value = "/bean-output-converter")
    public Hotel beanOutputConverter(@RequestParam("cities") String cities) {
        //Hotel hotel = aiService.beanOutputConverterLowLevel(city);
        Hotel hotel = aiServiceboc.beanOutputConverterHighLevel(cities);
        return hotel;
    }
    @RequestMapping(value = "/map-output-converter")
    public Map<String, Object> mapOutputConverter(@RequestParam("hotel") String hotel) {
//        Map<String, Object> hotelInfo = aiServicemoc.mapOutputConverterLowLevel(hotel);
         Map<String, Object> hotelInfo = aiServicemoc.mapOutputConverterHighLevel(hotel);
        return hotelInfo;
    }
    @RequestMapping(value = "/generic-bean-output-converter")
    public List<Hotel> genericBeanOutputConverter(@RequestParam("cities") String cities) {
        //List<Hotel> hotelList = aiService.genericBeanOutputConverterLowLevel(cities);
        List<Hotel> hotelList = aiServiceptr.genericBeanOutputConverterHighLevel(cities);
        return hotelList;
    }
    @RequestMapping(value = "/system-message")
    public ReviewClassification beanOutputConverter2(@RequestParam("review") String review) {
        ReviewClassification reviewClassification = aiServicesm.classifyReview(review);
        return reviewClassification;
    }
    @RequestMapping(value = "/menu-order-converter")
    public Map<String, Object> menuOrderConverter(@RequestParam("order") String order) {
        // AI로 주문 분석하여 Menu 객체 리스트 생성
        List<Menu> menuList = aiServiceMenu.analyzeOrder(order);

        // 총 금액 계산
        Integer totalPrice = aiServiceMenu.calculateTotal(menuList);

        // 응답 생성
        Map<String, Object> response = new HashMap<>();
        response.put("items", menuList);
        response.put("totalPrice", totalPrice);

        log.info("주문 분석 완료: {} 건, 총액: {}원", menuList.size(), totalPrice);

        return response;
    }
}
