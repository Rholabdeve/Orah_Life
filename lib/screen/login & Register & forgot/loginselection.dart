import 'package:flutter/material.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/screen/login%20&%20Register%20&%20forgot/login.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';

class LoginSelection extends StatelessWidget {
  const LoginSelection({super.key});

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          Image.asset(
            "assets/images/medicine_background.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04,
                vertical: mq.height * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 12,
                    child: Text(
                      "Select SignIn \nOption!",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.bold, color: MyColor.darkblue),
                    ),
                  ),
                  CustomButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    buttonText: 'Email',
                    // sizeWidth: mq.width * 0.83,
                    sizeWidth: double.maxFinite,
                    sizeHeight: 55,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
