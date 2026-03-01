# حل مشكلة AndroidManifest.xml المفقود

## المشكلة
```
AndroidManifest.xml could not be found.
```

## الحل السريع ⚡

### الطريقة 1: إنشاء ملفات المنصة تلقائياً (الأسهل)

1. افتح Terminal/CMD في مجلد المشروع:
```bash
cd C:\Users\yb\Desktop\auction_app
```

2. نفذ هذا الأمر:
```bash
flutter create .
```

3. اختر "y" عندما يسألك عن الكتابة فوق الملفات الموجودة

4. بعد انتهاء الأمر، نفذ:
```bash
flutter pub get
```

5. الآن جرب تشغيل التطبيق:
```bash
flutter run
```

---

### الطريقة 2: نسخ الملفات المفقودة يدوياً

إذا لم تنجح الطريقة الأولى، قم بما يلي:

#### 1. تحميل ملفات Android الأساسية

قم بتحميل مشروع Flutter جديد:
```bash
cd C:\Users\yb\Desktop
flutter create temp_project
```

#### 2. نسخ مجلد android

```bash
# احذف مجلد android القديم إن وجد
rmdir /s "C:\Users\yb\Desktop\auction_app\android"

# انسخ مجلد android الجديد
xcopy "C:\Users\yb\Desktop\temp_project\android" "C:\Users\yb\Desktop\auction_app\android" /E /I /H

# احذف المشروع المؤقت
rmdir /s "C:\Users\yb\Desktop\temp_project"
```

#### 3. تحديث معلومات التطبيق

افتح الملف:
```
C:\Users\yb\Desktop\auction_app\android\app\build.gradle
```

وتأكد من أن `applicationId` مطابق:
```gradle
defaultConfig {
    applicationId "com.nationalauction.auction_app"
    minSdkVersion 21
    targetSdkVersion flutter.targetSdkVersion
    versionCode 1
    versionName "1.0"
}
```

---

### الطريقة 3: إنشاء مشروع جديد ونقل الكود

إذا لم تنجح الطرق السابقة:

#### 1. إنشاء مشروع جديد
```bash
cd C:\Users\yb\Desktop
flutter create auction_app_new
cd auction_app_new
```

#### 2. نسخ ملفات الكود الخاصة بك

انسخ المجلدات التالية من المشروع القديم إلى الجديد:
- `lib/` (كل الملفات)
- محتويات `pubspec.yaml` (فقط dependencies)

#### 3. تحديث pubspec.yaml

افتح `pubspec.yaml` في المشروع الجديد وأضف:
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  provider: ^6.1.1
  intl: ^0.18.1
```

#### 4. تثبيت الحزم
```bash
flutter pub get
```

#### 5. تشغيل التطبيق
```bash
flutter run
```

---

## التحقق من نجاح الحل ✅

بعد تطبيق أي من الطرق، تحقق من وجود الملفات:

### يجب أن توجد هذه الملفات:
```
auction_app/
├── android/
│   ├── app/
│   │   ├── src/
│   │   │   └── main/
│   │   │       ├── AndroidManifest.xml ✓
│   │   │       ├── kotlin/
│   │   │       │   └── com/nationalauction/auction_app/
│   │   │       │       └── MainActivity.kt ✓
│   │   │       └── res/
│   │   └── build.gradle ✓
│   ├── build.gradle ✓
│   ├── settings.gradle ✓
│   └── gradle.properties ✓
└── lib/
    └── main.dart ✓
```

### اختبار سريع:
```bash
# تحقق من البنية
flutter doctor

# نظف المشروع
flutter clean

# احصل على الحزم
flutter pub get

# شغل التطبيق
flutter run
```

---

## أخطاء شائعة وحلولها

### خطأ: "Gradle sync failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### خطأ: "SDK location not found"
أنشئ ملف `local.properties` في مجلد `android/`:
```properties
sdk.dir=C:\\Users\\YourUsername\\AppData\\Local\\Android\\sdk
flutter.sdk=C:\\src\\flutter
```
(غيّر المسارات حسب موقع SDK لديك)

### خطأ: "Minimum supported Gradle version"
افتح `android/gradle/wrapper/gradle-wrapper.properties`:
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.0-all.zip
```

---

## نصائح مهمة 💡

1. **استخدم Flutter Doctor دائماً**
   ```bash
   flutter doctor -v
   ```
   لمعرفة أي مشاكل في الإعداد

2. **نظف المشروع عند المشاكل**
   ```bash
   flutter clean
   flutter pub get
   ```

3. **تأكد من تحديث Flutter**
   ```bash
   flutter upgrade
   ```

4. **تأكد من وجود Android SDK**
   - افتح Android Studio
   - Tools → SDK Manager
   - تأكد من تثبيت Android SDK Platform 33 أو أعلى

---

## إذا استمرت المشكلة 🆘

إذا جربت كل الحلول ولم تنجح:

1. احذف المشروع بالكامل
2. أعد تحميل الملف المضغوط
3. فك الضغط في مكان جديد
4. نفذ:
   ```bash
   cd path/to/auction_app
   flutter create .
   flutter pub get
   flutter run
   ```

---

تم إعداد هذا الدليل لمساعدتك في حل المشكلة بأسرع وقت! 🚀
