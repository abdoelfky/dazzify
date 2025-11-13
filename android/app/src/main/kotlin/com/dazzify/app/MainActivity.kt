package com.dazzify.app

import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.dazzify.app/tiktok"
    private val TAG = "TikTokChannel"
    private val TIKTOK_APP_ID = "TTUFZa4Lvs1ki2OHnNKwytyRdKXyzwUF"
    private var isInitialized = true // Always true since we're using local logging

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // TikTok SDK removed - not available in public Maven repositories
        // Events are logged locally for debugging purposes
        // For production event tracking, implement server-side TikTok Events API
        Log.d(TAG, "TikTok event tracking initialized (local logging mode) with App ID: $TIKTOK_APP_ID")
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initialize" -> {
                    try {
                        // Local logging mode - always initialized
                        Log.d(TAG, "TikTok event tracking confirmed (local mode): $isInitialized")
                        result.success(isInitialized)
                    } catch (e: Exception) {
                        Log.e(TAG, "Initialization check error: ${e.message}")
                        result.error("INIT_ERROR", e.message, null)
                    }
                }
                "logEvent" -> {
                    try {
                        val eventName = call.argument<String>("eventName")
                        val parameters = call.argument<Map<String, Any>>("parameters")
                        
                        if (eventName != null) {
                            // Log event locally (TikTok SDK not available)
                            logTikTokEvent(eventName, parameters ?: emptyMap())
                            
                            Log.d(TAG, "TikTok Event logged locally: $eventName with parameters: $parameters")
                            result.success(true)
                        } else {
                            result.error("INVALID_ARGUMENT", "Event name is required", null)
                        }
                    } catch (e: Exception) {
                        Log.e(TAG, "Log event error: ${e.message}")
                        result.error("LOG_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
    
    private fun logTikTokEvent(eventName: String, parameters: Map<String, Any>) {
        try {
            // Convert parameters to JSON for logging
            val eventData = JSONObject()
            parameters.forEach { (key, value) ->
                eventData.put(key, value)
            }
            
            // Log event locally - TikTok Open SDK not available in public Maven repositories
            // For production event tracking, implement server-side TikTok Events API
            // https://business-api.tiktok.com/portal/docs?id=1741601162187777
            
            Log.i(TAG, "TikTok Event Data (local logging): $eventName - $eventData")
            
            // RECOMMENDED: Implement server-side TikTok Events API for production
            // Benefits:
            // - More reliable tracking
            // - Better privacy compliance  
            // - No dependency on client SDK availability
            // - Consistent tracking across platforms
            //
            // Implementation:
            // 1. Send events from Flutter app to your backend server
            // 2. Backend forwards events to TikTok Events API with proper authentication
            // 3. Use TikTok Pixel Code and Access Token for authentication
            
        } catch (e: Exception) {
            Log.e(TAG, "Error logging TikTok event: ${e.message}")
        }
    }
}
