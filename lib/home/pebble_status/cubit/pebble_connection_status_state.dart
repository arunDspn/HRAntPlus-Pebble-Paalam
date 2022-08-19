part of 'pebble_connection_status_cubit.dart';

abstract class PebbleConnectionStatusState extends Equatable {
  const PebbleConnectionStatusState();
}

class PebbleConnectionStatusInitial extends PebbleConnectionStatusState {
  @override
  List<Object> get props => [];
}

class PebbleConnectionStatusLoading extends PebbleConnectionStatusState {
  @override
  List<Object> get props => [];
}

class PebbleConnectionStatusConnected extends PebbleConnectionStatusState {
  @override
  List<Object> get props => [];
}

class PebbleConnectionStatusNotConnected extends PebbleConnectionStatusState {
  @override
  List<Object> get props => [];
}
