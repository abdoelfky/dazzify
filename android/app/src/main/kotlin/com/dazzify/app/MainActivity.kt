package com.dazzify.app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.tiktok.appevents.TikTokAppEventLogger
import com.tiktok.appevents.contents.TikTokAppEvent
import com.tiktok.appevents.contents.TikTokAppEventProperties
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.dazzify.app/tiktok"
    private var tiktokLogger: TikTokAppEventLogger? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Initialize TikTok App Events SDK
        tiktokLogger = TikTokAppEventLogger.getInstance(context)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initialize" -> {
                    try {
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
                            val properties = TikTokAppEventProperties()
                            parameters?.forEach { (key, value) ->
                                when (value) {
                                    is String -> properties.addProperty(key, value)
                                    is Number -> properties.addProperty(key, value.toDouble())
                                    is Boolean -> properties.addProperty(key, value)
                                }
                            }
                            
                            tiktokLogger?.logEvent(eventName, properties)
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
