package edu.sm.app.service;

import edu.sm.app.dto.Orders;
import edu.sm.app.repository.OrdersRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OrdersService implements SmService<Orders, Integer> {

    final OrdersRepository ordersRepository;


    @Override
    public void register(Orders orders) throws Exception {
        ordersRepository.insert(orders);
    }

    @Override
    public void modify(Orders orders) throws Exception {
        ordersRepository.update(orders);
    }

    @Override
    public void remove(Integer id) throws Exception {
        ordersRepository.delete(id);
    }

    /**
     * SmService 인터페이스 구현 메서드.
     * 내부적으로 ordersRepository.selectAll()을 호출합니다. (JOIN 없음)
     */
    @Override
    public List<Orders> get() throws Exception {
        return ordersRepository.selectAll();
    }

    /**
     * SmService 인터페이스 구현 메서드.
     * 내부적으로 ordersRepository.select(id)를 호출합니다.
     * @param id 조회할 주문 ID
     */
    @Override
    public Orders get(Integer id) throws Exception {
        return ordersRepository.select(id);
    }

    // --- 사용자 정의 메서드 추가 ---

    /**
     * 카테고리 정보(cate)를 포함한 모든 주문 목록을 조회합니다.
     * 내부적으로 ordersRepository.selectAllWithCate()를 호출합니다.
     */
    public List<Orders> selectAllWithCate() throws Exception {
        return ordersRepository.selectAllWithCate();
    }
}