//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.

import util.HttpSendData;

import java.io.IOException;
import java.util.Random;

public class Main {
    public static void main(String[] args) throws IOException {
        String url = "https://10.20.38.210:8443/savedata";
        Random r = new Random();


        for(int i=0; i<100; i++){
            // --- [수정된 부분] ---
            // 4개의 다른 랜덤 숫자를 생성합니다.
            int num1 = r.nextInt(101); // 0~100
            int num2 = r.nextInt(101);
            int num3 = r.nextInt(101);
            int num4 = r.nextInt(101);

            // 4개의 숫자를 쉼표로 구분된 하나의 문자열로 만듭니다.
            String data = String.format("%d,%d,%d,%d", num1, num2, num3, num4);

            // 생성된 데이터 문자열을 전송합니다.
            System.out.println("Sending data: " + data);
            HttpSendData.send(url, "?data=" + data);

            try {
                Thread.sleep(4000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }
}