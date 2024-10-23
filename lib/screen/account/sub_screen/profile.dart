import 'package:flutter/material.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/screen/account/sub_screen/update_profile.dart';
import 'package:orah_pharmacy/screen/login%20&%20Register%20&%20forgot/login.dart';
import 'package:orah_pharmacy/widget/custom_Container.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var loginid;
  var username;
  var email;
  var phone;

  @override
  void initState() {
    getdata();
    super.initState();
  }

  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loginid = prefs.getString('login_id');
      username = prefs.getString('name');
      email = prefs.getString('email');
      phone = prefs.getString('phone');
    });
    print(loginid);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColor.darkblue,
        body: Column(
          children: [
            //App Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04,
                vertical: mq.height * 0.03,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'Profile',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  ),
                  Spacer(),
                  CustomButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateProfile(),
                        ),
                      );
                    },
                    buttonText: 'Update Profile',
                    sizeWidth: 140,
                    sizeHeight: 40,
                    boderRadius: 30,
                    buttontextsize: 14,
                    borderColor: Colors.white,
                    textColor: Colors.white,
                  )
                ],
              ),
            ),

            //body
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: mq.height * 0.02,
                    horizontal: mq.width * 0.04,
                  ),
                  child: loginid == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Please Login\n if you want to see your profile',
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: mq.height * 0.02),
                            CustomButton(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    ),
                                  );
                                },
                                buttonText: 'Login',
                                sizeWidth: mq.width * 0.35)
                          ],
                        )
                      : Column(
                          children: [
                            //name
                            CustomContainer(
                              sizeHeight: 50,
                              // sizeHeight: mq.height * 0.09,
                              sizeWidth: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                child: Text(
                                  username ?? 'demo',
                                ),
                              ),
                            ),
                            SizedBox(height: mq.height * 0.02),

                            //email
                            CustomContainer(
                              sizeHeight: 50,
                              sizeWidth: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                child: Text(
                                  email ?? 'demo',
                                ),
                              ),
                            ),
                            SizedBox(height: mq.height * 0.02),

                            //Phone
                            CustomContainer(
                              sizeHeight: 50,
                              sizeWidth: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                child: Text(
                                  phone,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
