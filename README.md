# Weather Capstone App 🌦️

A Flutter capstone project built as a separate application to practice clean architecture, bottom navigation, API integration, theming, error handling, testing, app icon, splash screen, and release APK generation.

---

## 📌 Project Overview

This project was created as part of Flutter training.

The main goal of this capstone project is to build a complete and polished Flutter application using real-world concepts such as:

- Clean folder structure
- Bottom navigation
- API integration
- Model classes
- Service layer
- Reusable widgets
- Loading, success, empty, and error states
- Dark mode and custom theme
- Unit testing
- Widget testing
- App icon and splash screen
- Release APK build

---

## 🚀 App Features

### 1. Home Screen
- Shows live weather for Gurgaon
- Displays temperature, weather condition, humidity, and wind speed
- Uses reusable `WeatherCard` widget
- Handles loading and error states

### 2. Search Screen
- Allows user to search weather by city name
- Supports selected cities:
  - Gurgaon
  - Delhi
  - Mumbai
  - Bangalore
  - Kolkata
  - Chennai
- Shows weather card after successful search
- Shows user-friendly error message for invalid city or no internet

### 3. Favorites Screen
- Displays static favorite cities
- Fetches live weather for each favorite city
- Handles loading, error, and success states per city

### 4. About Screen
- Shows app information
- Explains features used in the project
- Uses theme-friendly UI

### 5. Dark Mode Support
- Supports light theme
- Supports dark theme
- Uses system theme mode automatically

### 6. Error UI
- Reusable `ErrorMessage` widget
- Handles no internet connection
- Shows retry option where needed

### 7. Testing
- Unit test for `WeatherModel`
- Widget test for bottom navigation

### 8. App Polish
- App launcher icon setup
- Native splash screen setup
- Release APK build ready

---

## 🛠 Tech Stack

- Flutter
- Dart
- HTTP package
- Flutter Test
- flutter_launcher_icons
- flutter_native_splash
- Open-Meteo Weather API

---

## 📦 Packages Used

```yaml
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  http: ^1.6.0
  flutter_launcher_icons: ^0.14.4
  flutter_native_splash: ^2.4.7

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^6.0.0
```

---

## 📦 Package Installation Commands

```bash
flutter pub add http
flutter pub add flutter_launcher_icons
flutter pub add flutter_native_splash
```

---

## 🌐 API Used

This project uses Open-Meteo API.

Open-Meteo is a free weather API and does not require an API key.

Example API endpoint:

```txt
https://api.open-meteo.com/v1/forecast?latitude=28.4595&longitude=77.0266&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m
```

---

## 📂 Folder Structure

```bash
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── constants/
│   │   └── app_colors.dart
│   └── theme/
│       └── app_theme.dart
│
├── models/
│   └── weather_model.dart
│
├── services/
│   └── weather_service.dart
│
├── screens/
│   ├── main_screen.dart
│   ├── home_screen.dart
│   ├── search_screen.dart
│   ├── favorites_screen.dart
│   └── about_screen.dart
│
└── widgets/
    ├── weather_card.dart
    └── error_message.dart
```

---

## 🧱 Architecture

The project follows a clean and simple architecture:

```txt
UI Screens
   ↓
Reusable Widgets
   ↓
Service Layer
   ↓
API
   ↓
Model Classes
```

### Folder Responsibilities

| Folder | Purpose |
|------|---------|
| core | App colors and theme setup |
| models | Data model classes |
| services | API and business logic |
| screens | App screens |
| widgets | Reusable UI components |

---

---

## ⚙️ pubspec.yaml Important Config

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/icons/

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icons/app_icon.png"
  min_sdk_android: 21

flutter_native_splash:
  color: "#2563EB"
  image: assets/images/splash_logo.png

  android_12:
    color: "#2563EB"
    image: assets/images/splash_logo.png

  android: true
  ios: true
  web: false
```

Important:

`flutter_launcher_icons` and `flutter_native_splash` must be root-level keys.  
They should not be placed inside the `flutter:` section.

---

## 🧪 Testing Commands

Run model test:

```bash
flutter test test/weather_model_test.dart
```

Run widget test:

```bash
flutter test test/widget_test.dart
```

Run all tests:

```bash
flutter test
```

---

## 🚀 Installation

### 1. Clone Repository

```bash
git clone https://github.com/randhir-darveys/weather_capstone_app.git
```

### 2. Move to Project Folder

```bash
cd weather_capstone_app
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run App

```bash
flutter run
```

---

## 📱 Build APK

### Debug APK

```bash
flutter build apk --debug
```

Debug APK path:

```txt
build/app/outputs/flutter-apk/app-debug.apk
```

---

### Release APK

```bash
flutter clean
flutter pub get
flutter build apk --release
```

Release APK path:

```txt
build/app/outputs/flutter-apk/app-release.apk
```

Recommended file name for sharing:

```txt
weather-capstone-app-v2.apk
```

---

## 🔢 Version Update

Before creating a new APK build, update version in `pubspec.yaml`:

```yaml
version: 1.0.1+2
```

Meaning:

```txt
1.0.1 = app version name
+2    = build number / version code
```

---

## 🧠 Concepts Covered

### Flutter Basics
- StatelessWidget
- StatefulWidget
- MaterialApp
- Scaffold
- AppBar
- NavigationBar
- Bottom navigation
- ListView
- TextField
- Reusable widgets

### Architecture
- Clean folder structure
- Models
- Services
- Screens
- Widgets
- Core theme/constants

### API Integration
- HTTP package
- REST API
- GET request
- JSON parsing
- Model mapping
- Service layer

### State Handling
- Loading state
- Success state
- Error state
- Empty state
- Retry action

### Theming
- Light theme
- Dark theme
- System theme mode
- Custom color scheme
- Theme-friendly widgets

### Testing
- Unit testing
- Widget testing
- WidgetTester
- flutter_test package

### Build & Polish
- App launcher icon
- Native splash screen
- pubspec assets setup
- APK release build

---

---

## 🎯 Learning Outcome

After completing this capstone project, I practiced:

✅ Clean Flutter architecture  
✅ API integration  
✅ JSON parsing  
✅ Reusable widgets  
✅ Bottom navigation  
✅ Error handling  
✅ Dark mode  
✅ Unit testing  
✅ Widget testing  
✅ App icon setup  
✅ Splash screen setup  
✅ Release APK generation  

---

## 👨‍💻 Author

**Randhir Kumar**

Flutter Capstone Learning Project 🚀
