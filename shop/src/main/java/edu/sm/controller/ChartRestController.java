package edu.sm.controller;

import com.opencsv.CSVReader;
import edu.sm.app.dto.Content;
import edu.sm.app.dto.Marker;
import edu.sm.app.dto.Orders;
import edu.sm.app.dto.Search;
import edu.sm.app.service.MarkerService;
import edu.sm.app.service.OrdersService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import static java.awt.SystemColor.text;

@RestController
@RequiredArgsConstructor
@Slf4j
public class ChartRestController {

    @Value("${app.dir.logsdirRead}")
    String dir;
    final OrdersService ordersService;

    @RequestMapping("/getorders")
    public Object getorders() throws Exception {
        // 2. Service를 통해 DB에서 모든 주문 목록을 가져옵니다.
        List<Orders> list = ordersService.get(); // 또는 selectAllWithCate()
        // 3. @RestController 덕분에 Spring이 자동으로 List<Orders>를 JSON 배열로 변환해서 반환해줍니다.
        return list;
    }
    @RequestMapping("/chart2_1")
    public Object chart2_1() throws Exception {
        //[[],[]]
        JSONArray jsonArray = new JSONArray();
        String [] nation = {"Kor","Eng","Jap","Chn","Usa"};
        Random random = new Random();
        for(int i=0;i<nation.length;i++){
            JSONArray jsonArray1 = new JSONArray();
            jsonArray1.add(nation[i]);
            jsonArray1.add(random.nextInt(100)+1);
            jsonArray.add(jsonArray1);
        }
        return jsonArray;
    }
    @RequestMapping("/chart2_2")
    public Object chart2_2() throws Exception {
        //{cate:[],data:[]}
        JSONObject jsonObject = new JSONObject();
        String arr [] = {"0-9", "10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70-79", "80-89", "90+"};
        jsonObject.put("cate",arr);
        Random random = new Random();
        JSONArray jsonArray = new JSONArray();
        for(int i=0;i<arr.length;i++){
            jsonArray.add(random.nextInt(100)+1);
        }
        jsonObject.put("data",jsonArray);
        return jsonObject;
    }
    @RequestMapping("/chart2_3")
    public Object chart2_3() throws Exception {
        // text
        CSVReader reader = new CSVReader(new InputStreamReader(new FileInputStream(dir+"click.log"), "UTF-8"));
        String[] line;
        //reader.readNext();
        StringBuffer sb = new StringBuffer();
        while ((line = reader.readNext()) != null) {
            sb.append(line[2]+" ");
        }
        return sb.toString();
    }
    @RequestMapping("/chart2_4")
    public Object chart2_4() throws Exception {
        // 브라우저 시장 점유율 데이터를 JSON 형태로 구성
        JSONObject result = new JSONObject();

        // 메인 시리즈 데이터
        JSONArray mainSeries = new JSONArray();
        JSONObject seriesData = new JSONObject();
        seriesData.put("name", "Browsers");
        seriesData.put("colorByPoint", true);

        JSONArray data = new JSONArray();

        // 각 브라우저별 데이터
        JSONObject chrome = new JSONObject();
        chrome.put("name", "Chrome");
        chrome.put("y", 61.04);
        chrome.put("drilldown", "Chrome");
        data.add(chrome);

        JSONObject safari = new JSONObject();
        safari.put("name", "Safari");
        safari.put("y", 9.47);
        safari.put("drilldown", "Safari");
        data.add(safari);

        JSONObject edge = new JSONObject();
        edge.put("name", "Edge");
        edge.put("y", 9.32);
        edge.put("drilldown", "Edge");
        data.add(edge);

        JSONObject firefox = new JSONObject();
        firefox.put("name", "Firefox");
        firefox.put("y", 8.15);
        firefox.put("drilldown", "Firefox");
        data.add(firefox);

        JSONObject other = new JSONObject();
        other.put("name", "Other");
        other.put("y", 11.02);
        other.put("drilldown", null);
        data.add(other);

        seriesData.put("data", data);
        mainSeries.add(seriesData);

        // 드릴다운 시리즈 데이터
        JSONArray drilldownSeries = new JSONArray();

        // Chrome 드릴다운 데이터
        JSONObject chromeDetail = new JSONObject();
        chromeDetail.put("name", "Chrome");
        chromeDetail.put("id", "Chrome");
        JSONArray chromeData = new JSONArray();
        chromeData.add(createVersionData("v97.0", 36.89));
        chromeData.add(createVersionData("v96.0", 18.16));
        chromeData.add(createVersionData("v95.0", 0.54));
        chromeData.add(createVersionData("v94.0", 0.7));
        chromeData.add(createVersionData("v93.0", 0.8));
        chromeDetail.put("data", chromeData);
        drilldownSeries.add(chromeDetail);

        // Safari 드릴다운 데이터
        JSONObject safariDetail = new JSONObject();
        safariDetail.put("name", "Safari");
        safariDetail.put("id", "Safari");
        JSONArray safariData = new JSONArray();
        safariData.add(createVersionData("v15.3", 0.1));
        safariData.add(createVersionData("v15.2", 2.01));
        safariData.add(createVersionData("v15.1", 2.29));
        safariData.add(createVersionData("v15.0", 0.49));
        safariData.add(createVersionData("v14.1", 2.48));
        safariDetail.put("data", safariData);
        drilldownSeries.add(safariDetail);

        // Edge 드릴다운 데이터
        JSONObject edgeDetail = new JSONObject();
        edgeDetail.put("name", "Edge");
        edgeDetail.put("id", "Edge");
        JSONArray edgeData = new JSONArray();
        edgeData.add(createVersionData("v97", 6.62));
        edgeData.add(createVersionData("v96", 2.55));
        edgeData.add(createVersionData("v95", 0.15));
        edgeDetail.put("data", edgeData);
        drilldownSeries.add(edgeDetail);

        // Firefox 드릴다운 데이터
        JSONObject firefoxDetail = new JSONObject();
        firefoxDetail.put("name", "Firefox");
        firefoxDetail.put("id", "Firefox");
        JSONArray firefoxData = new JSONArray();
        firefoxData.add(createVersionData("v96.0", 4.17));
        firefoxData.add(createVersionData("v95.0", 3.33));
        firefoxData.add(createVersionData("v94.0", 0.11));
        firefoxData.add(createVersionData("v91.0", 0.23));
        firefoxDetail.put("data", firefoxData);
        drilldownSeries.add(firefoxDetail);

        result.put("series", mainSeries);
        result.put("drilldown", drilldownSeries);

        return result;
    }

