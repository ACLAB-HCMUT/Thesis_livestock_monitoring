import 'package:do_an_app/screens/cow_add_new_screen/utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/controllers/user_controller/user_bloc.dart';

class AddCowButton extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController weightController;
  final String? selectedSafeZoneId;
  final bool isMale;

  const AddCowButton({
    required this.nameController,
    required this.ageController,
    required this.weightController,
    required this.selectedSafeZoneId,
    required this.isMale,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (!ValidationUtils.validateInputs(
          context,
          nameController,
          ageController,
          weightController,
          selectedSafeZoneId,
        )) return;

        context.read<CowBloc>().add(CreateCowEvent(
          cow_addr: -1,
          name: nameController.text,
          username: (context.read<UserBloc>().state as UserLoaded).user.username,
          age: int.tryParse(ageController.text),
          weight: int.tryParse(weightController.text),
          isMale: isMale,
          groupId: selectedSafeZoneId,
        ));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[300],
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text("Add cow", style: TextStyle(color: Colors.white)),
    );
  }
}