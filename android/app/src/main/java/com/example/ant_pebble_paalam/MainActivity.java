package com.example.ant_pebble_paalam;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.dsi.ant.plugins.antplus.pcc.AntPlusHeartRatePcc;
import com.dsi.ant.plugins.antplus.pcc.MultiDeviceSearch;
import com.dsi.ant.plugins.antplus.pcc.defines.DeviceState;
import com.dsi.ant.plugins.antplus.pcc.defines.DeviceType;
import com.dsi.ant.plugins.antplus.pcc.defines.EventFlag;
import com.dsi.ant.plugins.antplus.pcc.defines.RequestAccessResult;
import com.dsi.ant.plugins.antplus.pccbase.AntPluginPcc;
import com.dsi.ant.plugins.antplus.pccbase.PccReleaseHandle;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;
import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.EventChannel;

public class MainActivity extends FlutterActivity {
    final String heartRateChannel = "com.example.ant_pebble_paalam/streamChannel";
    AntPlusHeartRatePcc hRR = null;
    private AntServices.AntCallBacks antCallBacks;
    private Handler handler;
    private HeartRateStream heartRateStream = new HeartRateStream();


    private class AntServiceApi implements AntServices.AntApi {

        @Override
        public void searchDevices() {
            EnumSet<DeviceType> hrDevices;
            hrDevices = EnumSet.of(DeviceType.HEARTRATE);
            new MultiDeviceSearch(getContext(), hrDevices, mCallback);
        }

        @Override
        public void connectToDevice(@NonNull Long deviceNumber) {
            PccReleaseHandle<AntPlusHeartRatePcc> handle = AntPlusHeartRatePcc.requestAccess(getContext(), deviceNumber.intValue(), 1, resultReceiver, deviceStateChangeReceiver);
        }

        @Override
        public void disconnectDevice() {
            hRR.releaseAccess();
        }

        @Override
        public void subscribeToHeartRateData() {

        }
    }

    /**
     * Callbacks from the multi-device search interface
     */
    public final MultiDeviceSearch.SearchCallbacks mCallback;

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
                handler.post(() -> antCallBacks.devicesFound(result, reply -> System.out.println("Found Device Result sent")));
            }

            @Override
            public void onSearchStopped(RequestAccessResult requestAccessResult) {
                System.out.println("Started Stopped");
            }

            ;
        };
    }

    // For Request Access callbacks interface impl
    // Result receiver
    public AntPluginPcc.IPluginAccessResultReceiver<AntPlusHeartRatePcc> resultReceiver;

    {
        resultReceiver = new AntPluginPcc.IPluginAccessResultReceiver<AntPlusHeartRatePcc>() {
            @Override
            public void onResultReceived(AntPlusHeartRatePcc antPlusHeartRatePcc, RequestAccessResult requestAccessResult, DeviceState deviceState) {
                System.out.println("Result Received - Result :-" + requestAccessResult.toString());
                System.out.println("Device state" + deviceState.toString());
                // create dynamically not like so
                handler = new Handler(Looper.getMainLooper());
                switch (requestAccessResult) {
                    case SUCCESS:
                        handler.post(() -> antCallBacks.deviceConnectionStatus(true, antPlusHeartRatePcc.getDeviceName(), reply -> System.out.println("Success connection callbacks")));
                        this.subscribeToHeartRateData(antPlusHeartRatePcc);
                        break;
                    case DEVICE_ALREADY_IN_USE:
                        System.out.println("Already in use");
                        handler.post(() -> antCallBacks.deviceConnectionStatus(false, null, reply -> System.out.println("Success connection callbacks")));
                        break;
                    default:
                        handler.post(() -> antCallBacks.deviceConnectionStatus(false, null, reply -> System.out.println("Success connection callbacks")));
                        System.out.println("Default handler");
                }

            }

            // Subscribing to Heart rate dataset
            public void subscribeToHeartRateData(AntPlusHeartRatePcc antPlusHeartRatePcc) {
                // info flutter about it :-)
                hRR = antPlusHeartRatePcc;
                hRR.subscribeHeartRateDataEvent(new AntPlusHeartRatePcc.IHeartRateDataReceiver() {
                    @Override
                    public void onNewHeartRateData(long l, EnumSet<EventFlag> enumSet,
                                                   int i, long l1, BigDecimal bigDecimal,
                                                   AntPlusHeartRatePcc.DataState dataState) {
                        System.out.println(dataState.getIntValue());
                        // Call stream
                        new Handler(Looper.getMainLooper()).post(() -> heartRateStream.addEvent(dataState.getIntValue() + i));

                    }
                });
            }
        };
    }

    // State Changer imp for search devices
    AntPluginPcc.IDeviceStateChangeReceiver deviceStateChangeReceiver = new AntPluginPcc.IDeviceStateChangeReceiver() {
        @Override
        public void onDeviceStateChange(DeviceState deviceState) {
            System.out.println(deviceState.toString() + "State Changed ---" + deviceState);
            switch (deviceState) {
                case DEAD:
                    hRR.releaseAccess();
                    break;
                default:
                    System.out.println("Another");

            }
        }
    };


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AntServices.AntApi.setup(Objects.requireNonNull(getFlutterEngine()).getDartExecutor().getBinaryMessenger(), new AntServiceApi());
        antCallBacks = new AntServices.AntCallBacks(getFlutterEngine().getDartExecutor().getBinaryMessenger());
        new EventChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), heartRateChannel)
                .setStreamHandler(heartRateStream);
    }
}
