package xyz.coldshine;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import javax.swing.*;
import java.awt.*;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

public class StationDisplay extends JFrame {
    private String stationJsonFile;
    private String stationBackgroundFile;
    private ArrayList<Station> stations;

    public StationDisplay(String stationJsonFile, String stationBackgroundFile) {
        // Read JSON file and create Station objects
        try {
            Gson gson = new Gson();
            FileReader reader = new FileReader(stationJsonFile);
            java.lang.reflect.Type stationListType = new TypeToken<ArrayList<Station>>() {
            }.getType();
            stations = gson.fromJson(reader, stationListType);
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        initializeUI(stationBackgroundFile);
    }

    private void initializeUI(String stationBackgroundFile) {
        setTitle("运行中 预览");
        setSize(2560, 500 + 42); // 调整窗口高度
        setResizable(false);

        // 读取背景图片
        Image backgroundImage = new ImageIcon(stationBackgroundFile).getImage();


        // Create a custom panel for background image
        JPanel backgroundPanel = new JPanel() {
            @Override
            protected void paintComponent(Graphics g) {
                super.paintComponent(g);
                // 绘制背景图片，使其填满整个窗口
                g.drawImage(backgroundImage, 0, 0, getWidth(), getHeight(), this);

                // 计算车站名称的旋转角度
                double rotationAngle = Math.toRadians(-45);

                // 获取车站名称的位置
                int xCN = 270; // 从左边开始显示
                int xEN = 290; // 从左边开始显示，稍微偏移
                int yCN = getHeight() / 2 + 12; // 居中
                int yEN = getHeight() / 2 + 15; // 居中

                int tempCN = xCN;
                int tempEN = xEN;

                // 设置字体
                Font cnFont = new Font("FZLTHPro Global", Font.PLAIN, 20);
                Font enFont = new Font("FZLTHPro Global", Font.PLAIN, 16);

                // 绘制车站名称
                for (Station station : stations) {

                    String cnName = station.getStationNameCN();
                    String enName = station.getStationNameEN();

                    // 绘制CN名称
                    Graphics2D g2dCN = (Graphics2D) g.create();
                    g2dCN.rotate(rotationAngle, xCN, yCN);
                    g2dCN.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON); // 设置抗锯齿
                    g2dCN.setFont(cnFont); // 设置字体大小
                    g2dCN.drawString(cnName, xCN, yCN); // 绘制CN名称
                    g2dCN.dispose();

                    // 绘制EN名称
                    Graphics2D g2dEN = (Graphics2D) g.create();
                    g2dEN.rotate(rotationAngle, xEN, yEN);
                    g2dEN.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON); // 设置抗锯齿
                    g2dEN.setFont(enFont); // 设置字体大小
                    g2dEN.drawString(enName, xEN, yEN); // 绘制EN名称
                    g2dEN.dispose();
                    // 调整下一个车站名称的位置
                    xCN += (2560 - tempCN - 150) / (stations.size() - 1); // 设置车站名称之间的间隔
                    xEN += (2560 - tempEN - 130) / (stations.size() - 1); // 设置车站名称之间的间隔
                }
            }
        };
        ;

        getContentPane().add(backgroundPanel);
        setLocationRelativeTo(null);
        setVisible(true);
    }

    /**
     * 获取
     *
     * @return stationJsonFile
     */
    public String getStationJsonFile() {
        return stationJsonFile;
    }

    /**
     * 设置
     *
     * @param stationJsonFile
     */
    public void setStationJsonFile(String stationJsonFile) {
        this.stationJsonFile = stationJsonFile;
    }

    /**
     * 获取
     *
     * @return stationBackgroundFile
     */
    public String getStationBackgroundFile() {
        return stationBackgroundFile;
    }

    /**
     * 设置
     *
     * @param stationBackgroundFile
     */
    public void setStationBackgroundFile(String stationBackgroundFile) {
        this.stationBackgroundFile = stationBackgroundFile;
    }

    /**
     * 获取
     *
     * @return stations
     */
    public ArrayList<Station> getStations() {
        return stations;
    }

    /**
     * 设置
     *
     * @param stations
     */
    public void setStations(ArrayList<Station> stations) {
        this.stations = stations;
    }

    public String toString() {
        return "StationDisplay{stationJsonFile = " + stationJsonFile + ", stationBackgroundFile = " + stationBackgroundFile + ", stations = " + stations + "}";
    }
}
