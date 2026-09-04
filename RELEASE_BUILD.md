# متجر الجنوب — Cloud Release Build

هذه الحزمة مجهزة للبناء السحابي لإخراج:

`build/app/outputs/flutter-apk/app-release.apk`

## الهوية
- اسم التطبيق: **متجر الجنوب**
- اسم الحزمة: `com.matjaraljanoub.matjar_aljanoub`
- أيقونة التطبيق: `assets/icon/app_icon.png`
- شاشة البداية: `assets/images/matjar_background.jpg`

## أهم خطوة قبل البناء
لأن التطبيق يستخدم Firebase، يجب أن يملك البناء السحابي ملف Android الخاص بمشروع Firebase:

`android/app/google-services.json`

**لا تضع الملف داخل المستودع العام ولا ترسل كلمات مرور أو مفاتيح سرية في المحادثة.**

### GitHub Actions
1. أنشئ مستودعًا خاصًا وارفع ملفات هذه الحزمة.
2. من إعدادات المستودع أضف Secret باسم:
   `GOOGLE_SERVICES_JSON_BASE64`
3. قيمة الـ Secret هي محتوى `google-services.json` بعد تحويله إلى Base64.
4. شغّل workflow باسم **متجر الجنوب - Android Release**.
5. بعد انتهاء البناء ستجد APK ضمن Artifacts باسم `matjar-aljanoub-release-apk`.

### Codemagic
أضف متغير بيئة محمي باسم:
`GOOGLE_SERVICES_JSON_BASE64`
ثم شغّل workflow `android-release`.

## ملاحظة مهمة
هذا إعداد **Release للبناء السحابي** وليس ملف APK مبنيًا داخل هذه البيئة؛ بيئة المحادثة لا تحتوي Flutter/Android SDK. كذلك لا يمكن تفعيل Firebase الحقيقي دون إعداد مشروع Firebase الخاص بك.
