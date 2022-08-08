part of 'ant_plus_connection_status_cubit.dart';

abstract class AntPlusConnectionStatusState extends Equatable {
  const AntPlusConnectionStatusState();
}

class AntPlusConnectionStatusInitial extends AntPlusConnectionStatusState {
  @override
  List<Object> get props => [];
}

class AntPlusConnectionStatusLoading extends AntPlusConnectionStatusState {
  @override
  List<Object> get props => [];
}

class AntPlusConnectionStatusNoDeviceConnected
    extends AntPlusConnectionStatusState {
  @override
  List<Object> get props => [];
}

class AntPlusConnectionStatusDeviceConnected
    extends AntPlusConnectionStatusState {
  final String deviceName;

  const AntPlusConnectionStatusDeviceConnected(this.deviceName);
  @override
  List<Object> get props => [];
}

class AntPlusConnectionStatusError extends AntPlusConnectionStatusState {
  final String cause;

  const AntPlusConnectionStatusError(this.cause);
  @override
  List<Object> get props => [cause];
}
