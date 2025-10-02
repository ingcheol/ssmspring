import util.HttpSendData;

import java.io.IOException;
import java.util.Random;

public class Main3 {
    public static void main(String[] args) throws IOException {
        String url = "https://127.0.0.1:8443/savedata";
        Random r = new Random();
        for(int i=0;i<500;i++){
            int num = r.nextInt(300)+1;
            HttpSendData.send(url,"?data="+num);
            try {
                Thread.sleep(4000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }
}
