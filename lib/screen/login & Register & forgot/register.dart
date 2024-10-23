import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:orah_pharmacy/screen/login%20&%20Register%20&%20forgot/loginselection.dart';
import 'package:orah_pharmacy/services/api.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:orah_pharmacy/widget/custom_textfield.dart';
import 'package:orah_pharmacy/widget/flushbar.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Register> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpassworscontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String errorText = '';
  bool passwordvisible = false;
  bool loading = false;

  Future register() async {
    var res = await Api.create_customer(
      namecontroller.text,
      emailcontroller.text,
      "+92${phonecontroller.text}",
      passwordcontroller.text,
    );

    if (res['code_status'] == true) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FlushBar.flushbarmessagegreen(
            message: 'Register Successfully, Please Login', context: context);
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginSelection(),
        ),
      );
    } else {
      FlushBar.flushBarMessage(message: res['message'], context: context);
    }

    print(res);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width * 0.04,
              vertical: mq.height * 0.03,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image(
                      height: mq.height * 0.14,
                      image: AssetImage('assets/images/orah-logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.04,
                  ),
                  Text(
                    'Create your Account',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: mq.height * 0.03,
                  ),

                  //Name
                  CustomTextField(
                    controller: namecontroller,
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    maxLines: 1,
                    hintText: 'Name',
                    validate: (value) {
                      if (value!.isEmpty) {
                        return ("Please Enter a Name");
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: mq.height * 0.03),

                  //Email
                  CustomTextField(
                    controller: emailcontroller,
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    maxLines: 1,
                    hintText: 'Email',
                    validate: (value) {
                      final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                      if (value!.isEmpty) {
                        return ("Please Enter a Email");
                      } else if (!emailRegex.hasMatch(value)) {
                        return "Please Enter a Valid Email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: mq.height * 0.03),

                  //phone
                  CustomTextField(
                    controller: phonecontroller,
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Phone Number',
                    maxlength: 10,
                    textInputType: TextInputType.phone,
                    prefix: const Text('+92'),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp('^0')),
                    ],
                    validate: (value) {
                      RegExp regex = new RegExp(r'^.{10,}$');

                      if (value!.isEmpty) {
                        return ("Please Enter a Number");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter Valid Number");
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: mq.height * 0.03),

                  //password
                  CustomTextField(
                    controller: passwordcontroller,
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Password',
                    maxLines: 1,
                    obscureText: !passwordvisible,
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
                      RegExp regex = new RegExp(r'^.{5,}$');
                      if (value!.isEmpty) {
                        return ("Password is required");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter Valid Password(Min. 5 Character)");
                      }
                      if (value.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: mq.height * 0.08),
                  CustomButton(
                      sizeHeight: 65,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          register();
                        }
                      },
                      buttonText: 'Sign Up',
                      sizeWidth: double.infinity),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
