import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hive/hive.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/navbar/navbar.dart';
import 'package:orah_pharmacy/screen/login%20&%20Register%20&%20forgot/forgot_sub/email.dart';
import 'package:orah_pharmacy/screen/login%20&%20Register%20&%20forgot/register.dart';
import 'package:orah_pharmacy/services/api.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:orah_pharmacy/widget/custom_textfield.dart';
import 'package:orah_pharmacy/widget/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Create a Box
  late Box box1;

  @override
  void initState() {
    super.initState();
    createBox();
  }

  createBox() async {
    box1 = await Hive.openBox('logindata');
    getdata();
  }

  getdata() async {
    if (box1.get('email') != null) {
      emailcontroller.text = box1.get('email');
      print('Email Hive ${emailcontroller.text}');
      isChecked = true;
      setState(() {});
    }

    if (box1.get('password') != null) {
      passwordcontroller.text = box1.get('password');
      print('Password Hive ${passwordcontroller.text}');
      isChecked = true;
      setState(() {});
    }
  }

  bool isChecked = false;
  bool passwordvisible = false;
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var loginid;
  var username;
  var email;
  var phone;
  var firstlogin;
  var firstdiscount;
  bool isloading = false;

  Future<void> login() async {
    setState(() {
      isloading = true;
    });
    var res = await Api.login(emailcontroller.text, passwordcontroller.text);
    if (res['code_status'] == true) {
      setState(() {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          FlushBar.flushbarmessagegreen(
              message: 'Login Successfully', context: context);
        });
        loginid = res['response']['result_object'][0]['id'];
        firstdiscount =
            res['response']['result_object'][0]['order_discount'] ?? 200;
        firstlogin = res['first_login'];
        username = res['response']['result_object'][0]['name'];
        email = res['response']['result_object'][0]['email'];
        phone = res['response']['result_object'][0]['phone'];
      });
      setState(() {
        isloading = false;
      });

      print("kkk $loginid");
      print(username);
      print(email);
      print(phone);
      print(firstlogin);
      print(firstdiscount);
      storeid();
      // store data of email and password
      if (isChecked) {
        box1.put('email', emailcontroller.text);
        box1.put('password', passwordcontroller.text);
      } else {
        box1.delete('email');
        box1.delete('password');
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NavBar(),
        ),
      );
    } else {
      setState(() {
        FlushBar.flushBarMessage(
            message: '${res['message']}', context: context);
        setState(() {
          isloading = false;
        });
      });

      print(res['code_status']);
    }
  }

  Future storeid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('login_id', loginid);
    await prefs.setString('name', username);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setInt('discount', firstdiscount);
    await prefs.setString('firstlogin', firstlogin);
  }

  @override
  Widget build(BuildContext context) {
    print('Email Store ${emailcontroller.text}');
    print('Password Store ${passwordcontroller.text}');
    print(firstdiscount);
    var mq = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04,
                vertical: mq.height * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image(
                      height: mq.height * 0.14,
                      image: const AssetImage('assets/images/orah-logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.05,
                  ),
                  Text(
                    'Login to your Account',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: mq.height * 0.05,
                  ),

                  // email
                  Container(
                    height: mq.height * 0.13,
                    // color: Colors.red,
                    child: CustomTextField(
                      controller: emailcontroller,
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: 'Email',
                      validate: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Your Email");
                        }
                        return null;
                      },
                    ),
                  ),

                  // password
                  CustomTextField(
                    controller: passwordcontroller,
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Password',
                    maxLines: 1,
                    obscureText: !passwordvisible,
                    validate: (value) {
                      RegExp regex = new RegExp(r'^.{5,}$');
                      if (value!.isEmpty) {
                        return ("Password is required for login");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter Valid Password(Min. 5 Character)");
                      }
                      if (value.isEmpty) {
                        return '';
                      }
                      return null;
                    },
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
                  ),

                  //Remember me & forgot pasword
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isChecked = !isChecked;
                            // print(checked)
                          });
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              activeColor: MyColor.darkblue,
                              value: isChecked,
                              onChanged: ((value) {
                                setState(() {
                                  isChecked = !isChecked;
                                  print(isChecked);
                                });
                              }),
                            ),
                            Text('Remember me'),
                          ],
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            forgotModalBottomSheet(context);
                          },
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(color: Colors.black),
                          ))
                    ],
                  ),

                  //forgot password
                  SizedBox(
                    height: mq.height * 0.02,
                  ),

                  //button
                  CustomButton(
                      isloading: isloading,
                      sizeHeight: 65,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      buttonText: 'Sign in',
                      sizeWidth: double.infinity),

                  SizedBox(
                    height: mq.height * 0.03,
                  ),

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
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: MyColor.darkblue,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void forgotModalBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        builder: (BuildContext bc) {
          var mq = MediaQuery.of(context).size;
          return Container(
            height: mq.height * 0.4,
            width: mq.width,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: mq.width * 0.04, vertical: mq.height * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Make Selection!",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: mq.height * 0.01),
                  SizedBox(
                    width: mq.width * 0.8,
                    child: Text(
                      "Select on of the options given below to reset your password",
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: mq.height * 0.02),
                  forgotPasswordWidget(
                      icons: FeatherIcons.mail,
                      title: 'E-Mail',
                      subtitle: 'Reset via mail verification',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotEmail()));
                      }),
                  SizedBox(height: mq.height * 0.02),
                  // forgotPasswordWidget(
                  //   icons: FeatherIcons.phone,
                  //   title: 'Phone No',
                  //   subtitle: 'Reset via Phone verification',
                  // ),
                ],
              ),
            ),
          );
        });
  }
}

// ignore: must_be_immutable
class forgotPasswordWidget extends StatelessWidget {
  forgotPasswordWidget({
    this.sizeWidth,
    this.sizeHeight,
    this.color,
    this.radius,
    this.margin,
    this.icons,
    required this.title,
    required this.subtitle,
    this.onTap,
    super.key,
  });

  double? sizeWidth;
  double? sizeHeight;
  Color? color;
  double? radius;
  EdgeInsetsGeometry? margin;
  IconData? icons;
  String title;
  String subtitle;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Container(
      height: mq.height * 0.14,
      width: mq.width,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(radius ?? 10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Icon(icons, size: 60),
              SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(subtitle),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
