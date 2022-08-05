package com.example.ant_pebble_paalam;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;

import com.dsi.ant.plugins.antplus.pcc.MultiDeviceSearch;
import com.dsi.ant.plugins.antplus.pcc.defines.DeviceState;
import com.dsi.ant.plugins.antplus.pcc.defines.DeviceType;
import com.dsi.ant.plugins.antplus.pcc.defines.EventFlag;
import com.dsi.ant.plugins.antplus.pcc.defines.RequestAccessResult;
import com.dsi.ant.plugins.antplus.pcc.AntPlusHeartRatePcc;
import com.dsi.ant.plugins.antplus.pccbase.PccReleaseHandle;
import com.example.ant_pebble_paalam.AntServices;

import com.dsi.ant.plugins.antplus.pccbase.AntPluginPcc;


import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;

public class MainActivity extends FlutterActivity {
    AntPlusHeartRatePcc hRR = null;

    private class AntServiceApi implements AntServices.AntApi {
        @NonNull
        @Override
        public List<AntServices.Device> searchDevices() {
            AntServices.Device device = new AntServices.Device.Builder().setDeviceName("Super").build();
            EnumSet<DeviceType> hrDevices;
            hrDevices = EnumSet.of(DeviceType.HEARTRATE);
            MultiDeviceSearch mSearch = new MultiDeviceSearch(getContext(),hrDevices,new AntPlusServices().mCallback);
            List<AntServices.Device> devices = new ArrayList<AntServices.Device>();
            devices.add(device);
            return devices;
        }
    }

    private class AntPlusServices {
        void searchHRDevices(){

        }

        /**
         * Callbacks from the multi-device search interface
         */
        private final MultiDeviceSearch.SearchCallbacks mCallback = new MultiDeviceSearch.SearchCallbacks()
        {
            @Override
            public void onSearchStarted(MultiDeviceSearch.RssiSupport rssiSupport) {
                System.out.println("Started");
            }

            @Override
            public void onDeviceFound(com.dsi.ant.plugins.antplus.pccbase.MultiDeviceSearch.MultiDeviceSearchResult multiDeviceSearchResult) {
                System.out.println("Found");
                System.out.println(multiDeviceSearchResult.getDeviceDisplayName());
                System.out.println(multiDeviceSearchResult.getAntDeviceType());
                System.out.println(multiDeviceSearchResult.getDeviceDisplayName());
                /*
                Activity userActivity,
                  Context bindToContext,
                  AntPluginPcc.IPluginAccessResultReceiver<AntPlusHeartRatePcc> resultReceiver,
                  AntPluginPcc.IDeviceStateChangeReceiver stateReceiver
                * */
                PccReleaseHandle<AntPlusHeartRatePcc> handle =  AntPlusHeartRatePcc.requestAccess(getContext(),multiDeviceSearchResult.getAntDeviceNumber(),1,resultReceiver,deviceStateChangeReceiver);



            }

            @Override
            public void onSearchStopped(RequestAccessResult requestAccessResult) {
                System.out.println("Started Stopped");
            }

        
        };

        // For Request Access callbacks interface impl
        // Result receiver
        AntPluginPcc.IPluginAccessResultReceiver<AntPlusHeartRatePcc> resultReceiver = new AntPluginPcc.IPluginAccessResultReceiver<AntPlusHeartRatePcc>() {
            @Override
            public void onResultReceived(AntPlusHeartRatePcc antPlusHeartRatePcc, RequestAccessResult requestAccessResult, DeviceState deviceState) {
                System.out.println("Result Received" + deviceState.toString());
                hRR = antPlusHeartRatePcc;
                hRR.subscribeHeartRateDataEvent(new AntPlusHeartRatePcc.IHeartRateDataReceiver() {
                    @Override
                    public void onNewHeartRateData(long l, EnumSet<EventFlag> enumSet, int i, long l1, BigDecimal bigDecimal, AntPlusHeartRatePcc.DataState dataState) {
                        System.out.println(dataState.getIntValue());
                    }
                });
            }
        };

        // State Changer imp for search devices
        AntPluginPcc.IDeviceStateChangeReceiver deviceStateChangeReceiver = new AntPluginPcc.IDeviceStateChangeReceiver() {
            @Override
            public void onDeviceStateChange(DeviceState deviceState) {
                System.out.println(deviceState.toString() + "State Changed ---");
            }
        };
    }


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AntServices.AntApi.setup(getFlutterEngine().getDartExecutor().getBinaryMessenger(),new AntServiceApi());
    }
}
