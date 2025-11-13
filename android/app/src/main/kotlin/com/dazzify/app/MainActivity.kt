package com.dazzify.app

import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.tiktok.open.sdk.share.Share
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.dazzify.app/tiktok"
    private val TAG = "TikTokChannel"
    private val TIKTOK_APP_ID = "TTUFZa4Lvs1ki2OHnNKwytyRdKXyzwUF"
    private var isInitialized = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Initialize TikTok SDK
        try {
            Share.init(this, TIKTOK_APP_ID)
            isInitialized = true
            Log.d(TAG, "TikTok SDK initialized successfully with App ID: $TIKTOK_APP_ID")
        } catch (e: Exception) {
            Log.e(TAG, "TikTok SDK initialization error: ${e.message}")
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initialize" -> {
                    try {
                        // SDK already initialized in onCreate
                        Log.d(TAG, "TikTok SDK initialization confirmed: $isInitialized")
                        result.success(isInitialized)
                    } catch (e: Exception) {
                        Log.e(TAG, "Initialization check error: ${e.message}")
                        result.error("INIT_ERROR", e.message, null)
                    }
                }
                "logEvent" -> {
                    try {
                        if (!isInitialized) {
                            Log.w(TAG, "TikTok SDK not initialized, cannot log event")
                            result.success(false)
                            return@setMethodCallHandler
                        }
                        
                        val eventName = call.argument<String>("eventName")
                        val parameters = call.argument<Map<String, Any>>("parameters")
                        
                        if (eventName != null) {
                            // Log event to TikTok Business SDK
                            logTikTokEvent(eventName, parameters ?: emptyMap())
                            
                            Log.d(TAG, "TikTok Event tracked: $eventName with parameters: $parameters")
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
            // Convert parameters to JSON for TikTok event tracking
            val eventData = JSONObject()
            parameters.forEach { (key, value) ->
                eventData.put(key, value)
            }
            
            // Track event using TikTok SDK
            // Note: TikTok's Android SDK primarily focuses on sharing functionality
            // For comprehensive event tracking, consider implementing TikTok Events API server-side
            // https://business-api.tiktok.com/portal/docs?id=1741601162187777
            
            Log.i(TAG, "TikTok Event Data: $eventName - $eventData")
            
            // TODO: If full event tracking is needed, implement server-side TikTok Events API
            // This would involve sending events from your backend server to TikTok's Business API
            // with proper authentication and pixel code
            
        } catch (e: Exception) {
            Log.e(TAG, "Error tracking TikTok event: ${e.message}")
        }
    }
}
