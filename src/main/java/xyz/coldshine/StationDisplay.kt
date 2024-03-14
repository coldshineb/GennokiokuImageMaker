package xyz.coldshine

import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.awt.*
import java.awt.image.BufferedImage
import java.io.File
import java.io.FileReader
import java.io.IOException
import java.util.*
import javax.imageio.ImageIO
import javax.swing.*
import javax.swing.filechooser.FileFilter

class StationDisplay : JFrame() {
    private var stations: ArrayList<Station>? = null
    private var stationComboBox: JComboBox<String>? = null
    private var backgroundPanel: JPanel? = null
    private var menuPanel: JPanel? = null
    private var imagePanel: JPanel? = null
    private var backgroundImage: Image? = null
    private var stationJsonFile: String? = null
    private var stationBackgroundFile: String? = null

    init {
        initializeUI()
    }

    private fun initializeUI() {
        iconImage = ImageIcon(Objects.requireNonNull(StationDisplay::class.java.getResource("/icon.png"))).image
        title = "运行中 预览"
        setSize(2560 + 22, 500 + 96) // 调整窗口高度，2560*500为背景图片大小，+的为组件扩展大小
        isResizable = false
        defaultCloseOperation = EXIT_ON_CLOSE

        // 创建按钮
        val importStationButton = JButton("导入站名")
        val importBackgroundButton = JButton("导入背景")
        val saveButton = JButton("保存图片")

        // 创建下拉菜单，用于指定“下一站”的站名
        stationComboBox = JComboBox()
        //TODO 加一个下拉菜单选择终点站名称
        // 创建顶部菜单面板
        menuPanel = JPanel()
        menuPanel!!.layout = GridLayout(1, 4)
        menuPanel!!.add(importStationButton)
        menuPanel!!.add(importBackgroundButton)
        menuPanel!!.add(stationComboBox)
        menuPanel!!.add(saveButton)

        // 创建按钮事件
        importStationButton.addActionListener {
            // Open file chooser for station JSON file
            val fileChooser = JFileChooser()
            fileChooser.fileFilter = object : FileFilter() {
                override fun accept(f: File): Boolean {
                    return f.isDirectory || f.name.lowercase(Locale.getDefault()).endsWith(".json")
                }

                override fun getDescription(): String {
                    return "站名文件 (*.json)"
                }
            }
            val result = fileChooser.showOpenDialog(this@StationDisplay)
            if (result == JFileChooser.APPROVE_OPTION) {
                val selectedFile = fileChooser.selectedFile
                stationJsonFile = selectedFile.absolutePath

                loadStationsFromJson(stationJsonFile)
                render()
            }
        }

        importBackgroundButton.addActionListener {
            // Open file chooser for background image
            val fileChooser = JFileChooser()
            fileChooser.fileFilter = object : FileFilter() {
                override fun accept(f: File): Boolean {
                    return f.isDirectory || f.name.lowercase(Locale.getDefault()).endsWith(".png")
                }

                override fun getDescription(): String {
                    return "背景图片 (*.png)"
                }
            }
            val result = fileChooser.showOpenDialog(this@StationDisplay)
            if (result == JFileChooser.APPROVE_OPTION) {
                val selectedFile = fileChooser.selectedFile
                stationBackgroundFile = selectedFile.absolutePath
                backgroundPanel!!.repaint() // Refresh background panel with new image

                // Read background image
                backgroundImage = ImageIcon(stationBackgroundFile).image

                render()
            }
        }

        saveButton.addActionListener { saveAsImage() }

        // 创建背景面板
        backgroundPanel = JPanel(BorderLayout())

        // 添加菜单面板
        backgroundPanel!!.add(menuPanel, BorderLayout.NORTH)

        // 添加面板到 JFrame
        contentPane.layout = BorderLayout()
        contentPane.add(backgroundPanel, BorderLayout.CENTER)

        //getContentPane().add(menuPanel, BorderLayout.NORTH);
        setLocationRelativeTo(null)
        isVisible = true
    }

