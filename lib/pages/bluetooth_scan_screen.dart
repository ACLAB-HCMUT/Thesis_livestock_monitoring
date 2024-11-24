// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:do_an_app/controllers/ble_controller/ble_bloc.dart';
import 'package:do_an_app/controllers/ble_controller/ble_event.dart';
import 'package:do_an_app/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScanScreen extends StatefulWidget {
  @override
  _BluetoothScanScreenState createState() => _BluetoothScanScreenState();
}



class _BluetoothScanScreenState extends State<BluetoothScanScreen> {
  List<ScanResult> scanResults = [];
  
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;
  BluetoothAdapterState _blueState = BluetoothAdapterState.unknown;

  @override
  void initState() {
    super.initState();
    FlutterBluePlus.isScanning.listen((isScanning) {
      if(mounted){
        setState(() {});
      }
    });

    startScan();
    _adapterStateStateSubscription = bleBloc.bleAdapterStateStream.stream.listen((blueState) {
      _blueState = blueState;
      
      if(_blueState == BluetoothAdapterState.off){
        Navigator.pop(context);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                  'Bluetooth đã tắt',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "IndieFlower",
                    fontWeight: FontWeight.bold,
                  )),
              actions: [
                TextButton(
                  child: Text("Bật lại"),
                  onPressed: () {
                    bleBloc.eventController.add(TurnOnBluetoothEvent());
                    //call event to turn on Bluetooth
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Thoát"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
          );
        }
    });
  }

  @override
  void dispose() {  
    super.dispose();
    // _subscription?.cancel();
    _adapterStateStateSubscription.cancel();
  }

  void startScan() async {
      // _subscription?.cancel();
      FlutterBluePlus.stopScan();
      scanResults.clear();

      FlutterBluePlus.startScan(
        timeout: Duration(seconds: 10),
        withNames: ["LIVESTOCK NODE"]
      );

      // Nghe kết quả quét
      FlutterBluePlus.onScanResults.listen((result) {
        if(mounted) {
          setState(() {
            scanResults = result;
          });
        }
      }); 
  }

  void stopScan(){
    try {
      FlutterBluePlus.stopScan();
      setState((){});
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("Stop Scan Error:", e), success: false);
    }
  }
  Widget buildScanButton(BuildContext context) {
    if (FlutterBluePlus.isScanningNow) {
      return FloatingActionButton(
        child: const Icon(Icons.stop),
        onPressed: stopScan,
        backgroundColor: Colors.red,
      );
    } else {
      return FloatingActionButton(
        child: const Icon(Icons.play_arrow), 
        backgroundColor: Colors.green,
        onPressed: startScan
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Scanner"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              startScan();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: scanResults.length,
        itemBuilder: (context, index) {
          final result = scanResults[index];
          final device = result.device;

          return ListTile(
            title: Text(device.platformName.isNotEmpty ? device.platformName : "Unknown Device"),
            subtitle: Text(device.remoteId.toString()),
            trailing: IconButton(
              onPressed: result.advertisementData.connectable ? () async {
                  await device.connect();
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                            'Bạn có muốn cấu hình thiết bị này cho vật nuôi',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "IndieFlower",
                              fontWeight: FontWeight.bold,
                            )),
                        actions: [
                          TextButton(
                            child: Text("Xác nhận"),
                            onPressed: () async {
                              bool write_result = true;
                              /* Call serivce to get global address of cow */

                              int global_addr = 40000;
                              /* Find service write cow addr */
                              List<BluetoothService> services = await device.discoverServices();
                              for(final service in services){
                                if(service.serviceUuid.toString() != "63bf0b19-2b9c-473c-9e0a-2cfcaf03a770"){
                                  continue;
                                }
                                List<BluetoothCharacteristic> characteristics = service.characteristics;
                                for(final characteristic in characteristics){
                                  if(characteristic.characteristicUuid.toString() != "63bf0b19-2b9c-473c-9e0a-2cfcaf03a771"){
                                    continue;
                                  }
                                  global_addr = (global_addr + 1) % (0xffff);
                                  try {
                                    await characteristic.write([global_addr & 0xff, (global_addr >> 8) & 0xff]);
                                  }catch(e) {
                                    print('Write failed: $e');
                                    write_result = false;
                                  }
                                } 
                              }
                              /* Call service to config address */

                              await device.disconnect();
                              Navigator.of(context).pop();
                              if(write_result == false) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                          title: Text(
                                        "Không thể gán địa chỉ cho thiết bị",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "IndieFlower",
                                        ),
                                      )));
                              }
                            },
                          ),
                          TextButton(
                            child: Text("Hủy"),
                            onPressed: () async {
                              await device.disconnect();
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                  // List<BluetoothService> services = await device.discoverServices();
                  // for(final service in services){
                  //   if(service.serviceUuid.toString() != "63bf0b19-2b9c-473c-9e0a-2cfcaf03a770"){
                  //     continue;
                  //   }
                  //   List<BluetoothCharacteristic> characteristics = service.characteristics;
                  //   for(final characteristic in characteristics){
                  //     if(characteristic.characteristicUuid.toString() != "63bf0b19-2b9c-473c-9e0a-2cfcaf03a771"){
                  //       continue;
                  //     }
                  //     List<int> values = await characteristic.read();
                  //     int cowAddr = values[0] | values[1] << 8;
                  //     print("begin: $cowAddr");

                  //     cowAddr = (cowAddr + 1) % (0xffff);
                  //     await characteristic.write([cowAddr & 0xff, (cowAddr >> 8) & 0xff]);
                      
                  //     values = await characteristic.read();
                  //     cowAddr = values[0] | values[1] << 8;
                  //     print("after: $cowAddr");
                  //   }
                    
                  // }
                  // await device.disconnect();
                }
                : (){
                  print("not allow");
                },
              icon: Icon(
                result.advertisementData.connectable ? Icons.link : Icons.link_off,
                color: result.advertisementData.connectable ? Colors.green : Colors.red,
              )
            ),
          );
        },
      ),
      floatingActionButton: buildScanButton(context),
    );
  }
}
