// Пример реализации метода на стороне Android
// Файл android/app/src/main/kotlin/com/example/camera_app/MainActivity.kt

package com.example.camera_app

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.IOException

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.camera_app/mediastore"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveImage" -> {
                    val imagePath = call.argument<String>("imagePath")
                    if (imagePath != null) {
                        try {
                            val isSaved = saveImageToGallery(imagePath)
                            if (isSaved) {
                                result.success("success")
                            } else {
                                result.success("error")
                            }
                        } catch (e: Exception) {
                            result.error("SAVE_ERROR", "Не удалось сохранить изображение: ${e.message}", null)
                        }
                    } else {
                        result.error("INVALID_PATH", "Путь к изображению не указан", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun saveImageToGallery(imagePath: String): Boolean {
        val file = File(imagePath)
        if (!file.exists()) {
            return false
        }

        try {
            val contentValues = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, file.name)
                put(MediaStore.MediaColumns.MIME_TYPE, "image/jpeg")
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_PICTURES)
                    put(MediaStore.MediaColumns.IS_PENDING, 1)
                }
            }

            val uri = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)
            if (uri != null) {
                contentResolver.openOutputStream(uri)?.use { outputStream ->
                    FileInputStream(file).use { inputStream ->
                        inputStream.copyTo(outputStream)
                    }
                }

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    contentValues.clear()
                    contentValues.put(MediaStore.MediaColumns.IS_PENDING, 0)
                    contentResolver.update(uri, contentValues, null, null)
                }
                return true
            }
            return false
        } catch (e: IOException) {
            e.printStackTrace()
            return false
        }
    }
}