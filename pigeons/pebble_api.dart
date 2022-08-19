import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class PebbleApi {
  bool pebbleConnectionStatus();
}

@FlutterApi()
abstract class PebbleCallBacks {
  void pebbleConnectionState(bool isConnected);
}
