import 'package:flutter/material.dart';

class PebbleConnectionStatus extends StatelessWidget {
  const PebbleConnectionStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(8.0),
      child: _connected(),
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