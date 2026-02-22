/// ============================================
/// CONFIGURATION FILE - CUSTOMIZE YOUR APP HERE
/// ============================================
/// 
/// This is the ONLY file you need to modify to customize your app.
/// Change these three values and you're ready to go!

class AppConfig {
  // 1️⃣ APP NAME - Change this to your app's name
  static const String appName = 'My WebView App';
  
  // 2️⃣ TARGET URL - Change this to the website you want to display
  static const String targetUrl = 'https://flutter.dev';
  
  // 3️⃣ APP ICON PATH - Place your icon in assets/images/ and update the path
  static const String appIconPath = 'assets/images/app_icon.png';
  
  // ============================================
  // ADVANCED SETTINGS (Optional)
  // ============================================
  
  // Enable JavaScript (recommended: true for modern websites)
  static const bool enableJavaScript = true;
  
  // Enable DOM storage (recommended: true for web apps)
  static const bool enableDomStorage = true;
  
  // Allow file access (set to false for better security)
  static const bool allowFileAccess = false;
  
  // Enable zoom controls
  static const bool enableZoom = true;
  
  // User agent (leave empty for default)
  static const String userAgent = '';
  
  // Show loading indicator
  static const bool showLoadingIndicator = true;
  
  // Primary color for the app theme
  static const int primaryColorValue = 0xFF2196F3;
  
  // Allowed domains for navigation (empty = allow all)
  // Example: ['flutter.dev', 'dart.dev']
  static const List<String> allowedDomains = [];
  
  // Enable pull-to-refresh
  static const bool enablePullToRefresh = true;
  
  // Cache mode: 'default', 'cache_else_network', 'no_cache', 'cache_only'
  static const String cacheMode = 'default';
}
