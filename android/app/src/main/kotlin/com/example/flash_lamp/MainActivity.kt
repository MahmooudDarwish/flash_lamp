package com.example.flash_lamp

import io.flutter.embedding.android.FlutterActivity
import android.hardware.camera2.CameraManager
import android.os.Bundle
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "toggle-flash"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val cameraManager = getSystemService(CAMERA_SERVICE) as CameraManager
        val cameraId = cameraManager.cameraIdList[0]
        var isFlashlightOn = false

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                if (call.method == "toggleFlash") {
                    isFlashlightOn = !isFlashlightOn
                    cameraManager.setTorchMode(cameraId, isFlashlightOn)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}