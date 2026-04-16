import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'config/app_config.dart';
import 'presentation/screens/webview_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations (wrapped in try-catch for platform compatibility)
  try {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } catch (e) {
    // Silently fail if platform doesn't support orientation changes
  }
  
  // Set system UI overlay style (wrapped in try-catch for platform compatibility)
  try {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  } catch (e) {
    // Silently fail if platform doesn't support system UI customization
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(
          AppConfig.primaryColorValue,
          _generateMaterialColorShades(AppConfig.primaryColorValue),
        ),
        useMaterial3: true,
      ),
      home: const WebViewScreen(),
    );
  }
  
  Map<int, Color> _generateMaterialColorShades(int colorValue) {
    final color = Color(colorValue);
    final hslColor = HSLColor.fromColor(color);
    
    return {
      50: hslColor.withLightness(0.95).toColor(),
      100: hslColor.withLightness(0.90).toColor(),
      200: hslColor.withLightness(0.80).toColor(),
      300: hslColor.withLightness(0.70).toColor(),
      400: hslColor.withLightness(0.60).toColor(),
      500: color,
      600: hslColor.withLightness(0.45).toColor(),
      700: hslColor.withLightness(0.35).toColor(),
      800: hslColor.withLightness(0.25).toColor(),
      900: hslColor.withLightness(0.15).toColor(),
    };
  }
}
