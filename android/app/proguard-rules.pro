# Paymob SDK keep rules to prevent R8 from stripping classes
-keep class com.paymob.** { *; }
-keep interface com.paymob.** { *; }
-dontwarn com.paymob.**

# Keep networking and serialization classes commonly used by Paymob
-keepattributes Signature, *Annotation*, InnerClasses, EnclosingMethod
-dontwarn okhttp3.**
-keep class okhttp3.** { *; }
-dontwarn okio.**
-keep class okio.** { *; }
