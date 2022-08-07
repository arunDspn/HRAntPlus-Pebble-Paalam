import 'package:ant_pebble_paalam/ant_api.dart';
import 'package:ant_pebble_paalam/main.dart';
import 'package:ant_pebble_paalam/search_devices/search_devices_modal.dart';
import 'package:ant_pebble_paalam/search_devices/search_result_cubit/search_result_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Pebble Connection Status
            Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Pebble Connected"),
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                ],
              ),
            ),
            // AntPlus device connection status
            AntPlusDeviceConnectionStatus(),

            // Heart Rate
            const Expanded(
              child: Center(
                child: Text(
                  "121",
                  style: TextStyle(
                    fontSize: 120,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AntPlusDeviceConnectionStatus extends StatelessWidget {
  const AntPlusDeviceConnectionStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: 80,
          margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          // padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("No device connected"),
              const SizedBox(
                width: 10,
              ),
              MaterialButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (context) {
                      AntApi().searchDevices();
                      return SearchDevicesModal();
                    },
                  );
                },
                color: Colors.deepOrange,
                child: const Text('Connect'),
              ),
            ],
          ),
        ),
        Positioned(
          left: 25,
          top: 12,
          child: Container(
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            color: kPrimaryColorBackground,
            child: const Text(
              'Ant+ Device',
            ),
          ),
        ),
      ],
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
}
