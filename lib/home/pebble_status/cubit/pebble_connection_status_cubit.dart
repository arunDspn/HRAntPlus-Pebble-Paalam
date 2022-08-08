import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pebble_connection_status_state.dart';

class PebbleConnectionStatusCubit extends Cubit<PebbleConnectionStatusState> {
  PebbleConnectionStatusCubit() : super(PebbleConnectionStatusInitial());
}