    private fun render() {
        // 创建图片面板
        imagePanel = object : JPanel() {
            override fun paintComponent(g: Graphics) {
                super.paintComponent(g)
                val g2d = g.create() as Graphics2D
                g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON) // 设置抗锯齿
                g2d.drawImage(backgroundImage, 0, 0, width, height, this)
                g2d.dispose()
                renderStationName(g)
                //TODO 使用色值绘制站点标识  换乘图标
            }
        }
        backgroundPanel!!.add(imagePanel, BorderLayout.CENTER) //添加图片面板到背景面板
        backgroundPanel!!.revalidate()
        updateStationComboBox()
    }

    // 绘制车站名称
    private fun renderStationName(g: Graphics) {
        if (stations != null) {
            // 车站名称逆时针转 45 度
            val rotationAngle = Math.toRadians(-45.0)
            // 设置字体，英文比中文小一些 TODO 把字体内置在程序中，因为此字体是手动安装的
            val cnFont = Font("FZLTHPro Global", Font.PLAIN, 21)
            val enFont = Font("FZLTHPro Global", Font.PLAIN, 17)
            var xCN = 270 // 中文站名开始显示的 x 位置
            var xEN = 285 // 英文站名开始显示的 x 位置，需要在中文站名的右侧 20 像素
            val yCN = height / 2 - 33 // 中文站名显示的 y 位置
            val yEN = height / 2 - 25 // 英文站名显示的 y 位置
            val tempCN = xCN //需要给临时变量用于后面调整下一个车站名称的位置
            val tempEN = xEN
            for (station in stations!!) {
                val cnName = station.stationNameCN
                val enName = station.stationNameEN
                // 绘制中文站名
                val g2dCN = g.create() as Graphics2D
                g2dCN.rotate(rotationAngle, xCN.toDouble(), yCN.toDouble())
                g2dCN.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON) // 设置抗锯齿
                g2dCN.font = cnFont
                g2dCN.color = Color.BLACK
                g2dCN.drawString(cnName, xCN, yCN)
                g2dCN.dispose()
                // 绘制英文站名
                val g2dEN = g.create() as Graphics2D
                g2dEN.rotate(rotationAngle, xEN.toDouble(), yEN.toDouble())
                g2dEN.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON) // 设置抗锯齿
                g2dEN.font = enFont
                g2dEN.color = Color.BLACK
                g2dEN.drawString(enName, xEN, yEN)
                g2dEN.dispose()
                // 调整下一个车站名称的位置
                // 等距离绘制，最后一个中文站名在窗口右侧 150 像素处，英文在 130 处
                xCN += (2560 - tempCN - 150) / (stations!!.size - 1)
                xEN += (2560 - tempEN - 130) / (stations!!.size - 1)
            }
        }
    }

    //从 Json 中读取站名信息并存到 stations 集合中
    private fun loadStationsFromJson(stationJsonFile: String?) {
        try {
            val gson = Gson()
            val reader = FileReader(stationJsonFile)
            val stationListType = object : TypeToken<ArrayList<Station?>?>() {
            }.type
            stations = gson.fromJson(reader, stationListType)
            reader.close()
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }

    // 在加载站名文件后更新站名下拉列表
    private fun updateStationComboBox() {
        if (stations != null && stations!!.isNotEmpty()) {
            stationComboBox!!.removeAllItems()
            for (station in stations!!) {
                stationComboBox!!.addItem(station.stationNameCN)
            }
        }
    }

    // 保存最终结果为图片，抄的，能用就行
    private fun saveAsImage() {
        try {
            // Create image from image panel
            val image = BufferedImage(imagePanel!!.width, imagePanel!!.height, BufferedImage.TYPE_INT_RGB)
            val graphics = image.createGraphics()
            imagePanel!!.paint(graphics)

            // Open file dialog for saving
            val fileDialog = FileDialog(JFrame(), "保存图片", FileDialog.SAVE)
            fileDialog.isVisible = true
            val fileName = fileDialog.file
            val directory = fileDialog.directory

            // If file chosen, save image
            if (fileName != null && directory != null) {
                ImageIO.write(image, "png", File("$directory$fileName.png"))
                JOptionPane.showMessageDialog(null, "图片已保存")
            }
        } catch (ex: Exception) {
            ex.printStackTrace()
            JOptionPane.showMessageDialog(null, "保存失败: " + ex.message)
        }
    }
}
