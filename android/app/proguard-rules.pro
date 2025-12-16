# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# Ignore warnings about missing classes (OkHttp3 is optional dependency for ucrop)
-ignorewarnings
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn com.yalantis.ucrop.**

# Keep OkHttp3 classes (required by image_cropper/ucrop)
# These rules prevent R8 from removing OkHttp3 classes if they're present
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-keepclassmembers class okhttp3.** { *; }
-keep,includedescriptorclasses class okhttp3.** { *; }
-keepnames class okhttp3.** { *; }

# Keep Okio classes (required by OkHttp3)
-keep class okio.** { *; }
-keep interface okio.** { *; }
-keepclassmembers class okio.** { *; }
-keep,includedescriptorclasses class okio.** { *; }
-keepnames class okio.** { *; }

# Keep ucrop classes
-keep class com.yalantis.ucrop.** { *; }
-keepclassmembers class com.yalantis.ucrop.** { *; }

# General Flutter rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable implementations
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

