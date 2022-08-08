import 'package:ant_pebble_paalam/ant_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'connect_ant_device_state.dart';

class ConnectAntDeviceCubit extends Cubit<ConnectAntDeviceState> {
  ConnectAntDeviceCubit() : super(ConnectAntDeviceInitial());

  void connectToDevice(int deviceNumber) {
    // Show non dissemble pop up
    emit(ConnectAntDeviceLoading());
    // Call API
    AntApi().connectToDevice(deviceNumber);
  }

  void connectionResultCallback(bool success) {
    if (success) {
      emit(ConnectAntDeviceSuccess());
    } else {
      emit(ConnectAntDeviceFailed());
    }
    // Previous non dissemble pop up will be dismissed
    // Ask to dismiss result modal
    // Update Ant+ device status
  }
}
