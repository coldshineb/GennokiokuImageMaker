package xyz.coldshine;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.io.FileReader;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;

public class Station {
    private String stationNameCN;
    private String stationNameEN;

    public Station() {
    }

    public Station(String stationNameCN, String stationNameEN) {
        this.stationNameCN = stationNameCN;
        this.stationNameEN = stationNameEN;
    }

    public static void getStation() throws IOException {
        // Read JSON file and create Station objects
        ArrayList<Station> stations = new ArrayList<>();
        try {
            Gson gson = new Gson();
            FileReader reader = new FileReader("line3.json");
            Type stationListType = new TypeToken<ArrayList<Station>>(){}.getType();
            stations = gson.fromJson(reader, stationListType);
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
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
