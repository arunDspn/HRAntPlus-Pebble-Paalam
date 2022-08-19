import 'package:ant_pebble_paalam/ant_api.dart';
import 'package:ant_pebble_paalam/home/antplus_status/cubit/ant_plus_connection_status_cubit.dart';
import 'package:ant_pebble_paalam/home/heart_rate_status/cubit/heart_rate_data_cubit.dart';
import 'package:ant_pebble_paalam/home/pebble_status/cubit/pebble_connection_status_cubit.dart';
import 'package:ant_pebble_paalam/main.dart';
import 'package:ant_pebble_paalam/pebble_api.dart';
import 'package:ant_pebble_paalam/search_devices/connect_ant_device_cubit/connect_ant_device_cubit.dart';
import 'package:ant_pebble_paalam/search_devices/search_devices_modal.dart';
import 'package:ant_pebble_paalam/search_devices/search_result_cubit/search_result_cubit.dart';
import 'package:ant_pebble_paalam/widgets/fullscreen_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'antplus_status/antplus_status_view.dart';
import 'heart_rate_status/heart_rate_view.dart';
import 'pebble_status/pebble_status_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    AntCallBacks.setup(FlutterCallbacks(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AntPlus Pebble Paalam"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (context) {
                    return const FullScreenLoader();
                  },
                );
              },
              icon: Icon(Icons.abc)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Pebble Connection Status
            PebbleConnectionStatus(),

            // AntPlus device connection status
            AntPlusDeviceConnectionStatus(),

            // Heart Rate
            Expanded(
              child: HeartRateView(),
            )
          ],
        ),
      ),
    );
  }
}

class FlutterCallbacks extends AntCallBacks {
  final BuildContext context;

  FlutterCallbacks(this.context);
  @override
  void devicesFound(List<DeviceInfo?> devices) {
    context.read<SearchResultCubit>().gotDevices(devices);
  }

  @override
  void deviceConnectionStatus(bool success, String? deviceName) {
    context.read<ConnectAntDeviceCubit>().connectionResultCallback(success);

    // Updating ant+ device status widget
    context
        .read<AntPlusConnectionStatusCubit>()
        .connectionStatusChanged(success, deviceName: deviceName);

    if (success) {
      context.read<HeartRateDataCubit>().heartRateStatusChanged(success);
    } else {
      context.read<HeartRateDataCubit>().heartRateStatusChanged(success);
    }
  }
}

class PebbleFlutterCallbacks extends PebbleCallBacks {
  final BuildContext context;

  PebbleFlutterCallbacks(this.context);
  @override
  void pebbleConnectionState(bool isConnected) {
    context
        .read<PebbleConnectionStatusCubit>()
        .setConnectionStatus(isConnected);
  }
}
