import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/navbar/navbar.dart';
import 'package:orah_pharmacy/screen/login%20&%20Register%20&%20forgot/register.dart';
import 'package:orah_pharmacy/services/api.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:orah_pharmacy/widget/custom_textfield.dart';
import 'package:orah_pharmacy/widget/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneLogin extends StatefulWidget {
  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  @override
  void initState() {
    fetchCustomersPhones();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    numberController.dispose();
    otpController.dispose();

    super.dispose();
  }

  int _currentStep = 0;
  TextEditingController numberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  List customersPhone = [];
  int? otp_number;
  Map<String, dynamic>? customerData;

  //Customer Phone Number Get
  Future<void> fetchCustomersPhones() async {
    var res = await Api.customersPhone();
    if (res['code_status'] == true) {
      setState(() {
        customersPhone = res['message'];
      });
      print(customersPhone);
    }
  }

  //phonr Number Check
  void checkPhone() async {
    String inputPhone = "92${numberController.text}";

    // Find the customer data and check availability in a single iteration
    var customer = customersPhone.firstWhere(
      (element) => element["phone"] == inputPhone,
      orElse: () => null,
    );

    if (customer != null) {
      print('success');
      customerData = customer;
      await smsApi(inputPhone);
    } else {
      FlushBar.flushBarMessage(
          message: "Number are not Registered", context: context);
    }
  }

  //Send Otp
  Future smsApi(var phoneNumber) async {
    int min = 100000;
    int max = 999999;
    Random random = Random();
    otp_number = min + random.nextInt(max - min);
    print('Random 6-digit number: $otp_number');

    var res = await Api.smsApi(
      phoneNumber,
      "Your Otp Verification Code is $otp_number",
      "ORAH",
    );

    var code = res["response_id"];
    var response = res["response_text"];

    print(code);
    print(response);

    if (code == '0') {
      try {
        SchedulerBinding.instance.addPostFrameCallback(
          (_) {
            FlushBar.flushbarmessagegreen(
                message: 'Otp Send Successfully', context: context);
          },
        );

        setState(() {
          _currentStep < 1 ? _currentStep += 1 : null;
        });
      } catch (e) {
        FlushBar.flushbarmessagegreen(message: '$e', context: context);
        print(e);
      }
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FlushBar.flushBarMessage(
            message: 'There is something wrong', context: context);
      });
    }
  }

  //Save data in shared prefrence
  void saveCustomerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (customerData != null) {
      // Store customer data in shared preferences
      prefs.setString("phone", customerData!["phone"]);
      prefs.setString("email", customerData!["email"]);
      prefs.setString("name", customerData!["name"]);
      prefs.setString("login_id", customerData!["id"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //image
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: mq.height * 0.03,
                ),
                child: Image(
                  height: mq.height * 0.14,
                  image: const AssetImage('assets/images/orah-logo.png'),
                ),
              ),
            ),

            //login text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * 0.04),
              child: Text(
                'Login to your Account',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            //body
            Expanded(
              child: Theme(
                data: ThemeData(
                    fontFamily: 'Comfortaa',
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: MyColor.darkblue,
                        ),
                    canvasColor: Colors.transparent),
                child: Stepper(
                  elevation: 0,
                  type: StepperType.horizontal,
                  currentStep: _currentStep,
                  steps: [
                    //first step
                    Step(
                      title: Text('Number'),
                      content: Form(
                        key: formKey1,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: numberController,
                              filled: true,
                              hintText: ' Enter Number',
                              prefix: Text('92'),
                              maxlength: 10,
                              textInputType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp('^0')),
                              ],
                              validate: (value) {
                                RegExp regex = new RegExp(r'^.{10,}$');

                                if (value!.isEmpty) {
                                  return ("Enter Number");
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("Enter Valid Number");
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      isActive: _currentStep == 0,
                    ),

                    //second step
                    Step(
                      title: Text('OTP'),
                      content: Form(
                        key: formKey2,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: otpController,
                              maxlength: 6,
                              filled: true,
                              hintText: 'Enter OTP',
                              textInputType: TextInputType.number,
                              validate: (value) {
                                RegExp regex = new RegExp(r'^.{6,}$');

                                if (value!.isEmpty) {
                                  return ("Enter OTP");
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("Enter Valid OTP");
                                }
                                return null;
                              },
                            )
                          ],
                        ),
                      ),
                      isActive: _currentStep == 1,
                    ),
                  ],
                  controlsBuilder: (context, details) {
                    return Container();
                  },
                ),
              ),
            ),

            //sign up text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Dont have an account? '),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Register(),
                      ),
                    );
                  },
                  child: Text(
                    'sign up',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: MyColor.darkblue,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),

            //buttons
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04,
                vertical: mq.height * 0.03,
              ),
              child: Row(
                children: [
                  //Next Button
                  CustomButton(
                    onTap: () {
                      print(otp_number);
                      bool isValid = false;

                      if (_currentStep == 0) {
                        isValid = formKey1.currentState?.validate() ?? false;
                        if (isValid) {
                          checkPhone();
                        }
                      } else if (_currentStep == 1) {
                        isValid = formKey2.currentState?.validate() ?? false;
                        if (otpController.text == otp_number.toString()) {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            FlushBar.flushbarmessagegreen(
                                message: 'OTP is verified', context: context);
                          });
                          saveCustomerData();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NavBar(),
                            ),
                          );
                          print('done');
                        } else {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            FlushBar.flushBarMessage(
                                message: 'Invalid OTP', context: context);
                          });
                        }
                      }
                    },
                    buttonText: 'Next',
                    sizeWidth: mq.width * 0.43,
                    sizeHeight: 55,
                  ),
                  SizedBox(width: 16.0),

                  //Back BUtton
                  Container(
                    height: 55,
                    width: mq.width * 0.43,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            _currentStep == 0 ? Colors.grey : MyColor.darkblue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: _currentStep == 0
                          ? null
                          : () {
                              if (_currentStep > 0) {
                                setState(() {
                                  _currentStep -= 1;
                                  otpController.clear();
                                });
                              }
                            },
                      child: Text(
                        'Back',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
