import 'package:flutter/material.dart';

class ValidationUtils {
  static bool validateInputs(BuildContext context, TextEditingController nameController, TextEditingController ageController, TextEditingController weightController, String? selectedSafeZoneId) {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the cow\'s name.'),
          backgroundColor: Colors.red.shade300,
        ),
      );
      return false;
    }
    if (ageController.text.isEmpty || int.tryParse(ageController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid age.'),
          backgroundColor: Colors.red.shade300,
        ),
      );
      return false;
    }
    if (weightController.text.isEmpty || double.tryParse(weightController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid weight.'),
          backgroundColor: Colors.red.shade300,
        ),
      );
      return false;
    }
    if (selectedSafeZoneId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a safe zone.'),
          backgroundColor: Colors.red.shade300,
        ),
      );
      return false;
    }
    return true;
  }
}