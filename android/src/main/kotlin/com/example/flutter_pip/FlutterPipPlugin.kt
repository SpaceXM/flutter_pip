package com.example.my_pip_package

import androidx.annotation.NonNull
import android.app.Activity
import android.app.PictureInPictureParams
import android.os.Build
import android.util.Rational

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class MyPipPackagePlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel : MethodChannel
  private var activity: Activity? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "my_pip_package")
    channel.setMethodCallHandler(this)
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
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
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
}