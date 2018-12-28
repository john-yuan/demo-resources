package org.example.app;

import java.net.URL;

public class App02 {
    public static void main(String[] args) {
        URL url = App02.class.getResource("/config.properties");
        System.out.println(" App02-Config-Path:");
        System.out.println("   " + url);
    }
}
