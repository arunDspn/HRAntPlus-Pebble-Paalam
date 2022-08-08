import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ant_plus_connection_status_state.dart';

class AntPlusConnectionStatusCubit extends Cubit<AntPlusConnectionStatusState> {
  AntPlusConnectionStatusCubit()
      : super(AntPlusConnectionStatusNoDeviceConnected());

  void connectionStatusChanged(bool isConnected, {String? deviceName}) {
    if (isConnected) {
      emit(AntPlusConnectionStatusDeviceConnected(deviceName ?? "No name"));
    } else {
      emit(AntPlusConnectionStatusNoDeviceConnected());
    }
  }
}
