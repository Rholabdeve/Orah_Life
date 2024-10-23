import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:orah_pharmacy/screen/login%20&%20Register%20&%20forgot/login.dart';
import 'package:orah_pharmacy/services/api.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:orah_pharmacy/widget/custom_textfield.dart';
import 'package:orah_pharmacy/widget/flushbar.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key, required this.email});
  final email;
  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passwordvisible = false;
  bool isloading = false;

  Future UpdatePassword() async {
    setState(() {
      isloading = true;
    });
    var res = await Api.updatePassword(
      widget.email,
      _confirmPasswordController.text,
    );

    if (res['code_status'] == true) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FlushBar.flushbarmessagegreen(
            message: res['message'], context: context);
      });
      setState(() {
        isloading = false;
      });

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ));
    } else {
      FlushBar.flushBarMessage(message: res['message'], context: context);
      setState(() {
        isloading = false;
      });
    }

    print(res);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    print(
      widget.email,
    );
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: mq.width * 0.04,
            vertical: mq.height * 0.03,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "New Password",
                      style: Theme.of(context).textTheme.headlineSmall,
                    )
                  ],
                ),
                SizedBox(height: mq.height * 0.04),
                CustomTextField(
                  controller: _passwordController,
                  filled: true,
                  obscureText: !passwordvisible,
                  hintText: 'Password',
                  maxLines: 1,
                  suffixIcon: IconButton(
                      icon: Icon(
                        passwordvisible
                            ? FeatherIcons.eye
                            : FeatherIcons.eyeOff,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordvisible = !passwordvisible;
                        });
                      }),
                  validate: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter Password");
                    }
                    return null;
                  },
                ),
                SizedBox(height: mq.height * 0.02),
                CustomTextField(
                  filled: true,
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: !passwordvisible,
                  maxLines: 1,
                  suffixIcon: IconButton(
                      icon: Icon(
                        passwordvisible
                            ? FeatherIcons.eye
                            : FeatherIcons.eyeOff,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordvisible = !passwordvisible;
                        });
                      }),
                  validate: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter Confirm Password");
                    }
                    return null;
                  },
                ),
                SizedBox(height: mq.height * 0.03),
                CustomButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isloading = true;
                      });
                      if (_passwordController.text ==
                          _confirmPasswordController.text) {
                        UpdatePassword();
                        print('Passwords match: ${_passwordController.text}');
                      } else {
                        FlushBar.flushBarMessage(
                            message: 'Passwords do not match',
                            context: context);
                        setState(() {
                          isloading = false;
                        });
                      }
                    }
                  },
                  buttonText: 'Confirm',
                  sizeWidth: double.infinity,
                  sizeHeight: 65,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
