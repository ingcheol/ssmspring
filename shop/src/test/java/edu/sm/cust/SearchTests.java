//package edu.sm.cust;
//
//import edu.sm.app.dto.Cust;
//import edu.sm.app.service.CustService;
//import lombok.extern.slf4j.Slf4j;
//import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.context.SpringBootTest;
//import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
//
//import java.time.LocalDateTime;
//import java.time.format.DateTimeFormatter;
//import java.util.List;
//
//@SpringBootTest
//@Slf4j
//class SearchTests {
//    @Autowired
//    CustService custService;
//    @Autowired
//    BCryptPasswordEncoder encoder;
//    @Autowired
//    StandardPBEStringEncryptor txtEncoder;
//    @Test
//    void contextLoads() throws Exception{
//        // =================================================================
//        // 1. 'if' 태그 테스트
//        // =================================================================
//        // 가정: CustMapper.xml에 이름(custName)이나 주소(custAddr)가 파라미터로 넘어올 때만
//        //      WHERE 조건에 추가하는 'findByKeyword' 쿼리가 있다고 가정합니다.
//        log.info("--- 1. 'if' 태그 테스트 시작 ---");
//
//        // 시나리오 1: 이름으로만 검색
//        Cust search1 = new Cust();
//        search1.setCustName("이"); // DB에 있는 이름으로 변경하여 테스트하세요.
//        List<Cust> result1 = custService.findByKeyword(search1);
//        log.info("이름('이')으로 검색 결과: {}", result1);
//
//        // 시나리오 2: 주소로만 검색
//        Cust search2 = new Cust();
//        search2.setCustAddr("서울"); // DB에 있는 주소로 변경하여 테스트하세요.
//        List<Cust> result2 = custService.findByKeyword(search2);
//        log.info("주소('서울')로 검색 결과: {}", result2);
//
//        // 시나리오 3: 이름과 주소, 둘 다 사용해서 검색
//        Cust search3 = new Cust();
//        search3.setCustName("김");
//        search3.setCustAddr("부산");
//        List<Cust> result3 = custService.findByKeyword(search3);
//        log.info("이름('김')과 주소('부산')로 검색 결과: {}", result3);
//
//        log.info("--- 'if' 태그 테스트 종료 ---\n");
//
//
//        // =================================================================
//        // 2. 'choose', 'when', 'otherwise' 태그 테스트
//        // =================================================================
//        // 가정: 검색 타입(type)에 따라 다른 컬럼을 검색하는 'findBySearchType' 쿼리가 있다고 가정합니다.
//        //       (type='n' -> cust_name, type='i' -> cust_id, 그 외(otherwise) -> cust_addr)
//        log.info("--- 2. 'choose' 태그 테스트 시작 ---");
//
//        // 시나리오 1: type='n', 이름으로 검색
//        List<Cust> resultChoose1 = custService.findBySearchType("n", "이현준");
//        log.info("타입(n), 이름('이현준')으로 검색 결과: {}", resultChoose1);
//
//        // 시나리오 2: type='i', 아이디로 검색
//        List<Cust> resultChoose2 = custService.findBySearchType("i", "id01");
//        log.info("타입(i), 아이디('id01')로 검색 결과: {}", resultChoose2);
//
//        // 시나리오 3: otherwise, 주소로 검색
//        List<Cust> resultChoose3 = custService.findBySearchType("a", "서울"); // type이 'n' 또는 'i'가 아님
//        log.info("타입(a), 주소('서울')로 검색 결과(otherwise): {}", resultChoose3);
//
//        log.info("--- 'choose' 태그 테스트 종료 ---\n");
//
//
//        // =================================================================
//        // 3. 'trim' 태그 테스트
//        // =================================================================
//        // 가정 1 (WHERE): 'if'문들을 <trim>으로 감싸 불필요한 'AND'를 제거하는
//        //               'findByKeywordWithTrim' 쿼리가 있다고 가정합니다.
//        log.info("--- 3. 'trim(where)' 태그 테스트 시작 ---");
//        Cust searchTrim = new Cust();
//        searchTrim.setCustAddr("부산");
//        List<Cust> resultTrim = custService.findByKeywordWithTrim(searchTrim);
//        log.info("'trim(where)' 주소('부산') 검색 결과: {}", resultTrim);
//
//        // 가정 2 (SET): 전달된 값이 null이 아닌 필드만 업데이트하고 마지막 쉼표(,)를 제거하는
//        //              'updateSelective' 쿼리가 있다고 가정합니다.
//        log.info("--- 3. 'trim(set)' 태그 테스트 시작 ---");
//        Cust custToUpdate = new Cust();
//        custToUpdate.setCustId("id09"); // 업데이트할 사용자의 ID
//        custToUpdate.setCustName("김민재"); // 이름만 변경
//        custService.updateSelective(custToUpdate);
//        log.info("id09 사용자의 이름을 '김민재'로 업데이트 완료 (DB 확인 필요)");
//
//        custToUpdate.setCustName(null); // 이름은 변경하지 않고
//        custToUpdate.setCustAddr("제주"); // 주소만 변경
//        custService.updateSelective(custToUpdate);
//        log.info("id09 사용자의 주소를 '제주'로 업데이트 완료 (DB 확인 필요)");
//        log.info("--- 'trim' 태그 테스트 종료 ---\n");
//
//
//        // =================================================================
//        // 4. 'foreach' 태그 테스트
//        // =================================================================
//        // 가정: List<String>을 받아 여러 사용자를 한번에 삭제하는 'deleteByIds' 쿼리가
//        //      있다고 가정합니다. (SQL의 IN절 생성)
//        log.info("--- 4. 'foreach' 태그 테스트 시작 ---");
//
//        // 주의: 실제로 데이터가 삭제되므로 테스트 시 주의가 필요합니다.
//        // 삭제하고 싶지 않은 ID는 목록에서 제외하세요.
//        List<String> idsToDelete = List.of("id05", "id06");
//        int deletedRows = custService.deleteByIds(idsToDelete);
//        log.info("{} 개의 행이 삭제되었습니다.", deletedRows);
//
//        log.info("--- 'foreach' 태그 테스트 종료 ---\n");
//
//
//
//    }
//
//}