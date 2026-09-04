# متجر الجنوب

تطبيق تجارة إلكترونية عربي متعدد البائعين.

## Build
للبناء السحابي استخدم:
- `.github/workflows/android-release.yml`
- `codemagic.yaml`
- `tool/build_android_release.sh`

يجب توفير `GOOGLE_SERVICES_JSON_BASE64` كـ Secret/Environment Variable للبناء، حتى يعمل Firebase في نسخة Android الحقيقية.
