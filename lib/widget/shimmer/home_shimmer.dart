import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/screen/home/orderwithprescription/order_prescription.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:orah_pharmacy/widget/custom_container.dart';
import 'package:shimmer/shimmer.dart';

class Homeshimmer extends StatefulWidget {
  const Homeshimmer({Key? key}) : super(key: key);

  @override
  _HomeshimmerState createState() => _HomeshimmerState();
}

class _HomeshimmerState extends State<Homeshimmer> {
  List categories_image = [
    'assets/images/tempimg/medicine.png',
    'assets/images/tempimg/nutrition.png',
    'assets/images/tempimg/pharmacy.png',
    'assets/images/tempimg/safety_guard.png',
    'assets/images/tempimg/medicine.png',
    'assets/images/tempimg/nutrition.png',
    'assets/images/tempimg/pharmacy.png',
    'assets/images/tempimg/safety_guard.png',
  ];
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 206, 206, 206),
          highlightColor: Color.fromARGB(255, 187, 187, 187),
          enabled: true,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: mq.height * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: mq.width * 0.04,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: mq.height * 0.08,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: mq.height * 0.03),

                  //Image
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mq.width * 0.04),
                    child: Container(
                      width: double.infinity,
                      height: mq.height * 0.3,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage('assets/images/image_home.png'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: mq.height * 0.03),

                  //Upload Prescription
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mq.width * 0.04),
                    child: CustomContainer(
                      sizeHeight: mq.height * 0.12,
                      sizeWidth: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomContainer(
                              sizeWidth: mq.width * 0.14,
                              sizeHeight: mq.height * 0.08,
                              color: MyColor.darkblue,
                              child: const Icon(FeatherIcons.fileText,
                                  color: Colors.white),
                            ),
                            Flexible(
                              child: Text(
                                "Order with Prescriptions",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.w900),
                              ),
                            ),
                            CustomButton(
                                buttontextsize: 13,
                                buttonColor: MyColor.darkblue,
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const OrderPrescription(),
                                    ),
                                  );
                                },
                                buttonText: 'Upload',
                                sizeWidth: mq.width * 0.2)
                          ],
                        ),
                      ),
                    ),
                  ),
                  //End Categories and ListView Section
                  SizedBox(height: mq.height * 0.03),

                  SizedBox(
                    height: mq.height * 0.65,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: mq.width * 0.01,
                        mainAxisSpacing: mq.height * 0.01,
                        childAspectRatio: 18 / 20,
                      ),
                      shrinkWrap: true,
                      itemCount: categories_image.length,
                      physics: const NeverScrollableScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(horizontal: mq.width * 0.04),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomContainer(
                                sizeHeight: mq.height * 0.16,
                                sizeWidth: mq.width * 0.29,
                                child: Padding(
                                  padding: const EdgeInsets.all(0),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
