import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:orah_pharmacy/navbar/navbar.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Lottie.asset(
            'assets/lottie/error.json',
            height: 300,
            width: 300,
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 30),
          child: CustomButton(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NavBar(),
                ),
              );
            },
            buttonText: 'Done',
            sizeWidth: double.infinity,
            sizeHeight: 60,
          ),
        ),
      ),
    );
  }
}
