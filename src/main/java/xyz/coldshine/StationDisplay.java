package xyz.coldshine;

import com.formdev.flatlaf.FlatIntelliJLaf;
import com.formdev.flatlaf.themes.FlatMacDarkLaf;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import javax.swing.*;
import java.awt.*;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;

public class StationDisplay extends JFrame {
    private ArrayList<Station> stations;

    public StationDisplay(ArrayList<Station> stations) {
        this.stations = stations;
        initializeUI();
    }

    private void initializeUI() {
        setTitle("Station Display");
        setSize(2560, 542); // 调整窗口高度
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // 读取背景图片
        Image backgroundImage = new ImageIcon("运行中001000.png").getImage();


        // Create a custom panel for background image
        JPanel backgroundPanel = new JPanel() {
            @Override
            protected void paintComponent(Graphics g) {
                super.paintComponent(g);
                // 绘制背景图片，使其填满整个窗口
                g.drawImage(backgroundImage, 0, 0, getWidth(), getHeight(), this);

                // 计算车站名称的旋转角度
                double rotationAngle = Math.toRadians(-45);

                // 设置字体和颜色
                Font font = new Font("微软雅黑", Font.PLAIN, 20);
                g.setFont(font);
                ((Graphics2D) g).setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON); // 开启抗锯齿
                g.setColor(Color.BLACK);

                // 获取车站名称的位置
                int xCN = 350; // 从左边开始显示
                int xEN = 390; // 从左边开始显示，稍微偏移
                int y = getHeight() / 2 + 12; // 居中

                int tempCN = xCN;
                int tempEN = xEN;
                // 绘制车站名称
                for (Station station : stations) {

                    String cnName = station.getStationNameCN();
                    String enName = station.getStationNameEN();

                    // 绘制CN名称
                    Graphics2D g2dCN = (Graphics2D) g.create();
                    g2dCN.rotate(rotationAngle, xCN, y);
                    g2dCN.drawString(cnName, xCN, y); // 绘制CN名称
                    g2dCN.dispose();

                    // 绘制EN名称
                    Graphics2D g2dEN = (Graphics2D) g.create();
                    g2dEN.rotate(rotationAngle, xEN, y);
                    g2dEN.drawString(enName, xEN, y); // 绘制EN名称
                    g2dEN.dispose();
                    // 调整下一个车站名称的位置
                    xCN += (2560 - tempCN - 210) / (stations.size() - 1); // 设置车站名称之间的间隔
                    xEN += (2560 - tempEN - 170) / (stations.size() - 1); // 设置车站名称之间的间隔
                }
            }
        };
        ;

        getContentPane().add(backgroundPanel);
        setLocationRelativeTo(null);
        setVisible(true);
    }

    public static void main(String[] args) {
        // Read JSON file and create Station objects
        ArrayList<Station> stations = new ArrayList<>();
        try {
            Gson gson = new Gson();
            FileReader reader = new FileReader("line3.json");
            java.lang.reflect.Type stationListType = new TypeToken<ArrayList<Station>>() {
            }.getType();
            stations = gson.fromJson(reader, stationListType);
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        FlatMacDarkLaf.setup();
        ArrayList<Station> finalStations = stations;
        SwingUtilities.invokeLater(() -> new StationDisplay(finalStations));
    }
}
