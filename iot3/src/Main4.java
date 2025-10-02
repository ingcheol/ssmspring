import util.HttpSendData;

import java.io.IOException;
import java.util.Random;

public class Main4 {
    public static void main(String[] args) throws IOException {
        String url = "https://127.0.0.1:8443/savedata";
        Random r = new Random();
        for(int i=0;i<1000;i++){
            int num = r.nextInt(400)+1;
            HttpSendData.send(url,"?data="+num);
            try {
                Thread.sleep(5000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }
}
