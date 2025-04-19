import 'package:flutter/material.dart';

class ValidationUtils {
  static bool validateLoginInputs(BuildContext context, TextEditingController email, TextEditingController password) {
    if (email.text.isEmpty || password.text.isEmpty) {
      return false; 
    }
    return true;
  }
}