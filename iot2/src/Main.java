//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.

import util.HttpSendData;

import java.io.IOException;
import java.util.Random;

public class Main {
    public static void main(String[] args) throws IOException {
        String url = "http://127.0.0.1:8443/iot";
        Random r = new Random();
        for(int i=0;i<100;i++){
            double lat = 36.800209 + r.nextDouble(0.005);
            double lng = 127.074968 + r.nextDouble(0.005);
            HttpSendData.send(url,"?lat="+lat+"&lng="+lng);
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }
}