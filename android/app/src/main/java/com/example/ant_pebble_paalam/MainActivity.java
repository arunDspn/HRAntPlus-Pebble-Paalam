package com.example.ant_pebble_paalam;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
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
    private AntServices.AntCallBacks antCallBacks;
    private Handler handler;

    private class AntServiceApi implements AntServices.AntApi {

        @Override
        public void searchDevices() {
            EnumSet<DeviceType> hrDevices;
            hrDevices = EnumSet.of(DeviceType.HEARTRATE);
            new MultiDeviceSearch(getContext(),hrDevices,new AntPlusServices().mCallback);
        }

        @Override
        public void connectToDevice(@NonNull Long deviceNumber) {
            PccReleaseHandle<AntPlusHeartRatePcc> handle =  AntPlusHeartRatePcc.requestAccess(getContext(),deviceNumber.intValue(),1,resultReceiver,deviceStateChangeReceiver);

        }
    }

    private class AntPlusServices {

        /**
         * Callbacks from the multi-device search interface
         */
        private final MultiDeviceSearch.SearchCallbacks mCallback;

        {
            mCallback = new MultiDeviceSearch.SearchCallbacks() {
                @Override
                public void onSearchStarted(MultiDeviceSearch.RssiSupport rssiSupport) {
                    System.out.println("Started");
                }

                @Override
                public void onDeviceFound(com.dsi.ant.plugins.antplus.pccbase.MultiDeviceSearch.MultiDeviceSearchResult multiDeviceSearchResult) {
                    System.out.println("Found Device");
                    handler = new Handler(Looper.getMainLooper());
                    final AntServices.DeviceInfo device = new AntServices.DeviceInfo.Builder().setDeviceNumber(new Long(multiDeviceSearchResult.getAntDeviceNumber())).setDeviceName(multiDeviceSearchResult.getDeviceDisplayName()).build();
                    final List<AntServices.DeviceInfo> result = new ArrayList<>();
                    result.add(device);
                    handler.post(() -> antCallBacks.devicesFound(result, reply -> System.out.println("Result sent")));
                }

                @Override
                public void onSearchStopped(RequestAccessResult requestAccessResult) {
                    System.out.println("Started Stopped");
                }


            };
        }

    }

    // For Request Access callbacks interface impl
    // Result receiver
    public AntPluginPcc.IPluginAccessResultReceiver<AntPlusHeartRatePcc> resultReceiver = new AntPluginPcc.IPluginAccessResultReceiver<AntPlusHeartRatePcc>() {
        @Override
        public void onResultReceived(AntPlusHeartRatePcc antPlusHeartRatePcc, RequestAccessResult requestAccessResult, DeviceState deviceState) {
            System.out.println("Result Received" + deviceState.toString());
            hRR = antPlusHeartRatePcc;
            hRR.subscribeHeartRateDataEvent(new AntPlusHeartRatePcc.IHeartRateDataReceiver() {
                @Override
                public void onNewHeartRateData(long l, EnumSet<EventFlag> enumSet, int i, long l1, BigDecimal bigDecimal, AntPlusHeartRatePcc.DataState dataState) {
                    System.out.println(dataState);
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


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AntServices.AntApi.setup(getFlutterEngine().getDartExecutor().getBinaryMessenger(),new AntServiceApi());
        antCallBacks = new AntServices.AntCallBacks(getFlutterEngine().getDartExecutor().getBinaryMessenger());
    }
}
