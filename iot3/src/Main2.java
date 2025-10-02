import util.HttpSendData;

import java.io.IOException;
import java.util.Random;

public class Main2 {
    public static void main(String[] args) throws IOException {
        String url = "https://127.0.0.1:8443/savedata";
        Random r = new Random();
        for(int i=0;i<300;i++){
            int num = r.nextInt(200)+1;
            HttpSendData.send(url,"?data="+num);
            try {
                Thread.sleep(3000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }
}
