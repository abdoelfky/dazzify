import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Manages preloading of video controllers for smooth playback transitions
class VideoPreloader {
  final Map<String, VideoPlayerController> _controllers = {};
  final int maxPreloadCount;
  
  VideoPreloader({this.maxPreloadCount = 2});
  
  /// Preload a video controller for a given URL
  Future<void> preloadVideo(String url) async {
    if (_controllers.containsKey(url)) {
      return; // Already preloaded
    }
    
    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: false,
          mixWithOthers: false,
        ),
      );
      
      _controllers[url] = controller;
      await controller.initialize();
      debugPrint('✅ Preloaded video: $url');
    } catch (e) {
      debugPrint('❌ Failed to preload video: $url - Error: $e');
      _controllers.remove(url);
    }
  }
  
  /// Get a preloaded controller or create a new one
  VideoPlayerController? getController(String url) {
    return _controllers[url];
  }
  
  /// Check if a video is already preloaded
  bool isPreloaded(String url) {
    return _controllers.containsKey(url) && 
           _controllers[url]?.value.isInitialized == true;
  }
  
  /// Remove and dispose controllers that are no longer needed
  void disposeController(String url) {
    final controller = _controllers.remove(url);
    if (controller != null) {
      controller.dispose();
      debugPrint('🗑️ Disposed video controller: $url');
    }
  }
  
  /// Dispose all controllers
  void disposeAll() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    debugPrint('🗑️ Disposed all video controllers');
  }
  
  /// Get count of preloaded videos
  int get preloadedCount => _controllers.length;
}
