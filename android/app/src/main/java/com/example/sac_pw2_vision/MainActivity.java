package com.example.image_text_analyzer_flutter;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;

import java.util.*;
import android.content.ContentResolver;
import android.content.Context;
import android.net.Uri;
import android.provider.MediaStore;
import java.io.IOException;
import android.database.Cursor;
import androidx.core.content.ContextCompat;
import android.content.pm.PackageManager;
import androidx.core.app.ActivityCompat;

import com.google.firebase.ml.vision.FirebaseVision;
import com.google.firebase.ml.vision.objects.FirebaseVisionObjectDetectorOptions;
import com.google.firebase.ml.vision.objects.FirebaseVisionObjectDetector;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.bouncyloop.deeply_music/music";

    private void configureFirebase() {
        FirebaseVisionObjectDetectorOptions options = new FirebaseVisionObjectDetectorOptions.Builder()
                .setDetectorMode(FirebaseVisionObjectDetectorOptions.SINGLE_IMAGE_MODE)
                .enableMultipleObjects()
                .enableClassification()
                .build();

        FirebaseVisionObjectDetector objectDetector = FirebaseVision.getInstance().getOnDeviceObjectDetector(options);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    // Note: this method is invoked on the main thread.
                    if (call.method.equals("getDeviceTracks")) {
                    } else
                        result.notImplemented();
                });
    }
}
