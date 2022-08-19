import 'package:ant_pebble_paalam/pebble_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pebble_connection_status_state.dart';

class PebbleConnectionStatusCubit extends Cubit<PebbleConnectionStatusState> {
  PebbleConnectionStatusCubit() : super(PebbleConnectionStatusInitial());

  void requestConnectionStatus() async {
    emit(PebbleConnectionStatusLoading());
    final value = await PebbleApi().pebbleConnectionStatus();
    if (value) {
      emit(PebbleConnectionStatusConnected());
    } else {
      emit(PebbleConnectionStatusNotConnected());
    }
  }

  void setConnectionStatus(bool isConnected) {
    if (isConnected) {
      emit(PebbleConnectionStatusConnected());
    } else {
      emit(PebbleConnectionStatusNotConnected());
    }
  }
}
