import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:do_an_app/screens/bluetooth_scan_screen.dart';

Future<void> handleBluetooth(BuildContext context) async {
  BluetoothAdapterState currentState = await FlutterBluePlus.adapterState.first;

  if (currentState == BluetoothAdapterState.on) {
    // If Bluetooth is already on, navigate to the scan screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BluetoothScanScreen()),
    );
  } else {
    // If Bluetooth is off, show the dialog to prompt the user
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Bạn có muốn bật Bluetooth',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "IndieFlower",
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Xác nhận"),
              onPressed: () async {
                try {
                  if (Platform.isAndroid) {
                    // Turn on Bluetooth
                    await FlutterBluePlus.turnOn();
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  // Handle errors if Bluetooth cannot be turned on
                  print("Error Turning On Bluetooth: $e");
                }
              },
            ),
            TextButton(
              child: const Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}