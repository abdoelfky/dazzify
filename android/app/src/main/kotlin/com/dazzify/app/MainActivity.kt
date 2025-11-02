package com.dazzify.app

import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.dazzify.app/tiktok"
    private val TAG = "TikTokChannel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // TikTok SDK is not available - using logging as placeholder
        // Consider implementing TikTok Events API server-side if tracking is needed
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initialize" -> {
                    try {
                        Log.d(TAG, "TikTok SDK initialization called (SDK not available)")
                        // Return success to prevent Flutter side errors
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("INIT_ERROR", e.message, null)
                    }
                }
                "logEvent" -> {
                    try {
                        val eventName = call.argument<String>("eventName")
                        val parameters = call.argument<Map<String, Any>>("parameters")
                        
                        if (eventName != null) {
                            // Log event details for debugging
                            Log.d(TAG, "TikTok Event: $eventName with parameters: $parameters")
                            
                            // TODO: Implement server-side TikTok Events API call here if needed
                            // https://business-api.tiktok.com/portal/docs?id=1741601162187777
                            
                            result.success(true)
                        } else {
                            result.error("INVALID_ARGUMENT", "Event name is required", null)
                        }
                    } catch (e: Exception) {
                        result.error("LOG_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
