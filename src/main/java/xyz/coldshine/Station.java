package xyz.coldshine;

public class Station {
    private String stationNameCN;
    private String stationNameEN;

    public Station(String stationNameCN, String stationNameEN) {
        this.stationNameCN = stationNameCN;
        this.stationNameEN = stationNameEN;
    }

    /**
     * 获取
     *
     * @return stationNameCN
     */
    public String getStationNameCN() {
        return stationNameCN;
    }

    /**
     * 设置
     *
     * @param stationNameCN
     */
    public void setStationNameCN(String stationNameCN) {
        this.stationNameCN = stationNameCN;
    }

    /**
     * 获取
     *
     * @return stationNameEN
     */
    public String getStationNameEN() {
        return stationNameEN;
    }

    /**
     * 设置
     *
     * @param stationNameEN
     */
    public void setStationNameEN(String stationNameEN) {
        this.stationNameEN = stationNameEN;
    }

    @Override
    public String toString() {
        return "Station{stationNameCN = " + stationNameCN + ", stationNameEN = " + stationNameEN + "}";
    }
}
