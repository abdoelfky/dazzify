import 'package:dazzify/core/util/debounce_util.dart';
import 'package:dazzify/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as localization;

extension BuildContextExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get screenHeight => MediaQuery.sizeOf(this).height;

  S get tr => S.of(this);

  TextDirection get currentTextDirection {
    if (localization.Intl.getCurrentLocale() == 'ar') {
      return TextDirection.rtl;
    } else {
      return TextDirection.ltr;
    }
  }

  bool get isEnglishLanguage => localization.Intl.getCurrentLocale() == 'en';

  bool get hasFocus => FocusScope.of(this).hasPrimaryFocus;

  bool get isKeyboardClosed => MediaQuery.of(this).viewInsets.bottom == 0;

  double get bottomInsets => MediaQuery.of(this).viewInsets.bottom;

  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;
}

/// Extension to easily create debounced callbacks
extension DebounceCallbackExtension on void Function() {
  /// Returns a debounced version of this callback
  /// [key] - Optional unique key for this debounce instance. If not provided, uses callback's hashCode
  void Function() debounced([String? key]) {
    final callbackKey = key ?? hashCode.toString();
    return () => DebounceUtil.execute(callbackKey, this);
  }
}
