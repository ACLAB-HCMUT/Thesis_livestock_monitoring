import 'package:do_an_app/controllers/user_controller/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_app/controllers/save_zone_controller/bloc/save_zone_bloc.dart';

class SaveZoneDropdown extends StatelessWidget {
  final String? selectedSafeZoneId;
  final Function(String?) onChanged;

  const SaveZoneDropdown({required this.selectedSafeZoneId, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final userState = context.read<UserBloc>().state as UserLoaded;
    return BlocBuilder<SaveZoneBloc, SaveZoneState>(
      builder: (context, state) {
        if (state is SaveZoneLoading) {
          return Text("Loading save zones ... ");
        } else if (state is SaveZoneLoaded) {
          final saveZones = state.safeZones.where((safeZone) => safeZone.username == userState.user.username);
          return DropdownButtonFormField<String>(
            value: selectedSafeZoneId,
            onChanged: onChanged,
            items: saveZones.map<DropdownMenuItem<String>>((zone) {
              return DropdownMenuItem<String>(
                value: zone.groupId,
                child: Container(
                  width: 300,
                  alignment: Alignment.center,
                  child: Text(
                    zone.groupId ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: "Select Safe Zone",
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green.shade300, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
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
        return Text("Error loading save zones ... ");
      },
    );
  }
}