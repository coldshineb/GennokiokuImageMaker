package xyz.coldshine

import com.formdev.flatlaf.themes.FlatMacDarkLaf

object Main {
    @JvmStatic
    fun main(args: Array<String>) {
        FlatMacDarkLaf.setup()
        StationDisplay()
    }
}