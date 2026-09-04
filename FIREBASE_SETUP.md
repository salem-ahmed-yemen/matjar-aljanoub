# إعداد Firebase لمتجر الجنوب

1. أنشئ مشروع Firebase.
2. فعّل Authentication > Sign-in method > Email/Password.
3. أنشئ Firestore Database.
4. أنشئ Storage.
5. من بيئة فيها Flutter وFirebase CLI نفّذ: `flutterfire configure`.
6. ثبّت الحزم: `flutter pub get`.
7. انشر القواعد: `firebase deploy --only firestore:rules,storage`.
8. داخل `functions/`: `npm install` ثم `firebase deploy --only functions`.
9. لجعل حساب المشرف إداريًا، عدّل مستند `users/{UID}` واجعل `role` = `admin`.
10. لا تضع مفاتيح Firebase الخاصة بك داخل ملفات عامة أو ترسلها في المحادثة.
