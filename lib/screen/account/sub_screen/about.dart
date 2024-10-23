import 'package:flutter/material.dart';
import 'package:orah_pharmacy/const/color.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

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
                    'About us',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome to Orah, Pakistan's Most Trusted Pharmacy, where we bring you the convenience of accessing over 10,000 original and temperature-controlled medicines, along with a wide range of personal care products, delivered to your doorstep within just 1 hour. Our retail stores are currently situated in key cities such as Karachi, Don't worry if you're not in these cities; you can still enjoy nationwide delivery by downloading our app and availing instant discounts!",
                          style: TextStyle(
                            fontSize: 13.0,
                          ),
                        ),
                        SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Comfortaa',
                            ),
                            children: [
                              TextSpan(
                                text: 'What\'s New? ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              TextSpan(
                                text:
                                    ' Orah is not just a pharmacy; it\'s your one-stop healthcare app, offering a seamless experience with a selection of 400+ brands of medicines, personal care items, medical appliances, and consumer goods like snacks, juices, and drinks.',
                                style: TextStyle(
                                  height: 1.5,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Comfortaa',
                            ),
                            children: [
                              TextSpan(
                                text: 'Fresh User Interface: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              TextSpan(
                                text:
                                    " We've introduced a completely new and user-friendly interface for an enhanced in-shopping experience.",
                                style: TextStyle(
                                  height: 1.5,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Comfortaa',
                            ),
                            children: [
                              TextSpan(
                                text: 'Improved Performance: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              TextSpan(
                                text:
                                    " Our app now performs even better, ensuring quicker delivery of your online medicines.",
                                style: TextStyle(
                                  height: 1.5,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Comfortaa',
                            ),
                            children: [
                              TextSpan(
                                text: 'Easier Browsing: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              TextSpan(
                                text:
                                    " We've made it simpler for you to browse through products and categories.",
                                style: TextStyle(
                                  height: 1.5,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Comfortaa',
                            ),
                            children: [
                              TextSpan(
                                text: 'Available Products: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "Orah online medicine and healthcare app aim to make online pharmacy shopping in Pakistan easy, fast, and reliable. Our rich inventory covers essential categories such as:",
                                style: TextStyle(
                                  height: 1.5,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        ////
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BulletText("Medicine"),
                            BulletText("Baby & Mother Care"),
                            BulletText("Personal Care"),
                            BulletText("OTC & Health Needs"),
                            BulletText("Foods & Beverages"),
                            BulletText("Nutrition & Supplements"),
                            BulletText("Devices & Appliances"),
                            BulletText("Hygiene & Household"),
                          ],
                        ),
                        SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Comfortaa',
                            ),
                            children: [
                              TextSpan(
                                text: 'How does Orah App work?\n',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              TextSpan(
                                text: "Placing your order is a breeze:",
                                style: TextStyle(
                                  height: 2,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BulletText(
                                "Download the Orah Pharmacy & Wellness app."),
                            SizedBox(
                              height: 8,
                            ),
                            BulletText(
                                "Browse through our extensive product categories."),
                            SizedBox(
                              height: 8,
                            ),
                            BulletText(
                                "Add your selected items to the cart and proceed to checkout."),
                            SizedBox(
                              height: 8,
                            ),
                            BulletText(
                                "Fill in your details and choose your preferred payment method."),
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(
                          'How does Orah App work?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BulletText(
                              "Browse through thousands of products with various brands and prices",
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            BulletText(
                              "Enjoy doorstep delivery within 1 hour.",
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            BulletText(
                              "Choose between online payment or cash on delivery.",
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            BulletText(
                              "Avail discounts on your favorite items.",
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            BulletText(
                              "Upload your prescription to order medicines.",
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Comfortaa',
                            ),
                            children: [
                              TextSpan(
                                text: 'Payment Methods: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "Orah offers easy payment options like cash on delivery and online credit/debit card payments.",
                                style: TextStyle(
                                  height: 1.5,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Comfortaa',
                            ),
                            children: [
                              TextSpan(
                                text:
                                    'Trusted & Authentic Medical Information: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              TextSpan(
                                text:
                                    " As Pakistan's Most Trusted Pharmacy chain, Orah provides you with 10,000+ medicines and consumer products nationwide. We take pride in leading the community pharmacy concept, offering reliable, trusted, and authentic medical content, including side-effects, warnings, and administration details.",
                                style: TextStyle(
                                  height: 1.5,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
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

class BulletText extends StatelessWidget {
  final String text;

  BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('\u2022', style: TextStyle(fontSize: 16.0)), // Bullet point
        SizedBox(width: 8.0), // Add some space between bullet point and text
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              // height: 1.5,
              fontSize: 13.0,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
