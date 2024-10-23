import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/firebase_options.dart';
import 'package:orah_pharmacy/notification.dart';
import 'package:orah_pharmacy/provider/cart_provider.dart';
import 'package:orah_pharmacy/screen/account/sub_screen/profile.dart';
import 'package:orah_pharmacy/screen/splash/splash.dart';
import 'package:provider/provider.dart';
import 'navbar/navbar.dart';
import 'screen/home/home.dart';
import 'screen/login & Register & forgot/login.dart';
import 'screen/login & Register & forgot/register.dart';

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await firebaseNotification().initNotification();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: MyColor.darkblue,
          statusBarIconBrightness: Brightness.light),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Comfortaa',
        textTheme: const TextTheme(
          headlineSmall: TextStyle(color: Colors.black),
          headlineMedium: TextStyle(color: Colors.black),
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
          bodySmall: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black),
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/index': (context) => NavBar(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/home': (context) => Home(),
        '/profile': (context) => Profile(),
      },
      //home: LoginSelection(),
    );
  }
}
