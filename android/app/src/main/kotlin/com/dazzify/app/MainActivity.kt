package com.dazzify.app

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.os.Build
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
    private var audioManager: AudioManager? = null
    private var audioFocusRequest: AudioFocusRequest? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // TikTok SDK removed - not available in public Maven repositories
        // Events are logged locally for debugging purposes
        // For production event tracking, implement server-side TikTok Events API
        Log.d(TAG, "TikTok event tracking initialized (local logging mode) with App ID: $TIKTOK_APP_ID")
        
        // Configure audio focus for proper playback when launching from TikTok ads
        configureAudioFocus()
    }
    
    private fun configureAudioFocus() {
        try {
            audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                // For Android O and above
                val audioAttributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_MEDIA)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MOVIE)
                    .build()
                
                audioFocusRequest = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN)
                    .setAudioAttributes(audioAttributes)
                    .setAcceptsDelayedFocusGain(true)
                    .setOnAudioFocusChangeListener { focusChange ->
                        Log.d(TAG, "Audio focus changed: $focusChange")
                    }
                    .build()
                
                audioManager?.requestAudioFocus(audioFocusRequest!!)
            } else {
                // For older Android versions
                @Suppress("DEPRECATION")
                audioManager?.requestAudioFocus(
                    { focusChange -> Log.d(TAG, "Audio focus changed: $focusChange") },
                    AudioManager.STREAM_MUSIC,
                    AudioManager.AUDIOFOCUS_GAIN
                )
            }
            
            Log.d(TAG, "Audio focus configured successfully for TikTok ad launches")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to configure audio focus: ${e.message}")
        }
    }
    
    override fun onResume() {
        super.onResume()
        // Reconfigure audio focus when app resumes (e.g., returning from TikTok)
        configureAudioFocus()
    }
    
    override fun onDestroy() {
        super.onDestroy()
        // Release audio focus when activity is destroyed
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            audioFocusRequest?.let { audioManager?.abandonAudioFocusRequest(it) }
        } else {
            @Suppress("DEPRECATION")
            audioManager?.abandonAudioFocus { }
        }
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
