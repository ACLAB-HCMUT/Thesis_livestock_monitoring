import 'package:do_an_app/screens/cow_add_new_screen/widgets/top_snackbar.dart';
import 'package:flutter/material.dart';

class ValidationUtils {
  static bool validateInputs(BuildContext context, TextEditingController nameController, TextEditingController ageController, TextEditingController weightController, String? selectedSafeZoneId) {
    if (nameController.text.isEmpty) {
      showTopSnackBar(context, 'Vui lòng nhập tên con bò.', Colors.red.shade300);
      return false;
    }
    if (ageController.text.isEmpty || int.tryParse(ageController.text) == null) {
      showTopSnackBar(context, 'Vui lòng nhập tuổi hợp lệ.', Colors.red.shade300);
      return false;
    }
    if (weightController.text.isEmpty || int.tryParse(weightController.text) == null) {
      showTopSnackBar(context, 'Vui lòng nhập cân nặng hợp lệ.', Colors.red.shade300);
      return false;
    }
    if (selectedSafeZoneId == null) {
      showTopSnackBar(context, 'Vui lòng chọn vùng an toàn.', Colors.red.shade300);
      return false;
    }
    return true;
  }
}