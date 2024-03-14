package xyz.coldshine;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import javax.imageio.ImageIO;
import javax.swing.*;
import javax.swing.filechooser.FileFilter;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Objects;

public class StationDisplay extends JFrame {
    private ArrayList<Station> stations;
    private JComboBox<String> stationComboBox;
    private JPanel backgroundPanel;
    private JPanel menuPanel;
    private JPanel imagePanel;
    private Image backgroundImage;
    private String stationJsonFile;
    private String stationBackgroundFile;

    public StationDisplay() {
        initializeUI();
    }

    private void initializeUI() {
        setIconImage(new ImageIcon(Objects.requireNonNull(StationDisplay.class.getResource("/icon.png"))).getImage());
        setTitle("运行中 预览");
        setSize(2560 + 22, 500 + 96); // 调整窗口高度，2560*500为背景图片大小，+的为组件扩展大小
        setResizable(false);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // 创建按钮
        JButton importStationButton = new JButton("导入站名");
        JButton importBackgroundButton = new JButton("导入背景");
        JButton saveButton = new JButton("保存图片");

        // 创建下拉菜单，用于指定“下一站”的站名
        stationComboBox = new JComboBox<>();
        //TODO 加一个下拉菜单选择终点站名称
        // 创建顶部菜单面板
        menuPanel = new JPanel();
        menuPanel.setLayout(new GridLayout(1, 4));
        menuPanel.add(importStationButton);
        menuPanel.add(importBackgroundButton);
        menuPanel.add(stationComboBox);
        menuPanel.add(saveButton);

        // 创建按钮事件
        importStationButton.addActionListener(e -> {
            // Open file chooser for station JSON file
            JFileChooser fileChooser = new JFileChooser();
            fileChooser.setFileFilter(new FileFilter() {
                @Override
                public boolean accept(File f) {
                    return f.isDirectory() || f.getName().toLowerCase().endsWith(".json");
                }

                @Override
                public String getDescription() {
                    return "站名文件 (*.json)";
                }
            });
            int result = fileChooser.showOpenDialog(StationDisplay.this);
            if (result == JFileChooser.APPROVE_OPTION) {
                File selectedFile = fileChooser.getSelectedFile();
                stationJsonFile = selectedFile.getAbsolutePath();

                loadStationsFromJson(stationJsonFile);
                render();
            }
        });

        importBackgroundButton.addActionListener(e -> {
            // Open file chooser for background image
            JFileChooser fileChooser = new JFileChooser();
            fileChooser.setFileFilter(new FileFilter() {
                @Override
                public boolean accept(File f) {
                    return f.isDirectory() || f.getName().toLowerCase().endsWith(".png");
                }

                @Override
                public String getDescription() {
                    return "背景图片 (*.png)";
                }
            });
            int result = fileChooser.showOpenDialog(StationDisplay.this);
            if (result == JFileChooser.APPROVE_OPTION) {
                File selectedFile = fileChooser.getSelectedFile();
                stationBackgroundFile = selectedFile.getAbsolutePath();
                backgroundPanel.repaint(); // Refresh background panel with new image

                // Read background image
                backgroundImage = new ImageIcon(stationBackgroundFile).getImage();

                render();
            }
        });

        saveButton.addActionListener(e -> saveAsImage());

        // 创建背景面板
        backgroundPanel = new JPanel(new BorderLayout());

        // 添加菜单面板
        backgroundPanel.add(menuPanel, BorderLayout.NORTH);

        // 添加面板到 JFrame
        getContentPane().setLayout(new BorderLayout());
        getContentPane().add(backgroundPanel, BorderLayout.CENTER);
        //getContentPane().add(menuPanel, BorderLayout.NORTH);

        setLocationRelativeTo(null);
        setVisible(true);
    }

