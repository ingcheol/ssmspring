package edu.sm.app.springai.service2;

import edu.sm.app.dto.Menu;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@Slf4j
public class AiServiceMenu {
    private ChatClient chatClient;

    public AiServiceMenu(ChatClient.Builder chatClientBuilder) {
        chatClient = chatClientBuilder.build();
    }

    /**
     * 고객 주문 분석
     */
    public List<Menu> analyzeOrder(String order) {
        // "메뉴판" 또는 "메뉴" 키워드 감지
        if (order.contains("메뉴판") || order.matches(".*메뉴\\s*(보여|알려|뭐|있).*")) {
            return getAllMenuList();
        }

        String prompt = """
                고객 주문을 분석하여 각 메뉴를 Menu 객체 리스트로 변환해주세요.
                
                Menu 객체 구조:
                - menuId: Long (순서대로 1, 2, 3...)
                - name: String (메뉴 이름)
                - price: Integer (가격, 원 단위)
                - imagePath: String (이미지 경로)
                
                판매 가능한 메뉴:
                - 김밥: 2500원, /image/kimbap.jpg
                - 참치김밥: 3500원, /image/tuna_kimbap.jpg
                - 치즈김밥: 3000원, /image/cheese_kimbap.jpg
                - 김치김밥: 3000원, /image/kimchi_kimbap.jpg
                - 라면: 4500원, /image/ramen.jpg
                - 돈까스: 7000원, /image/donkatsu.jpg
                
                주의사항:
                - 위 메뉴에 없는 항목이 있으면 "죄송합니다. [메뉴명]은(는) 판매하지 않습니다."라는 메시지를 name에 넣고, price는 0, imagePath는 /image/user.png로 설정하세요
                - 수량이 여러 개면 같은 메뉴를 반복해서 리스트에 추가하세요
                - 예: "참치김밥 2줄" → Menu 객체 2개 생성
                - JSON 배열 형태로만 응답하세요
                - 마크다운 형식(```json) 사용하지 마세요
                
                고객 주문: %s
                """.formatted(order);

        List<Menu> menuList = chatClient.prompt()
                .user(prompt)
                .call()
                .entity(new ParameterizedTypeReference<List<Menu>>() {});

        log.info("분석된 메뉴 개수: {}", menuList.size());
        return menuList;
    }

    /**
     * 전체 메뉴판 반환
     */
    private List<Menu> getAllMenuList() {
        List<Menu> menuList = new ArrayList<>();

        menuList.add(createMenu(1L, "김밥", 2500, "/image/kimbap.jpg"));
        menuList.add(createMenu(2L, "참치김밥", 3500, "/image/tuna_kimbap.jpg"));
        menuList.add(createMenu(3L, "치즈김밥", 3000, "/image/cheese_kimbap.jpg"));
        menuList.add(createMenu(4L, "김치김밥", 3000, "/image/kimchi_kimbap.jpg"));
        menuList.add(createMenu(5L, "라면", 4500, "/image/ramen.jpg"));
        menuList.add(createMenu(6L, "돈까스", 7000, "/image/donkatsu.jpg"));

        log.info("전체 메뉴판 조회: {} 개", menuList.size());
        return menuList;
    }

    /**
     * Menu 객체 생성 헬퍼
     */
    private Menu createMenu(Long id, String name, Integer price, String imagePath) {
        Menu menu = new Menu();
        menu.setMenuId(id);
        menu.setName(name);
        menu.setPrice(price);
        menu.setImagePath(imagePath);
        return menu;
    }

    /**
     * 총 금액 계산
     */
    public Integer calculateTotal(List<Menu> menuList) {
        return menuList.stream()
                .mapToInt(Menu::getPrice)
                .sum();
    }
}