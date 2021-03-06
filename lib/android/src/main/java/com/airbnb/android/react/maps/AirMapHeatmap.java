package com.airbnb.android.react.maps;

import android.content.Context;
import android.graphics.Color;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.TileOverlay;
import com.google.android.gms.maps.model.TileOverlayOptions;
import com.google.maps.android.heatmaps.Gradient;
import com.google.maps.android.heatmaps.HeatmapTileProvider;
import com.google.maps.android.heatmaps.WeightedLatLng;

import java.util.ArrayList;
import java.util.List;

public class AirMapHeatmap extends AirMapFeature {

    private TileOverlayOptions tileOverlayOptions;
    private TileOverlay tileOverlay;
    private HeatmapTileProvider heatmapTileProvider;
    private List<WeightedLatLng> points;
    private int radius;
    private Gradient gradient;
    private double opacity;

    public AirMapHeatmap(Context context) {
        super(context);
    }

    public void refreshMap() {
        if (tileOverlay != null) {
            tileOverlay.clearTileCache();
        }
    }

    public void setPoints(ReadableArray points) {
        this.points = new ArrayList<>(points.size());
        for (int i = 0; i < points.size(); i++) {
            ReadableMap point = points.getMap(i);
            WeightedLatLng weightedLatLng;
            LatLng latLng = new LatLng(point.getDouble("latitude"), point.getDouble("longitude"));
            weightedLatLng = new WeightedLatLng(latLng, point.getDouble("weight"));
            this.points.add(i, weightedLatLng);
        }
        if (heatmapTileProvider != null) {
            heatmapTileProvider.setWeightedData(this.points);
        }
        refreshMap();
    }

    public void setRadius(int radius) {
        this.radius = radius;
        if (radius > 50)
            this.radius = 50;
        if (radius < 10)
            this.radius = 10;
        if (heatmapTileProvider != null) {
            heatmapTileProvider.setRadius(this.radius);
            refreshMap();
        }
    }

    public void setGradient(ReadableMap gradient) {
        ReadableArray rawColors = gradient.getArray("colors");
        ReadableArray rawValues = gradient.getArray("values");
        int[] colors = new int[rawColors.size()];
        float[] values = new float[rawColors.size()];
        for (int i = 0; i < rawColors.size(); i++) {
            colors[i] = Color.parseColor(rawColors.getString(i));
            values[i] = ((float) rawValues.getDouble(i));
        }

        this.gradient = new Gradient(colors, values);
        if (heatmapTileProvider != null) {
            heatmapTileProvider.setGradient(this.gradient);
            refreshMap();
        }
    }

    public void setOpacity(double opacity) {
        this.opacity = opacity;
        if (heatmapTileProvider != null) {
            heatmapTileProvider.setOpacity(opacity);
            refreshMap();
        }
    }

    public TileOverlayOptions getTileOverlayOptions() {
        if (tileOverlayOptions == null) {
            tileOverlayOptions = createHeatmapOptions();
        }
        return tileOverlayOptions;
    }

    private TileOverlayOptions createHeatmapOptions() {
        TileOverlayOptions options = new TileOverlayOptions();
        if (heatmapTileProvider == null) {
            heatmapTileProvider = new HeatmapTileProvider.Builder().weightedData(this.points).radius(this.radius)
                    .gradient(this.gradient).opacity(this.opacity).build();
        }

        options.tileProvider(heatmapTileProvider);
        return options;
    }

    @Override
    public void addToMap(GoogleMap map) {
        tileOverlay = map.addTileOverlay(getTileOverlayOptions());
    }

    @Override
    public void removeFromMap(GoogleMap map) {
        if (tileOverlay != null) {
            tileOverlay.remove();
        }
    }

    @Override
    public Object getFeature() {
        return tileOverlay;
    }
}