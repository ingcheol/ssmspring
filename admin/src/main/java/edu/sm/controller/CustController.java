package edu.sm.controller;

import edu.sm.app.dto.Cust;
import edu.sm.app.dto.Inquiry;
import edu.sm.app.service.CustService;
import edu.sm.app.service.InquiryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@Slf4j
@RequestMapping("/cust")
@RequiredArgsConstructor
public class CustController {

    final CustService custService;
    final InquiryService inquiryService;

    // MainController와 동일하게 wsUrl 값을 주입받습니다.
    @Value("${app.url.websocketurl}")
    String websocketurl;

    String dir = "cust/";

    @RequestMapping("/chat")
    public String chat(Model model, @RequestParam("id") String id) {
        model.addAttribute("custId", id);
        model.addAttribute("center", dir + "chat");
        return "index";
    }

    @RequestMapping("/inquiry")
    public String inquiry(Model model) throws Exception {
        List<Inquiry> inquiryList = inquiryService.get();
        model.addAttribute("ilist", inquiryList);
        model.addAttribute("center", dir + "inquiry");
        return "index";
    }

    @RequestMapping("/add")
    public String add(Model model) {
        model.addAttribute("center", dir + "add");
        return "index";
    }

    @RequestMapping("/addimpl")
    public String addimpl(Model model, Cust cust) throws Exception {
        custService.register(cust);
        return "redirect:/cust/get";
    }

    @RequestMapping("/updateimpl")
    public String updateimpl(Model model, Cust cust) throws Exception {
        custService.modify(cust);
        return "redirect:/cust/detail?id=" + cust.getCustId();
    }

    @RequestMapping("/get")
    public String get(Model model) throws Exception {
        model.addAttribute("clist", custService.get());
        model.addAttribute("center", dir + "get");
        return "index";
    }

    @RequestMapping("/detail")
    public String detail(Model model, @RequestParam("id") String id) throws Exception {
        Cust cust = custService.get(id);
        model.addAttribute("cust", cust);
        model.addAttribute("center", dir + "detail");
        return "index";
    }

    @RequestMapping("/details")
    public String details(Model model, @RequestParam("id") String id) throws Exception {
        Cust cust = custService.get(id);
        model.addAttribute("cust", cust);
        model.addAttribute("center", dir + "details");
        // [수정] 주입받은 wsUrl 값을 websocketurl 변수로 모델에 추가합니다.
        model.addAttribute("websocketurl", websocketurl);
        return "index";
    }

    @RequestMapping("/delete")
    public String delete(Model model, @RequestParam("id") String id) throws Exception {
        custService.remove(id);
        return "redirect:/cust/get";
    }
}