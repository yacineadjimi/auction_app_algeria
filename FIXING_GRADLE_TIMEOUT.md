# حل مشكلة Gradle Timeout

## المشكلة
```
Timeout of 120000 reached waiting for exclusive access to file gradle-8.0-all.zip
```

## الحلول السريعة

### الحل 1: حذف Gradle Cache (الأسرع) ⚡

#### على Windows:
```cmd
# افتح CMD كـ Administrator
# احذف ملفات Gradle
rmdir /s /q "%USERPROFILE%\.gradle\caches"
rmdir /s /q "%USERPROFILE%\.gradle\wrapper"

# احذف build files في المشروع
cd C:\Users\yb\Desktop\auction_app
rmdir /s /q android\.gradle
rmdir /s /q android\build
rmdir /s /q build

# نظف المشروع
flutter clean

# أعد المحاولة
flutter pub get
flutter run
```

---

### الحل 2: إيقاف عمليات Gradle العالقة

#### الطريقة 1 - من Task Manager:
1. اضغط `Ctrl + Shift + Esc`
2. ابحث عن أي عملية باسم `java.exe` أو `gradle`
3. انقر بالزر الأيمن → End Task
4. أعد تشغيل التطبيق

#### الطريقة 2 - من CMD:
```cmd
# أوقف جميع عمليات Java
taskkill /F /IM java.exe

# ثم جرب مرة أخرى
cd C:\Users\yb\Desktop\auction_app
flutter run
```

---

### الحل 3: تحميل Gradle يدوياً

إذا كان الإنترنت بطيئاً أو متقطعاً:

#### 1. حمّل Gradle مباشرة:
افتح المتصفح وحمّل:
```
https://services.gradle.org/distributions/gradle-8.0-all.zip
```

#### 2. ضع الملف في المكان الصحيح:
```cmd
# أنشئ المجلد إذا لم يكن موجوداً
mkdir "%USERPROFILE%\.gradle\wrapper\dists\gradle-8.0-all\a2o1xoguejy6msdh0lk99lxza"

# انسخ الملف المحمل إلى هذا المجلد
copy "C:\Users\yb\Downloads\gradle-8.0-all.zip" "%USERPROFILE%\.gradle\wrapper\dists\gradle-8.0-all\a2o1xoguejy6msdh0lk99lxza\"
```

#### 3. أعد التشغيل:
```cmd
cd C:\Users\yb\Desktop\auction_app
flutter run
```

---

### الحل 4: تغيير إصدار Gradle

إذا استمرت المشكلة، استخدم إصداراً مختلفاً:

#### 1. افتح الملف:
```
C:\Users\yb\Desktop\auction_app\android\gradle\wrapper\gradle-wrapper.properties
```

#### 2. غيّر السطر:
من:
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.0-all.zip
```

إلى:
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-7.6.3-all.zip
```

#### 3. احفظ وأعد المحاولة:
```cmd
flutter clean
flutter pub get
flutter run
```

---

### الحل 5: استخدام Android Studio

إذا كان لديك Android Studio:

#### 1. افتح المشروع:
```
File → Open → اختر مجلد auction_app/android
```

#### 2. انتظر Gradle Sync
Android Studio سيحمل Gradle تلقائياً

#### 3. بعد انتهاء Sync:
```cmd
cd C:\Users\yb\Desktop\auction_app
flutter run
```

---

### الحل 6: استخدام Gradle Wrapper مباشرة

```cmd
cd C:\Users\yb\Desktop\auction_app\android

# على Windows
gradlew.bat clean

# ثم
cd ..
flutter run
```

---

### الحل 7: تحسين إعدادات Gradle

#### 1. افتح/أنشئ الملف:
```
C:\Users\yb\.gradle\gradle.properties
```

#### 2. أضف هذه الأسطر:
```properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxMetaspaceSize=1024m
org.gradle.parallel=true
org.gradle.caching=true
org.gradle.configureondemand=true
android.useAndroidX=true
android.enableJetifier=true
```

#### 3. احفظ وأعد المحاولة

---

### الحل 8: تعطيل Firewall/Antivirus مؤقتاً

أحياناً يمنع Firewall أو Antivirus تحميل Gradle:

1. عطّل Windows Defender/Antivirus مؤقتاً
2. جرب تشغيل التطبيق
3. إذا نجح، أضف استثناء للمجلدات:
   - `C:\Users\yb\.gradle`
   - `C:\Users\yb\Desktop\auction_app`

---

## حل نهائي: إنشاء مشروع جديد

إذا لم ينجح أي شيء:

```cmd
# احذف المشروع الحالي
cd C:\Users\yb\Desktop
rmdir /s auction_app

# أنشئ مشروع جديد
flutter create auction_app
cd auction_app

# حدّث pubspec.yaml وأضف:
# provider: ^6.1.1
# intl: ^0.18.1

# ثبت الحزم
flutter pub get

# الآن انسخ ملفات lib/ من النسخة الاحتياطية

# شغل التطبيق
flutter run
```

---

## نصائح لتجنب المشكلة مستقبلاً

### 1. استخدم اتصال إنترنت مستقر
Gradle يحتاج تحميل ملفات كبيرة

### 2. نظف المشروع بانتظام
```cmd
flutter clean
```

### 3. احذف cache عند المشاكل
```cmd
flutter pub cache repair
```

### 4. تأكد من وجود مساحة كافية
Gradle يحتاج مساحة على القرص (C:)

### 5. استخدم VPN إذا كان الإنترنت محجوباً
بعض الدول تحجب خوادم Gradle

---

## التحقق من نجاح الحل ✅

بعد تطبيق أي حل، يجب أن ترى:

```
✓ Built build\app\outputs\flutter-apk\app-debug.apk
```

بدون أخطاء Gradle.

---

## إذا استمرت المشكلة 🆘

### الخيار 1: استخدم Emulator بدلاً من الجهاز
```cmd
flutter emulators
flutter emulators --launch <emulator_id>
flutter run
```

### الخيار 2: جرب Flutter Web
```cmd
flutter run -d chrome
```

### الخيار 3: تواصل مع الدعم
أرسل لوج كامل:
```cmd
flutter run -v > log.txt
```
وشارك ملف log.txt

---

## معلومات إضافية

### مواقع ملفات Gradle:
- Cache: `C:\Users\yb\.gradle\caches`
- Wrapper: `C:\Users\yb\.gradle\wrapper`
- Project: `C:\Users\yb\Desktop\auction_app\android\.gradle`

### أوامر مفيدة:
```cmd
# تحقق من إصدار Gradle
cd android
gradlew --version

# تنظيف Gradle
gradlew clean

# إعادة بناء المشروع
gradlew build --refresh-dependencies
```

---

جرب الحلول بالترتيب من 1 إلى 8، وستحل المشكلة إن شاء الله! 🚀
