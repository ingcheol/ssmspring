package edu.sm.controller;

import edu.sm.app.dto.Inquiry;
import edu.sm.app.service.InquiryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/inquiry")
public class InquiryController {

    @Autowired
    InquiryService inquiryService;

    @PostMapping("/register")
    @ResponseBody // 이 메소드는 이제 페이지를 반환하는 대신 데이터를 반환합니다.
    public ResponseEntity<?> register(@RequestBody Inquiry inquiry) { // @RequestBody: JSON 데이터를 받습니다.
        Map<String, String> response = new HashMap<>();
        try {
            System.out.println("전송된 문의 데이터 (JSON): " + inquiry.toString());
            inquiryService.register(inquiry); // MyBatis 충돌을 피하기 위해 register 메소드 호출
            response.put("status", "success");
            response.put("message", "문의가 성공적으로 등록되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "문의 등록 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }
}