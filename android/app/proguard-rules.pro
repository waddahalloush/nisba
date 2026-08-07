# الحفاظ على مكتبات Firebase Messaging
-keep class com.google.firebase.messaging.** { *; }

# الحفاظ على مكتبة الإشعارات المحلية والـ Plugins الخاصة بها
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class class_containing_background_handler { *; }

# منع تعمية الـ عوازل (Isolates) والـ Entry Points الخاصة بفلاتر
-keepattributes *Annotation*
-keep class * {
    @androidx.annotation.Keep <fields>;
    @androidx.annotation.Keep <methods>;
}