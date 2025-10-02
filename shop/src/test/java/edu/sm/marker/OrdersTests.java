package edu.sm.marker;

import edu.sm.app.dto.Orders;
import edu.sm.app.service.OrdersService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Slf4j
class OrdersTests {

    @Autowired
    OrdersService ordersService;

    @Test
    @DisplayName("특정 주문 조회 테스트 (get by id)")
    void getByIdTest() {
        int testOrderId = 1; // 테스트할 주문 ID
        log.info("--- ID가 {}인 주문 조회 테스트 시작 ---", testOrderId);
        try {
            // [수정] ordersService.select(testOrderId) -> ordersService.get(testOrderId)
            Orders order = ordersService.get(testOrderId);
            log.info("조회 성공: {}", order);

        } catch (Exception e) {
            log.error("ID {}번 주문 조회 중 오류 발생", testOrderId, e);
            fail("테스트 실패: " + e.getMessage());
        }
        log.info("--- ID가 {}인 주문 조회 테스트 종료 ---", testOrderId);
    }

    @Test
    @DisplayName("모든 주문 조회 테스트 (get all - JOIN 없음)")
    void getAllTest() {
        log.info("--- 모든 주문 조회 테스트 시작 (orders 테이블만) ---");
        try {
            // [수정] ordersService.selectAll() -> ordersService.get()
            List<Orders> list = ordersService.get();

            assertNotNull(list);
            log.info("조회된 총 주문 수: {}", list.size());
            list.forEach(order -> log.info("주문 정보: {}", order.toString()));

        } catch (Exception e) {
            log.error("모든 주문 조회 중 오류 발생", e);
            fail("테스트 실패: " + e.getMessage());
        }
        log.info("--- 모든 주문 조회 테스트 종료 (orders 테이블만) ---");
    }

    @Test
    @DisplayName("모든 주문 조회 테스트 (selectAllWithCate - 카테고리 JOIN)")
    void selectAllWithCateTest() {
        log.info("--- 모든 주문 조회 테스트 시작 (cate 테이블 JOIN) ---");
        try {
            // 이 메서드는 OrdersService에 직접 추가했으므로 그대로 사용합니다.
            List<Orders> list = ordersService.selectAllWithCate();

            assertNotNull(list);
            log.info("조회된 총 주문 수: {}", list.size());
            list.forEach(order -> log.info("주문 정보: {}", order.toString()));

        } catch (Exception e) {
            log.error("모든 주문(JOIN) 조회 중 오류 발생", e);
            fail("테스트 실패: " + e.getMessage());
        }
        log.info("--- 모든 주문 조회 테스트 종료 (cate 테이블 JOIN) ---");
    }
}