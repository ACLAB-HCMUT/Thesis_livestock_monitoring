class BleEvent {}

class ScanBleDevicesEvent extends BleEvent{}

class ConfigCowAddressEvent extends BleEvent{
  final int cowAddr;
  final String loraServiceUUID = "63bf0b19-2b9c-473c-9e0a-2cfcaf03a780";
  final String cowAddrCharacteristicUUID = "63bf0b19-2b9c-473c-9e0a-2cfcaf03a781";
  ConfigCowAddressEvent({required this.cowAddr});
}

class TurnOnBluetoothEvent extends BleEvent {}