    // 헬퍼 메서드: 버전 데이터 생성
    private JSONArray createVersionData(String version, double value) {
        JSONArray versionArray = new JSONArray();
        versionArray.add(version);
        versionArray.add(value);
        return versionArray;
    }
    @RequestMapping("/chart1")
    public Object chart1() throws Exception {
        // []
        JSONArray jsonArray = new JSONArray();

        // {}
        JSONObject jsonObject1 = new JSONObject();
        JSONObject jsonObject2 = new JSONObject();
        JSONObject jsonObject3 = new JSONObject();
        jsonObject1.put("name","Korea");
        jsonObject2.put("name","Japan");
        jsonObject3.put("name","China");
        // []
        JSONArray data1Array = new JSONArray();
        JSONArray data2Array = new JSONArray();
        JSONArray data3Array = new JSONArray();

        Random random = new Random();
        for(int i=0;i<12;i++){
            data1Array.add(random.nextInt(100)+1);
            data2Array.add(random.nextInt(100)+1);
            data3Array.add(random.nextInt(100)+1);
        }
        jsonObject1.put("data",data1Array);
        jsonObject2.put("data",data2Array);
        jsonObject3.put("data",data3Array);

        jsonArray.add(jsonObject1);
        jsonArray.add(jsonObject2);
        jsonArray.add(jsonObject3);
        return  jsonArray;
    }

}






