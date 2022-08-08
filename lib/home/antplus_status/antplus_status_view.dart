import 'package:ant_pebble_paalam/ant_api.dart';
import 'package:ant_pebble_paalam/home/antplus_status/cubit/ant_plus_connection_status_cubit.dart';
import 'package:ant_pebble_paalam/main.dart';
import 'package:ant_pebble_paalam/search_devices/search_devices_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          child: BlocBuilder<AntPlusConnectionStatusCubit,
              AntPlusConnectionStatusState>(
            builder: (context, state) {
              if (state is AntPlusConnectionStatusNoDeviceConnected) {
                return _notConnected(context);
              } else if (state is AntPlusConnectionStatusDeviceConnected) {
                return _connected(context, state.deviceName);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
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

  Widget _notConnected(BuildContext context) {
    return Row(
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
    );
  }

  Widget _connected(BuildContext context, String deviceName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        const Text("Garmin HRM Dual"),
        const SizedBox(
          width: 10,
        ),
        MaterialButton(
          onPressed: () {
            AntApi().disconnectDevice();
            context
                .read<AntPlusConnectionStatusCubit>()
                .connectionStatusChanged(false);
          },
          color: Colors.deepOrange,
          child: const Text('Disconnect'),
        ),
      ],
    );
  }

  void _loading() {}
}
