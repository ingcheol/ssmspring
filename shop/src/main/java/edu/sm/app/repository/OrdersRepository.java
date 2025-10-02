package edu.sm.app.repository;

import edu.sm.app.dto.Orders;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface OrdersRepository extends SmRepository<Orders, Integer> {
    /**
     * XML ID: select
     * 특정 주문 1개를 조회합니다.
     * @param ordersId 조회할 주문 ID
     * @return Orders 객체
     */
    Orders select(Integer ordersId);

    /**
     * XML ID: selectAllWithCate
     * 카테고리 정보를 포함한 모든 주문 목록을 조회합니다.
     * @return Orders 객체 리스트
     */
    List<Orders> selectAllWithCate();

    /**
     * XML ID: selectAll
     * 주문 테이블의 모든 주문 목록을 조회합니다.
     * @return Orders 객체 리스트
     */
    List<Orders> selectAll();
}