    private void render() {
        // 创建图片面板
        imagePanel = new JPanel() {
            @Override
            protected void paintComponent(Graphics g) {
                super.paintComponent(g);
                Graphics2D g2d = (Graphics2D) g.create();
                g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);// 设置抗锯齿
                g2d.drawImage(backgroundImage, 0, 0, getWidth(), getHeight(), this);
                g2d.dispose();
                renderStationName(g);
                //TODO 使用色值绘制站点标识  换乘图标
            }
        };
        backgroundPanel.add(imagePanel, BorderLayout.CENTER);//添加图片面板到背景面板
        backgroundPanel.revalidate();
        updateStationComboBox();
    }

    // 绘制车站名称
    private void renderStationName(Graphics g) {
        if (stations != null) {
            // 车站名称逆时针转 45 度
            double rotationAngle = Math.toRadians(-45);
            // 设置字体，英文比中文小一些 TODO 把字体内置在程序中，因为此字体是手动安装的
            Font cnFont = new Font("FZLTHPro Global", Font.PLAIN, 21);
            Font enFont = new Font("FZLTHPro Global", Font.PLAIN, 17);
            int xCN = 270; // 中文站名开始显示的 x 位置
            int xEN = 285; // 英文站名开始显示的 x 位置，需要在中文站名的右侧 20 像素
            int yCN = getHeight() / 2 - 33; // 中文站名显示的 y 位置
            int yEN = getHeight() / 2 - 25; // 英文站名显示的 y 位置
            int tempCN = xCN; //需要给临时变量用于后面调整下一个车站名称的位置
            int tempEN = xEN;
            for (Station station : stations) {
                String cnName = station.getStationNameCN();
                String enName = station.getStationNameEN();
                // 绘制中文站名
                Graphics2D g2dCN = (Graphics2D) g.create();
                g2dCN.rotate(rotationAngle, xCN, yCN);
                g2dCN.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON); // 设置抗锯齿
                g2dCN.setFont(cnFont);
                g2dCN.setColor(Color.BLACK);
                g2dCN.drawString(cnName, xCN, yCN);
                g2dCN.dispose();
                // 绘制英文站名
                Graphics2D g2dEN = (Graphics2D) g.create();
                g2dEN.rotate(rotationAngle, xEN, yEN);
                g2dEN.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON); // 设置抗锯齿
                g2dEN.setFont(enFont);
                g2dEN.setColor(Color.BLACK);
                g2dEN.drawString(enName, xEN, yEN);
                g2dEN.dispose();
                // 调整下一个车站名称的位置
                // 等距离绘制，最后一个中文站名在窗口右侧 150 像素处，英文在 130 处
                xCN += (2560 - tempCN - 150) / (stations.size() - 1);
                xEN += (2560 - tempEN - 130) / (stations.size() - 1);
            }
        }
    }

    //从 Json 中读取站名信息并存到 stations 集合中
    private void loadStationsFromJson(String stationJsonFile) {
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
    }

    // 在加载站名文件后更新站名下拉列表
    private void updateStationComboBox() {
        if (stations != null && !stations.isEmpty()) {
            stationComboBox.removeAllItems();
            for (Station station : stations) {
                stationComboBox.addItem(station.getStationNameCN());
            }
        }
    }

    // 保存最终结果为图片，抄的，能用就行
    private void saveAsImage() {
        try {
            // Create image from image panel
            BufferedImage image = new BufferedImage(imagePanel.getWidth(), imagePanel.getHeight(), BufferedImage.TYPE_INT_RGB);
            Graphics2D graphics = image.createGraphics();
            imagePanel.paint(graphics);

            // Open file dialog for saving
            FileDialog fileDialog = new FileDialog(new JFrame(), "保存图片", FileDialog.SAVE);
            fileDialog.setVisible(true);
            String fileName = fileDialog.getFile();
            String directory = fileDialog.getDirectory();

            // If file chosen, save image
            if (fileName != null && directory != null) {
                ImageIO.write(image, "png", new File(directory + fileName + ".png"));
                JOptionPane.showMessageDialog(null, "图片已保存");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            JOptionPane.showMessageDialog(null, "保存失败: " + ex.getMessage());
        }
    }

}
