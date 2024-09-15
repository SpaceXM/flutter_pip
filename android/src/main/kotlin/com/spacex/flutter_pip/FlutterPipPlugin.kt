package com.spacex.flutter_pip

import androidx.annotation.NonNull
import android.app.Activity
import android.app.PictureInPictureParams
import android.os.Build
import android.util.Rational
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel

class FlutterPipPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel : MethodChannel
  private lateinit var eventChannel: EventChannel
  private var activity: Activity? = null
  private var pipReceiver: BroadcastReceiver? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_pip")
    channel.setMethodCallHandler(this)
    
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_pip_events")
    eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        registerPipReceiver(events)
      }

      override fun onCancel(arguments: Any?) {
        unregisterPipReceiver()
      }
    })
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "isPipSupported" -> {
        result.success(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
      }
      "enterPipMode" -> {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
          val aspectRatioNumerator = call.argument<Int>("aspectRatioNumerator") ?: 16
          val aspectRatioDenominator = call.argument<Int>("aspectRatioDenominator") ?: 9
          enterPipMode(aspectRatioNumerator, aspectRatioDenominator)
          result.success(null)
        } else {
          result.error("UNAVAILABLE", "PiP not available on this device.", null)
        }
      }
      "isPipActive" -> {
        result.success(activity?.isInPictureInPictureMode ?: false)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    unregisterPipReceiver()
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  private fun enterPipMode(aspectRatioNumerator: Int, aspectRatioDenominator: Int) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      val params = PictureInPictureParams.Builder()
        .setAspectRatio(Rational(aspectRatioNumerator, aspectRatioDenominator))
        .build()
      activity?.enterPictureInPictureMode(params)
    }
  }

  private fun registerPipReceiver(events: EventChannel.EventSink?) {
    pipReceiver = object : BroadcastReceiver() {
      override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == Intent.ACTION_PICTURE_IN_PICTURE_MODE_CHANGED) {
          val isInPipMode = activity?.isInPictureInPictureMode ?: false
          events?.success(isInPipMode)
        }
      }
    }
    activity?.registerReceiver(pipReceiver, IntentFilter(Intent.ACTION_PICTURE_IN_PICTURE_MODE_CHANGED))
  }

  private fun unregisterPipReceiver() {
    pipReceiver?.let { activity?.unregisterReceiver(it) }
    pipReceiver = null
  }
}