import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/services/api.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:orah_pharmacy/widget/custom_textfield.dart';
import 'package:orah_pharmacy/widget/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  @override
  void initState() {
    getdata();
    super.initState();
  }

  var loginid;
  var username;
  var email;
  var phone;
  final _formKey = GlobalKey<FormState>();
  TextEditingController updatename = TextEditingController();
  TextEditingController updatenumber = TextEditingController(text: "+92");
  TextEditingController updateemail = TextEditingController();

  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginid = prefs.getString('login_id');
    username = prefs.getString('name');
    email = prefs.getString('email');
    phone = prefs.getString('phone');
    setState(() {
      updatename.text = username;
      updateemail.text = email;
      updatenumber.text = phone;
    });
  }

  Future updateProfile() async {
    var res = await Api.updateProfile(
      loginid,
      updatename.text,
      updateemail.text,
      updatenumber.text,
    );

    if (res['code_status'] == true) {
      updateData();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FlushBar.flushbarmessagegreen(
            message: res['message'], context: context);
      });

      // Navigator.pop(context);
      //Navigator.of(context).pop(true);
    } else {
      FlushBar.flushBarMessage(message: res['message'], context: context);
    }
  }

  Future<void> updateData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', updatename.text);
    await prefs.setString('email', updateemail.text);
    await prefs.setString('phone', updatenumber.text);
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
                    'Update Profile',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  ),
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
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            filled: true,
                            controller: updatename,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return ("Name Can't be Empty");
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: mq.height * 0.02),
                          CustomTextField(
                            textInputType: TextInputType.phone,
                            filled: true,
                            controller: updatenumber,
                            maxlength: 13,
                            prefix: updatenumber.text.isEmpty
                                ? Text("+92")
                                : Text(""),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp('^0')),
                            ],
                            validate: (value) {
                              RegExp regex = new RegExp(r'^\+92\d{10}$');

                              if (value!.isEmpty) {
                                return ("Number Can't be Empty");
                              }
                              if (!regex.hasMatch(value)) {
                                return ("Enter Valid Number");
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: mq.height * 0.02),
                          CustomTextField(
                            filled: true,
                            controller: updateemail,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return ("Email Can't be Empty");
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: mq.height * 0.04),
                          CustomButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                updateProfile();
                              }
                            },
                            buttonText: 'Update',
                            sizeWidth: double.infinity,
                            sizeHeight: 65,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
