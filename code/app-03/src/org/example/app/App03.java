package org.example.app;

import java.net.URL;

public class App03 {
    public static void main(String[] args) {
        URL url = App03.class.getResource("/config.properties");
        System.out.println(" App03-Config-Path:");
        System.out.println("   " + url);
    }
}
