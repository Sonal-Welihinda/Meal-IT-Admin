import 'package:flutter/services.dart';


class PhoneNumberFormatter_SL extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final sanitizedText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    var newText = '';
    var selectionIndex = newValue.selection.end;

    if (sanitizedText.startsWith('0')) {
      // Format for 0## ### ####
      if (sanitizedText.length <= 3) {
        newText = sanitizedText;
      } else if (sanitizedText.length <= 5) {
        newText = '0${sanitizedText.substring(0, 3)} ${sanitizedText.substring(3)}';
      } else if (sanitizedText.length <= 8) {
        newText = '0${sanitizedText.substring(0, 3)} ${sanitizedText.substring(3, 6)} ${sanitizedText.substring(6)}';
      } else {
        newText = '0${sanitizedText.substring(0, 3)} ${sanitizedText.substring(3, 6)} ${sanitizedText.substring(6, 10)}';
      }
    } else if (sanitizedText.startsWith('94')) {
      // Format for +94 ## ### ####
      if (sanitizedText.length <= 4) {
        newText = '+94 ${sanitizedText.substring(2)}';
      } else if (sanitizedText.length <= 6) {
        newText = '+94 ${sanitizedText.substring(2, 4)} ${sanitizedText.substring(4)}';
      } else if (sanitizedText.length <= 9) {
        newText = '+94 ${sanitizedText.substring(2, 4)} ${sanitizedText.substring(4, 7)} ${sanitizedText.substring(7)}';
      } else {
        newText = '+94 ${sanitizedText.substring(2, 4)} ${sanitizedText.substring(4, 7)} ${sanitizedText.substring(7, 11)}';
      }
    } else {
      // Invalid phone number format
      newText = sanitizedText;
    }

    selectionIndex += newText.length - sanitizedText.length;

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
