package com.example.ant_pebble_paalam;

import io.flutter.plugin.common.EventChannel;

public class HeartRateStream implements EventChannel.StreamHandler {
    private EventChannel.EventSink heartRateEventSink;

    public void addEvent(double data){
        heartRateEventSink.success(data);
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        System.out.println("on listen");
        heartRateEventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        heartRateEventSink = null;
    }
}
