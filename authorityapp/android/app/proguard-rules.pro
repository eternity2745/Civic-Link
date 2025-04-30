# Flutter wrapper classes
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# Preserve annotations
-keepattributes *Annotation*

# Firebase (if used)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

-keep class com.google.android.play.core.splitcompat.** { *; }
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication

# Prevent stripping reflection-used classes
-keepclassmembers class * {
    public <init>(...);
}

# Keep entry points for Flutter plugins
-keep class io.flutter.plugins.** { *; }
