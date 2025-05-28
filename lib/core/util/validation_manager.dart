import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ValidationManager {
  static basicValidator(
      {required BuildContext context, required String? label}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return '$label ${context.tr.textIsRequired}';
      } else if (value.length < 8) {
        return '$label ${context.tr.textIsTooShort}';
      }
      return null;
    };
  }

  static String? hasData({
    required String data,
    required String errorMessage,
    int minLength = 5,
  }) {
    if (data.isEmpty || data.length < minLength) {
      return errorMessage;
    }
    return null;
  }

  static emailValidator(BuildContext context) {
    return (value) {
      final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
      if (!emailRegex.hasMatch(value ?? '')) {
        return context.tr.notValidEmail;
      }
      return null;
    };
  }

  static dropDownValidator(
      {required BuildContext context, required String? label}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return '$label ${context.tr.textIsRequired}';
      }
      return null;
    };
  }

  static phoneNumberValidator({required BuildContext context}) {
    final egyptianPhoneNumberRegex = RegExp(r'^(010|011|012|015)\d{8}$');
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return context.tr.phoneNumberIsRequired; // Custom message for empty input
      } else if (!egyptianPhoneNumberRegex.hasMatch(value)) {
        return context.tr.invalidPhoneNumber; // Message for invalid format
      } else {
        return null; // Input is valid
      }
    };
  }


  static changePhoneNumberValidator(
      {required BuildContext context, required String currentNumber}) {
    final phoneNumberRegex = RegExp(r'^01[0-9]{9}$');
    return (value) {
      if (value != currentNumber) {
        if (!phoneNumberRegex.hasMatch(value ?? '')) {
          return context.tr.invalidPhoneNumber;
        } else {
          return null;
        }
      } else {
        return context.tr.newPhoneNumberError;
      }
    };
  }

  static ageValidator({required BuildContext context, required String? label}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return '$label ${context.tr.textIsRequired}';
      }

      try {
        // Force parsing in English locale, strict format
        DateTime birthDate = DateFormat('dd/MM/yyyy', 'en_US').parseStrict(value);
        DateTime currentDate = DateTime.now();

        int age = currentDate.year - birthDate.year;

        if (currentDate.month < birthDate.month ||
            (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
          age--;
        }

        if (age < 14) {
          return context.tr.atLeast14;
        }
        if (age > 120) {
          return context.tr.not120;
        }
      } catch (e) {
        return context.tr.invalidDateFormat;
      }

      return null;
    };
  }

// static ageValidator({required BuildContext context, required String? label}) {
//   return (value) {
//     if (value == null || value.isEmpty) {
//       return '$label ${context.tr.textIsRequired}';
//     }
//     if (int.parse(value) < 14) {
//       return context.tr.atLeast14;
//     }
//     if (int.parse(value) > 120) {
//       return context.tr.not120;
//     }
//     return null;
//   };
// }
}
