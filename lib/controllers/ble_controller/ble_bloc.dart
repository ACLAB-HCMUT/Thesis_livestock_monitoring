import 'dart:async';
import 'dart:io';

import 'package:do_an_app/controllers/ble_controller/ble_event.dart';
import 'package:do_an_app/utils/snackbar.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleBloc {
  var eventController = StreamController();

  BluetoothAdapterState bluetoothAdapterState = BluetoothAdapterState.unknown;

  var scanBleDevicesStateStream = FlutterBluePlus.onScanResults;
  final _bleAdapterStateStream = FlutterBluePlus.adapterState;
  var bleAdapterStateStream = StreamController<BluetoothAdapterState>.broadcast();

  BleBloc() {

    _bleAdapterStateStream.listen((state) {
      bleAdapterStateStream.sink.add(state);
    });
    
    eventController.stream.listen((event) async {
      if(event is ScanBleDevicesEvent){
        print("start scan");
        FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 10),
          withNames: ["LIVESTOCK NODE"]
          );
        return;
      }

      if(event is ConfigCowAddressEvent) {
        
      }

      if(event is TurnOnBluetoothEvent) {
        try {
          if (Platform.isAndroid) {
            await FlutterBluePlus.turnOn();
          }
        } catch (e) {
          Snackbar.show(ABC.a, prettyException("Error Turning On:", e), success: false);
        }
      }
    });
  }
}

final bleBloc = BleBloc();