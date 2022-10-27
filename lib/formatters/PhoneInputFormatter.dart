import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    final offset = text.length + 1;

    return newValue.copyWith(
      text: text.length >= 1 ? '+$text' : '',
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}