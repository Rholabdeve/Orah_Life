import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:orah_pharmacy/screen/login%20&%20Register%20&%20forgot/forgot_sub/new_password.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:orah_pharmacy/widget/custom_textfield.dart';
import 'package:orah_pharmacy/widget/flushbar.dart';

class VerifyOtp extends StatefulWidget {
  VerifyOtp({super.key, this.email, this.Otp});

  final email;
  final Otp;

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  TextEditingController verifyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
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
                    "Verify OTP",
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                ],
              ),
              SizedBox(height: mq.height * 0.04),
              CustomTextField(
                textInputType: TextInputType.phone,
                controller: verifyController,
                filled: true,
                hintText: 'Enter OTP',
                validate: (value) {
                  if (value!.isEmpty) {
                    return ("Please Enter Your OTP");
                  }
                  return null;
                },
              ),
              SizedBox(height: mq.height * 0.03),
              CustomButton(
                isloading: isloading,
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isloading = true;
                    });
                    if (verifyController.text == widget.Otp) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        FlushBar.flushbarmessagegreen(
                            message: 'OTP is verified', context: context);
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewPassword(
                            email: widget.email,
                          ),
                        ),
                      );
                      setState(() {
                        isloading = false;
                      });
                    } else {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        FlushBar.flushBarMessage(
                            message: 'Invalid OTP', context: context);
                        setState(() {
                          isloading = false;
                        });
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
    ));
  }
}
