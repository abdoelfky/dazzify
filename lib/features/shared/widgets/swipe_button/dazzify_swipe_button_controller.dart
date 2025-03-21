import 'package:flutter/cupertino.dart';

class DazzifySwipeButtonController extends ChangeNotifier {
  double _value = 0;
  bool _hasExecutedOnSwipe = false; // New flag for tracking execution

  double get value => _value;

  bool get hasExecutedOnSwipe => _hasExecutedOnSwipe;

  set value(double newValue) {
    if (newValue >= 0 && newValue <= 1) {
      _value = newValue;
      notifyListeners();
    }
  }

  void resetSwipeState() {
    _value = 0;
    _hasExecutedOnSwipe = false;
    notifyListeners();
  }

  bool markAsExecuted() {
    if (!_hasExecutedOnSwipe && _value >= 0.9) {
      _hasExecutedOnSwipe = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool get didSwipe => _value == 1;
}
