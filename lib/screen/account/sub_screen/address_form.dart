import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/helper/database.dart';
import 'package:orah_pharmacy/services/global.dart';
import 'package:orah_pharmacy/services/map_service.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:orah_pharmacy/widget/custom_textfield.dart';
import 'package:orah_pharmacy/widget/flushbar.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({super.key});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  static final formKey = GlobalKey<FormState>();

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
                    'Address Form',
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
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          //address
                          CustomTextField(
                            onTap: () async {
                              await MapService.getLocation(context, () {
                                setState(() {});
                              });
                            },
                            readonly: true,
                            controller: Global.addressController,
                            filled: true,
                            hintText: 'Address',
                            validate: (value) {
                              if (value!.isEmpty) {
                                return ("Please Enter Your Address");
                              }
                              return null;
                            },
                            suffixIcon: Icon(FeatherIcons.mapPin),
                          ),
                          SizedBox(height: mq.height * 0.02),

                          //appartment street unit
                          CustomTextField(
                            controller: apartmentController,
                            filled: true,
                            hintText: 'Apartment, suite, unit, etc',
                            validate: (value) {
                              if (value!.isEmpty) {
                                return ("Please Enter Your Floor, Flat No");
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: mq.height * 0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mq.width * 0.04, vertical: mq.height * 0.03),
                child: CustomButton(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      //
                      bool exists = await dbHelper.doesUserDataExist(
                          Global.addressController.text,
                          apartmentController.text);
                      //
                      if (!exists) {
                        Map<String, dynamic> userData = {
                          'address': Global.addressController.text,
                          'apartment': apartmentController.text,
                          'maplink':
                              "https://www.google.com/maps/?q=${Global.latitude},${Global.longitude}",
                        };
                        await dbHelper.insertUserData(userData);
                        Navigator.pop(context, true);
                      } else {
                        FlushBar.flushBarMessage(
                            context: context, message: 'Data already exists.');
                      }
                    }
                  },
                  buttonText: "Save",
                  sizeWidth: double.infinity,
                  sizeHeight: 60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
