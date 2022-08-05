import 'package:pigeon/pigeon.dart';

class Device{
  final String deviceName;

  Device(this.deviceName);
}
@HostApi()
abstract class AntApi{
  List<Device> searchDevices();
}