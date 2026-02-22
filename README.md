# Flutter WebView Template

A minimal, production-ready Flutter template for building WebView applications. Configure your app by changing three values in a single file.

## Quick Start

Edit `lib/config/app_config.dart`:

```dart
class AppConfig {
  static const String appName = 'My WebView App';
  static const String targetUrl = 'https://flutter.dev';
  static const String appIconPath = 'assets/images/app_icon.png';
}
```

Add your icon to `assets/images/app_icon.png`, then run:

```bash
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── config/
│   └── app_config.dart              # Main configuration
├── core/
│   ├── services/
│   │   └── connectivity_service.dart
│   └── utils/
│       └── url_validator.dart
├── presentation/
│   ├── screens/
│   │   └── webview_screen.dart
│   └── widgets/
│       ├── error_view.dart
│       └── loading_indicator.dart
└── main.dart
```

## Configuration Options

Additional settings in `lib/config/app_config.dart`:

```dart
static const bool enableJavaScript = true;
static const bool enableDomStorage = true;
static const bool enableZoom = true;
static const String userAgent = '';
static const List<String> allowedDomains = [];
static const bool enablePullToRefresh = true;
static const int primaryColorValue = 0xFF2196F3;
```

## Platform Setup

### Android

Change package name in `android/app/build.gradle`:
```gradle
applicationId "com.example.webview_template"
```

Change app name in `android/app/src/main/AndroidManifest.xml`:
```xml
android:label="Your App Name"
```

### iOS

Change bundle identifier in Xcode:
- Open `ios/Runner.xcworkspace`
- Runner → General → Bundle Identifier

Change app name in `ios/Runner/Info.plist`:
```xml
<key>CFBundleDisplayName</key>
<string>Your App Name</string>
```

## Security

- HTTPS enforcement on Android
- Domain whitelisting support
- Configurable JavaScript execution
- File access restrictions
- ProGuard rules for release builds

## App Icons

Use flutter_launcher_icons for automated icon generation:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/app_icon.png"
```

Run: `flutter pub run flutter_launcher_icons`

## Building

Android APK:
```bash
flutter build apk --release
```

Android App Bundle:
```bash
flutter build appbundle --release
```

iOS:
```bash
flutter build ios --release
```

## Dependencies

- webview_flutter - WebView implementation
- connectivity_plus - Network detection
- url_launcher - External URLs
- permission_handler - Runtime permissions

## Troubleshooting

WebView not loading? Check your internet connection and verify the URL is accessible.

Build errors? Run:
```bash
flutter clean
flutter pub get
```

iOS issues? Update CocoaPods:
```bash
cd ios && pod install
```

## License

MIT License - use freely for any purpose.
