import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:lottie/lottie.dart';
import 'package:orah_pharmacy/Database%20Orah/database_orah.dart';
import 'package:orah_pharmacy/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _animationComplete = false;

  DatabaseOrah dbHelper = DatabaseOrah();
  Future<void> checkForUpdate() async {
    print('checking for Update');
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          print('update available');
          update();
        }
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  void update() async {
    print('Updating');
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: LottieBuilder.asset(
          'assets/lottie/loader.json',
          height: 250,
          repeat: false,
          onLoaded: (composition) {
            Future.delayed(
              Duration(seconds: 3),
              () {
                setState(() {
                  _animationComplete = true;
                });

                _navigateToNextScreen();
              },
            );
          },
        ),
      ),
    );
  }

  _navigateToNextScreen() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    if (_animationComplete) {
      if (cartProvider.cartItems.length == 0) {
        dbHelper.deleteAllData();
        print('Splash Screen');
        Navigator.pushReplacementNamed(context, '/index');
      } else {
        print('Error Splash ');
      }
    }
  }
}
