import 'package:pigeon/pigeon.dart';

class DeviceInfo {
  final String deviceName;
  final int deviceNumber;

  DeviceInfo(this.deviceName, this.deviceNumber);
}

@HostApi()
abstract class AntApi {
  void searchDevices();
  void connectToDevice(int deviceNumber);
  // Stream<int> subscribeToHeartRateData();
}

@FlutterApi()
abstract class AntCallBacks {
  void devicesFound(List<DeviceInfo> devices);
}
