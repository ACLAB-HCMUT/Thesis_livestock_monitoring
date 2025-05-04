import 'package:do_an_app/controllers/device_controller/device_bloc.dart';
import 'package:do_an_app/controllers/user_controller/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeviceDropdown extends StatelessWidget {
  final String? selectedDeviceId;
  final Function(String?) onChanged;

  const DeviceDropdown({required this.selectedDeviceId, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final userState = context.read<UserBloc>().state as UserLoaded;
    return BlocBuilder<DeviceBloc, DeviceState>(
      builder: (context, state) {
        if (state is DeviceLoading) {
          return const Text("Loading devices ... ");
        } else if (state is DeviceLoaded) {
          final Devices = state.devices.where((device) => device.cow_id == "" && device.username == userState.user.username).toList();
          // print("Devices");
          // print(Devices);
          // for (var device in Devices) {
          //   print("Device name: ${device.device_name}, Device ID: ${device.id}");
          // }

          return DropdownButtonFormField<String>(
            value: selectedDeviceId,
            onChanged: onChanged,
            items: Devices.map<DropdownMenuItem<String>>((device) {
              return DropdownMenuItem<String>(
                value: device.device_name,
                child: Container(
                  width: 300,
                  alignment: Alignment.center,
                  child: Text(
                    device.device_name ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: Devices.length == 0 ? "No devices left" : "Select device",
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green.shade300, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.grey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.green.shade300, width: 2.0),
              ),
            ),
            dropdownColor: Colors.green.shade100,
            icon: Icon(Icons.arrow_drop_down, color: Colors.green.shade300),
            style: TextStyle(color: Colors.black, fontSize: 16),
          );
        }
        return Text("Error loading devices ... ");
      },
    );
  }
}