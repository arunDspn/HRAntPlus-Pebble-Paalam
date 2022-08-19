import 'package:ant_pebble_paalam/home/pebble_status/cubit/pebble_connection_status_cubit.dart';
import 'package:ant_pebble_paalam/home/pebble_status/cubit/pebble_connection_status_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PebbleConnectionStatus extends StatelessWidget {
  const PebbleConnectionStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(8.0),
      child:
          BlocBuilder<PebbleConnectionStatusCubit, PebbleConnectionStatusState>(
        builder: (context, state) {
          if (state is PebbleConnectionStatusNotConnected) {
            return _notConnected();
          } else if (state is PebbleConnectionStatusConnected) {
            return _connected();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget _notConnected() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text("Pebble isn't Connected"),
        Icon(
          Icons.highlight_off_outlined,
          color: Colors.red,
        )
      ],
    );
  }

  Widget _connected() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text("Pebble Connected"),
        Icon(
          Icons.check_circle,
          color: Colors.green,
        )
      ],
    );
  }
}
