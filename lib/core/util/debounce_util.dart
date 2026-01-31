/// Utility class to prevent double-tap/double-click execution
class DebounceUtil {
  static final Map<String, DateTime> _lastExecutionTimes = {};
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  /// Executes the callback only if enough time has passed since the last execution
  /// Returns true if the callback was executed, false if it was debounced
  static bool execute(String key, void Function() callback) {
    final now = DateTime.now();
    final lastExecution = _lastExecutionTimes[key];

    if (lastExecution == null ||
        now.difference(lastExecution) >= _debounceDuration) {
      _lastExecutionTimes[key] = now;
      callback();
      return true;
    }
    return false;
  }

  /// Clears the debounce state for a specific key
  static void clear(String key) {
    _lastExecutionTimes.remove(key);
  }

  /// Clears all debounce states
  static void clearAll() {
    _lastExecutionTimes.clear();
  }
}

/// Extension to create a debounced callback
extension DebounceExtension on void Function() {
  /// Returns a debounced version of this callback
  /// Uses a unique key based on the callback's identity
  void Function() debounced([String? key]) {
    final callbackKey = key ?? hashCode.toString();
    return () => DebounceUtil.execute(callbackKey, this);
  }
}
















