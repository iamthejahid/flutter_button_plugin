package com.example.flutter_hardware_buttons

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.view.KeyEvent
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterHardwareButtonsPlugin */
class FlutterHardwareButtonsPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var eventChannel: EventChannel
  private var context: Context? = null
  private var eventSink: EventChannel.EventSink? = null

  private val volumeButtonReceiver = VolumeButtonReceiver()

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_hardware_buttons")
    channel.setMethodCallHandler(this)

    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_hardware_buttons/events")
    eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        context?.registerReceiver(volumeButtonReceiver, IntentFilter("android.media.VOLUME_CHANGED_ACTION"))
      }

      override fun onCancel(arguments: Any?) {
        context?.unregisterReceiver(volumeButtonReceiver)
        eventSink = null
      }
    })

    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "startListeningForHardwareButtons" -> {
        // Start listening for hardware button events
        context?.registerReceiver(volumeButtonReceiver, IntentFilter("android.media.VOLUME_CHANGED_ACTION"))
        result.success(null)
      }
      "stopListeningForHardwareButtons" -> {
        // Stop listening for hardware button events
        context?.unregisterReceiver(volumeButtonReceiver)
        result.success(null)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
    context?.unregisterReceiver(volumeButtonReceiver)
    context = null
  }
}

class VolumeButtonReceiver : BroadcastReceiver() {
    var pressCount = 0

    override fun onReceive(context: Context?, intent: Intent?) {
        val action = intent?.action
        if (action == "android.media.VOLUME_CHANGED_ACTION") {
            val keyCode = intent?.getIntExtra("android.media.EXTRA_VOLUME_STREAM_VALUE", -1)
            if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) {
                pressCount++
                if (pressCount == 3) {
                    // Start the app
                    val launchIntent = context?.packageManager?.getLaunchIntentForPackage(context.packageName)
                    launchIntent?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    context?.startActivity(launchIntent)
                    pressCount = 0
                }
            }
        }
    }
}