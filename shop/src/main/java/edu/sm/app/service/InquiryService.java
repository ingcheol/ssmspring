package edu.sm.app.service;

import edu.sm.app.dto.Inquiry;
import edu.sm.app.repository.InquiryRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class InquiryService implements SmService<Inquiry, Integer> {

    final InquiryRepository inquiryRepository;

//    public Page<Inquiry> getPage(int pageNo) throws Exception {
//        PageHelper.startPage(pageNo, 3); // 3: 한화면에 출력되는 개수
//        return inquiryRepository.getpage();
//    }

    @Override
    public void register(Inquiry inquiry) throws Exception {
        inquiryRepository.insert(inquiry);
    }

    @Override
    public void modify(Inquiry inquiry) throws Exception {
        inquiryRepository.update(inquiry);

    }

    @Override
    public void remove(Integer i) throws Exception {
        Inquiry inquiry = this.get(i);
        inquiryRepository.delete(i);
    }

    @Override
    public List<Inquiry> get() throws Exception {
        return inquiryRepository.selectAll();
    }

    @Override
    public Inquiry get(Integer i) throws Exception {
        return inquiryRepository.select(i);
    }

}
