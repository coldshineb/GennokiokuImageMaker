package xyz.coldshine;

import com.formdev.flatlaf.FlatIntelliJLaf;

import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException {
        FlatIntelliJLaf.setup();
        new StationDisplay("line3.json","运行中001000.png");
        new StationDisplay("line1.json","运行中002000.png");
    }
}