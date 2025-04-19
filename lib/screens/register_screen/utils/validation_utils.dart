import 'package:flutter/material.dart';

class ValidationUtils {
  static bool validateRegisterInputs(BuildContext context, TextEditingController fullname, TextEditingController email, TextEditingController password, TextEditingController retypePassword) {
    if (fullname.text.isEmpty || email.text.isEmpty || password.text.isEmpty || retypePassword.text.isEmpty) {
      return false; 
    }
    return true;
  }
}