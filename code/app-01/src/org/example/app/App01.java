package org.example.app;

import java.net.URL;

public class App01 {
    public static void main(String[] args) {
        URL url = App01.class.getResource("/config.properties");
        System.out.println("    App01: " + url);
    }
}
