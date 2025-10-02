package edu.sm.app.repository;

import com.github.pagehelper.Page;
import edu.sm.app.dto.Inquiry;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface InquiryRepository extends SmRepository<Inquiry, Integer> {

    @Select("SELECT * FROM inquiry q inner join cate c on q.cate_id=c.cate_id")
    Page<Inquiry> getpage() throws Exception;

    @Override
    @Insert("INSERT INTO inquiry (cust_id, iq_ctt, iq_regdate, cate_id) VALUES (#{custId}, #{iqCtt}, now(), #{cateId})")
    void insert(Inquiry inquiry) throws Exception;

    @Override
    @Update("UPDATE inquiry SET cust_id=#{custId}, iq_ctt=#{iqCtt}, iq_regdate=now(), cate_id=#{cateId} WHERE iq_id=#{iqId}")
    void update(Inquiry inquiry) throws Exception;

    @Override
    @Delete("DELETE FROM inquiry WHERE iq_id=#{iqId}")
    void delete(Integer i) throws Exception;

    @Override
    @Select("SELECT * FROM inquiry q inner join cate c on q.cate_id=c.cate_id")
    List<Inquiry> selectAll() throws Exception;

    @Override
    @Select("SELECT * FROM inquiry q inner join cate c on q.cate_id=c.cate_id WHERE iq_id=#{iqId}")
    Inquiry select(Integer i) throws Exception;
}