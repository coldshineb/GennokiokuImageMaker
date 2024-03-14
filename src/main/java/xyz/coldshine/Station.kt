package xyz.coldshine

class Station(
        /**
         * 设置
         *
         * @param stationNameCN
         */
        @JvmField var stationNameCN: String,
        /**
         * 设置
         *
         * @param stationNameEN
         */
        @JvmField var stationNameEN: String) {
    /**
     * 获取
     *
     * @return stationNameCN
     */
    /**
     * 获取
     *
     * @return stationNameEN
     */

    override fun toString(): String {
        return "Station{stationNameCN = $stationNameCN, stationNameEN = $stationNameEN}"
    }
}
