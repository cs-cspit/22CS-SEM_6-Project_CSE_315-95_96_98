import 'package:driver_app/screens/Splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'state_classes/Authentication/auth_state.dart';
import 'state_classes/localization_provider.dart';
import 'screens/sign_in/login_page.dart';
import 'screens/sign_up/signup_page.dart';
import 'screens/Home/home_page.dart';
import 'screens/Splash/splash_page.dart'; // Import SplashScreen
import 'utils/app_colors.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(
            create: (_) => LocalizationProvider()..loadLocale(Locale('en'))),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, localization, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: localization.currentLocale,
          supportedLocales: const [
            Locale('en'),
            Locale('hi'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            primaryColor: AppColors.yellowGreen,
            colorScheme: ColorScheme.light(primary: AppColors.yellowGreen),
          ),
          initialRoute: '/splash',  // Change initial route to splash
          routes: {
            '/splash': (context) => SplashScreen(),
            '/login': (context) => LoginPage(),
            '/signup': (context) => SignupPage(),
            '/home': (context) => HomePage(),
          },
        );
      },
    );
  }
}
