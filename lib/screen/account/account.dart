import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/navbar/navbar.dart';
import 'package:orah_pharmacy/screen/account/sub_screen/about.dart';
import 'package:orah_pharmacy/screen/account/sub_screen/address.dart';
import 'package:orah_pharmacy/screen/account/sub_screen/profile.dart';
import 'package:orah_pharmacy/screen/login%20&%20Register%20&%20forgot/loginselection.dart';
import 'package:orah_pharmacy/widget/custom_appbar.dart';
import 'package:orah_pharmacy/widget/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  var id;
  @override
  void initState() {
    getloginid();
    setState(() {});
    super.initState();
  }

  getloginid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('login_id');
    setState(() {});
    print(id);
  }

  removeloginid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('login_id');
    prefs.remove('username');
    prefs.remove('email');
    prefs.remove('phone');
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FlushBar.flushbarmessagegreen(
          message: 'Application is Logout', context: context);
    });
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => NavBar(),
      ),
    );
  }

  login() async {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => const LoginSelection(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColor.darkblue,
        body: Column(
          children: [
            //Appbar
            const Customappbar(),

            //body
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: mq.height * 0.03,
                        horizontal: mq.width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Account Section
                        Text(
                          'Account',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: mq.height * 0.01,
                        ),

                        //Profile List
                        ListTile(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => const Profile(),
                              ),
                            );
                          },
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Profile'),
                          leading: const Icon(FeatherIcons.user),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                        Divider(
                          height: mq.height * 0.06,
                          color: Colors.grey[400],
                        ),

                        //Address Section
                        Text(
                          'Address',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: mq.height * 0.01,
                        ),

                        //Addresses
                        ListTile(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => const AddAddress(),
                              ),
                            );
                          },
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Address'),
                          leading: const Icon(FeatherIcons.mapPin),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                        Divider(
                          height: mq.height * 0.06,
                          color: Colors.grey[400],
                        ),

                        //About Section
                        Text(
                          'About Me',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: mq.height * 0.01),

                        //About Me
                        ListTile(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => const AboutUs(),
                              ),
                            );
                          },
                          contentPadding: EdgeInsets.zero,
                          title: const Text('About App'),
                          leading: const Icon(
                            FeatherIcons.smartphone,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                        Divider(
                          height: mq.height * 0.06,
                          color: Colors.grey[400],
                        ),

                        //Logout Section
                        Text(
                          id == null ? 'Login' : 'Logout',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: mq.height * 0.01),

                        Builder(
                          builder: (BuildContext builderContext) {
                            if (id == null) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(FeatherIcons.logIn),
                                title: const Text('Login'),
                                onTap: () {
                                  login();
                                },
                              );
                            } else {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(FeatherIcons.logOut),
                                title: const Text('Logout'),
                                onTap: () {
                                  removeloginid();
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
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
