import 'package:dazzify/core/constants/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class SearchHistoryService {
  final Box<dynamic> _settingsDatabase =
      Hive.box(AppConstants.appSettingsDatabase);
  static const String _searchHistoryKey = 'searchHistory';
  static const int _maxHistoryItems = 20;

  /// Get search history list
  List<String> getSearchHistory() {
    try {
      if (_settingsDatabase.containsKey(_searchHistoryKey)) {
        final List<dynamic> history =
            _settingsDatabase.get(_searchHistoryKey) as List<dynamic>;
        return history.cast<String>().toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Add a search term to history
  Future<void> addToHistory(String searchTerm) async {
    if (searchTerm.trim().isEmpty) return;

    try {
      List<String> history = getSearchHistory();

      // Remove if already exists (to move it to top)
      history.remove(searchTerm.trim());

      // Add to the beginning
      history.insert(0, searchTerm.trim());

      // Limit to max items
      if (history.length > _maxHistoryItems) {
        history = history.take(_maxHistoryItems).toList();
      }

      await _settingsDatabase.put(_searchHistoryKey, history);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Clear all search history
  Future<void> clearHistory() async {
    try {
      await _settingsDatabase.delete(_searchHistoryKey);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Remove a specific item from history
  Future<void> removeFromHistory(String searchTerm) async {
    try {
      List<String> history = getSearchHistory();
      history.remove(searchTerm);
      await _settingsDatabase.put(_searchHistoryKey, history);
    } catch (e) {
      // Handle error silently
    }
  }
}

