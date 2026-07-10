import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'screens/connection_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/rf_tools_screen.dart';
import 'screens/wireless_tools_screen.dart';
import 'screens/attack_tools_screen.dart';
import 'screens/camera_hacker_screen.dart';
import 'screens/camera_viewer_screen.dart';
import 'screens/signal_manager_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/terminal_screen.dart';
import 'services/bluetooth_service.dart';
import 'services/wifi_service.dart';
import 'services/serial_service.dart';
import 'services/esp32_api.dart';
import 'models/connection_type.dart';
import 'models/camera_device.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const CrazyCatApp());
}

class CrazyCatApp extends StatelessWidget {
  const CrazyCatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BluetoothService>(create: (_) => BluetoothService()),
        ChangeNotifierProvider<WiFiService>(create: (_) => WiFiService()),
        ChangeNotifierProvider<SerialService>(create: (_) => SerialService()),
        ChangeNotifierProvider<ESP32API>(create: (_) => ESP32API()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.background,
          primaryColor: AppColors.primary,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.surface,
            error: AppColors.error,
          ),
          textTheme: GoogleFonts.shareTechMonoTextTheme(
            ThemeData.dark().textTheme,
          ).apply(
            bodyColor: AppColors.textPrimary,
            displayColor: AppColors.textPrimary,
          ),
          appBarTheme: AppBarTheme(
            centerTitle: true,
            backgroundColor: AppColors.surface.withOpacity(0.9),
            elevation: 0,
            titleTextStyle: GoogleFonts.shareTechMono(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          cardTheme: CardTheme(
            color: AppColors.surface,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: GoogleFonts.shareTechMono(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            labelStyle: GoogleFonts.shareTechMono(color: AppColors.textSecondary),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/connect': (context) => const ConnectionScreen(),
          '/dashboard': (context) => const DashboardScreen(
            connectionType: AppConnectionType.wifi,
          ),
          '/rf-tools': (context) => const RFToolsScreen(),
          '/wireless-tools': (context) => const WirelessToolsScreen(),
          '/attack-tools': (context) => const AttackToolsScreen(),
          '/camera-hacker': (context) => const CameraHackerScreen(),
          '/camera-viewer': (context) => const CameraViewerScreen(
            camera: CameraDevice(ip: '', streamPath: '', brand: ''),
          ),
          '/signal-manager': (context) => const SignalManagerScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/terminal': (context) => const TerminalScreen(),
        },
      ),
    );
  }
}
