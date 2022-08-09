import 'package:ant_pebble_paalam/home/heart_rate_status/cubit/heart_rate_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeartRateView extends StatelessWidget {
  const HeartRateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<HeartRateDataCubit, HeartRateDataState>(
        builder: (context, state) {
          if (state is HeartRateDataNotConnected) {
            return _dataView("!!");
          } else if (state is HeartRateDataConnected) {
            return HeartRateDataView();
          } else {
            return _dataView("ELSE");
          }
        },
      ),
    );
  }
}

Widget _dataView(String data) {
  return Text(
    data,
    style: const TextStyle(
      fontSize: 120,
    ),
  );
}

class HeartRateDataView extends StatefulWidget {
  const HeartRateDataView({Key? key}) : super(key: key);

  @override
  State<HeartRateDataView> createState() => _HeartRateDataViewState();
}

class _HeartRateDataViewState extends State<HeartRateDataView> {
  final EventChannel _heartRateChannel =
      const EventChannel("com.example.ant_pebble_paalam/streamChannel");

  @override
  void initState() {
    super.initState();
    _heartRateData = _heartRateChannel
        .receiveBroadcastStream()
        .map<double>((event) => event);
  }

  Stream<double> _heartRateData = const Stream.empty();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _heartRateData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _dataView("");
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return _dataView(snapshot.data.toString());
          } else {
            return _dataView("NO DATA");
          }
        } else {
          return _dataView("IDK Man");
        }
      },
    );
  }
}
