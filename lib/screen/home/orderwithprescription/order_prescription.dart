import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:orah_pharmacy/widget/custom_container.dart';

class OrderPrescription extends StatefulWidget {
  const OrderPrescription({super.key});

  @override
  State<OrderPrescription> createState() => _OrderPrescriptionState();
}

class _OrderPrescriptionState extends State<OrderPrescription> {
  final _picker = ImagePicker();
  static var length;
  static dynamic imagePath;

  Future showSelectionDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select photo'),
          children: <Widget>[
            SimpleDialogOption(
              child: const Text('From gallery'),
              onPressed: () {
                getImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: const Text('Take a photo'),
              onPressed: () {
                getImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    File? mimage = File(image!.path);

    // ignore: unnecessary_null_comparison
    if (mimage != null) {
      setState(() {
        imagePath = mimage;

        length = imagePath!.length;
      });
    }
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
                  Flexible(
                    child: Text(
                      'Order With prescription',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mq.width * 0.04,
                    vertical: mq.height * 0.03,
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        //Prescription ImageUpload
                        InkWell(
                          onTap: () {
                            showSelectionDialog();
                          },
                          child: CustomContainer(
                            sizeHeight: mq.height * 0.6,
                            sizeWidth: double.infinity,
                            clipBehavior: Clip.antiAlias,
                            child: imagePath != null
                                ? Image.file(imagePath!, fit: BoxFit.cover)
                                : Center(
                                    child: Text(
                                      'Please select an image',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: mq.height * 0.09),

                        //Button
                        CustomButton(
                          onTap: () {},
                          buttonText: 'Submit',
                          sizeHeight: mq.height * 0.1,
                          sizeWidth: double.infinity,
                        ),
                      ],
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
