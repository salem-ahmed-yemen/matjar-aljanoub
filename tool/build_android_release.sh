#!/usr/bin/env bash
set -e

echo "Starting Android release build..."

flutter pub get

if [ ! -d "android" ]; then
  flutter create . --platforms=android --project-name matjar_aljanoub --org com.matjaraljanoub
fi

mkdir -p android/app

if [ -n "${GOOGLE_SERVICES_JSON:-}" ]; then
  printf '%s' "$GOOGLE_SERVICES_JSON" > android/app/google-services.json
else
  echo "ERROR: GOOGLE_SERVICES_JSON secret is missing"
  exit 1
fi

# Make the Android package match the Firebase app
find android -type f \( -name "*.kt" -o -name "*.java" -o -name "*.gradle" -o -name "*.kts" -o -name "AndroidManifest.xml" \) \
  -exec sed -i 's/com\.matjaraljanoub\.matjar_aljanoub/com.matjaraljanoub/g' {} +

# Add Google Services plugin to Kotlin Gradle project
if [ -f "android/app/build.gradle.kts" ]; then
  grep -q 'com.google.gms.google-services' android/app/build.gradle.kts || \
    sed -i '/plugins {/a\    id("com.google.gms.google-services")' android/app/build.gradle.kts

  if [ -f "android/settings.gradle.kts" ]; then
    grep -q 'com.google.gms.google-services' android/settings.gradle.kts || \
      sed -i '/plugins {/a\    id("com.google.gms.google-services") version "4.4.4" apply false' android/settings.gradle.kts
  fi
fi

# Add Google Services plugin to Groovy Gradle project
if [ -f "android/app/build.gradle" ]; then
  grep -q 'com.google.gms.google-services' android/app/build.gradle || \
    sed -i "/plugins {/a\    id 'com.google.gms.google-services'" android/app/build.gradle

  if [ -f "android/settings.gradle" ]; then
    grep -q 'com.google.gms.google-services' android/settings.gradle || \
      sed -i "/plugins {/a\    id 'com.google.gms.google-services' version '4.4.4' apply false" android/settings.gradle
  fi
fi

if [ -f "assets/images/matjar_background.jpg" ]; then
  dart run flutter_native_splash:create || true
fi

dart run flutter_launcher_icons || true

flutter build apk --release

echo "APK BUILD COMPLETED"
