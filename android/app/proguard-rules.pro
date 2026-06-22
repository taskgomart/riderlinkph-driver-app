# Flutter + Firebase + Common Packages ProGuard Rules
# RiderLinkPH Driver App

# Flutter framework
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**

# ML Kit (face detection)
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# dart_pusher_channels (Laravel Reverb WebSocket)
-keep class dart_pusher_channels.** { *; }
-keep class io.reactivex.** { *; }
-dontwarn io.reactivex.**

# Keep model classes with fromJson/toJson serialization
# These patterns cover common model naming conventions used in the app
-keep class * extends com.google.gson.annotations.SerializedName
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Data models that use JSON serialization
-keep class ride_sharing_user_app.**.model.** { *; }
-keep class ride_sharing_user_app.**.domain.model.** { *; }

# Google Maps
-keep class com.google.android.gms.maps.** { *; }
-keep class com.google.android.gms.location.** { *; }

# AndroidX
-keep class androidx.** { *; }
-keep interface androidx.** { *; }

# Kotlin serialization (if used)
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-dontnote kotlinx.serialization.SerializationKt

# Prevent R8 from stripping interface information
-keep,allowobfuscation,allowshrinking interface retrofit2.Call
-keep,allowobfuscation,allowshrinking class retrofit2.Response
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation