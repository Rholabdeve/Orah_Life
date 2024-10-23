import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:orah_pharmacy/Database%20Orah/database_orah.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/helper/database.dart';
import 'package:orah_pharmacy/navbar/navbar.dart';
import 'package:orah_pharmacy/provider/cart_provider.dart';
import 'package:orah_pharmacy/screen/account/sub_screen/address_form.dart';
import 'package:orah_pharmacy/screen/error.dart';
import 'package:orah_pharmacy/services/api.dart';
import 'package:orah_pharmacy/services/global.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:orah_pharmacy/widget/custom_container.dart';
import 'package:orah_pharmacy/widget/custom_textfield.dart';
import 'package:orah_pharmacy/widget/flushbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:math';

import 'package:webview_flutter/webview_flutter.dart';

class ShippingDetail extends StatefulWidget {
  final String price;
  final String? firstlogin;
  final dynamic offerdicount;
  final List<CartItem> cartItems;

  const ShippingDetail(
      {required this.price,
      required this.cartItems,
      super.key,
      this.firstlogin,
      this.offerdicount});
  @override
  _ShippingDetailState createState() => _ShippingDetailState();
}

class _ShippingDetailState extends State<ShippingDetail>
    with SingleTickerProviderStateMixin {
  int? randomSixDigitNumber;
  // String selectedOption = 'COD';
  String? selectedOption = 'N/A';
  // String selectedOption1 = 'POS';
  String? selectedOption1;
  String pickupOption = 'SEMR';
  String address = '';
  String receivedData = '';
  var result;
  var loginId;
  var username;
  var lat;
  var long;

  String autocompletePlace = "null";
  Prediction? initialValue;

  late TabController _tabController;
  // ignore: unused_field
  final _placeBidFormKey = GlobalKey<FormState>();
  // ignore: unused_field
  final _buyNowFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController townController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  static final shippingformKey = GlobalKey<FormState>();
  static final pickupformKey = GlobalKey<FormState>();
  final DatabaseHelper dbHelper = DatabaseHelper();
  late List<Map<String, dynamic>> addedCartItems;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  String? formattedDate;
  late bool hasRedirected = false;

  int? selectedIndex;
  String? selectedData;

  String? selectedAddress;
  String? mapLink;
  int deliveryCharge = 0;
  int? grandTotal;
  dynamic offertotal;
  bool isloading = false;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    getdata();
    super.initState();
    print("Ubaid khan ${widget.firstlogin}");
    print("Ubaid khan${widget.offerdicount}");
  }

  Future setDeliveryCharges(var address) async {
    var res = await Api.DeliveryChargesSet(
      '${widget.price}',
      '$address',
      'orah',
    );

    if (res['code_status'] == 200) {
      setState(() {
        print('Address API: $address');
        print('Response Delivery Chareges $res');
        deliveryCharge = res['delivery_charges'];
      });

      // print('Delivery Charge $deliveryCharge');
    } else {
      FlushBar.flushBarMessage(message: 'Something is Wrong', context: context);
    }
  }

  void _handleTabSelection() {
    if (_tabController.index == 1) {
      setState(() {
        deliveryCharge = 0;
        selectedAddress = null;
        selectedData = null;
      });
      print(deliveryCharge);
    }
    print("Selected Tab Index: ${_tabController.index}");
  }

  @override
  void dispose() {
    _tabController.dispose();
    nameController.dispose();
    streetController.dispose();
    apartmentController.dispose();
    emailController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loginId = prefs.getString('login_id');
      nameController.text = prefs.getString('name')!;
      emailController.text = prefs.getString('email')!;
      phoneController.text = prefs.getString('phone')!;
    });
  }

  Future createOrder() async {
    var res = await Api.addOrder1(
      'OrahApp_$randomSixDigitNumber',
      loginId,
      '3589',
      jsonEncode(addedCartItems),
      '${selectedOption == null ? '' : selectedOption},${selectedOption1 == null ? '' : selectedOption1},${_tabController.index == 0 ? 'Delivery' : 'Pickup'}',
      '$deliveryCharge',
    );

    if (res['code_status'] == true) {
      showMyDialog();
      updateAddress();
      //generatePDFAndSendEmail('orah.pk@gmail.com');
      generatePDFAndSendEmail(emailController.text);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove("firstlogin");
      // generatePDFAndSendEmail('wajihshamim2000@gmail.com');
      //generatePDFAndSendEmail('saadrahim.201@gmail.com');
    } else {
      FlushBar.flushBarMessage(message: 'Something is Wrong', context: context);
    }
    dbhelper.deleteAllData();
  }

  Future<void> updateAddress() async {
    // ignore: unused_local_variable
    var res = await Api.updateAddress(
      loginId,
      "${selectedData}",
      "${mapLink}",
      // "${Global.addressController.text}${appartmentcontroller.text}",
      // "https://www.google.com/maps/?q=${Global.latitude},${Global.longitude}",
    );
  }

  void openMap() async {
    String mapUrl =
        'https://www.google.com/maps/search/?api=1&query=24.88180,67.06080';

    if (await canLaunch(mapUrl)) {
      await launch(mapUrl);
    } else {
      throw 'Could not launch $mapUrl';
    }
  }

  String _dataToString(Map<String, dynamic> data) {
    // Convert the map to a string representation as needed
    return "${data['address']},${data['apartment']}";
  }

  void updateSelectedData(int index, String? data) {
    setState(() {
      selectedIndex = index;
      selectedData = data;
    });
  }

  DatabaseOrah dbhelper = DatabaseOrah();
  @override
  Widget build(BuildContext context) {
    print('Selected Option $selectedOption');
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
                      'Billing Detail',
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

            //TabBar
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
                  padding: EdgeInsets.only(
                      left: mq.width * 0.04,
                      right: mq.width * 0.04,
                      top: mq.height * 0.02),
                  child: Column(
                    children: [
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(
                            25.0,
                          ),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              25.0,
                            ),
                            color: MyColor.darkblue,
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: [
                            Tab(
                              text: 'Delivery',
                            ),
                            Tab(
                              text: 'Self Pick Up',
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: [
                            // First tab bar view widget (Place Bid)
                            _delivery(),

                            // Second tab bar view widget (Buy Now)
                            _selfpickup(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _delivery() {
    var mq = MediaQuery.of(context).size;
    addedCartItems = Provider.of<CartProvider>(context, listen: false)
        .getAddedCartItemsWithQuantity();
    formattedDate = formatter.format(now);
    int price = int.parse(widget.price);
    grandTotal = price + deliveryCharge;

    offertotal = price + deliveryCharge - widget.offerdicount;

    print(mapLink);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                key: shippingformKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Select Address
                    GestureDetector(
                      onTap: () {
                        _bottomsheet();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[100],
                        ),
                        child: Text(selectedData ?? "Select Address"),
                      ),
                    ),

                    SizedBox(height: mq.height * 0.02),

                    //Name & last Name
                    CustomTextField(
                      onTap: () {
                        FlushBar.flushBarMessage(
                            message: 'Update data on Profile Section',
                            context: context);
                      },
                      readonly: true,
                      controller: nameController,
                      filled: true,
                      hintText: 'First Name',
                      validate: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Your Name");
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: mq.height * 0.02),

                    //Number
                    CustomTextField(
                      onTap: () {
                        FlushBar.flushBarMessage(
                            message: 'Update data on Profile Section',
                            context: context);
                      },
                      readonly: true,
                      controller: phoneController,
                      filled: true,
                      hintText: 'Phone',
                      textInputType: TextInputType.phone,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Your Number");
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: mq.height * 0.02),

                    //Email
                    CustomTextField(
                      onTap: () {
                        FlushBar.flushBarMessage(
                            message: 'Update data on Profile Section',
                            context: context);
                      },
                      readonly: true,
                      controller: emailController,
                      filled: true,
                      hintText: 'Email',
                      validate: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Your Email");
                        }
                        return null;
                      },
                    ),
                    Divider(
                      height: mq.height * 0.06,
                      color: MyColor.darkblue,
                    ),

                    //Patment Option
                    Text(
                      'Payment Method',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),

                    //COD
                    RadioListTile(
                      activeColor: MyColor.darkblue,
                      contentPadding: EdgeInsets.all(0),
                      title: Text('Cash on delivery'),
                      value: 'COD',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value!.toString();
                        });
                      },
                    ),

                    //Pay online
                    RadioListTile(
                      activeColor: MyColor.darkblue,
                      contentPadding: EdgeInsets.all(0),
                      title: Text('Online Pay'),
                      value: 'OnlinePay',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value!.toString();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //subtotol
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SubTotal',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.grey),
                      ),
                      Text(
                        "${widget.price}",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )
                    ],
                  ),

                  //delivery fee
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery Fee',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.grey),
                      ),
                      deliveryCharge == 0
                          ? Text(
                              "Free",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            )
                          : Text(
                              "${deliveryCharge}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            )
                    ],
                  ),
                  widget.firstlogin == "yes" && price >= 1000
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'First Signup Discount',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.grey),
                            ),
                            Text(
                              '${widget.offerdicount}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            )
                          ],
                        )
                      : SizedBox(),
                  Divider(height: mq.height * 0.03),

                  //total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.grey),
                      ),
                      widget.firstlogin == "yes" && price >= 1000
                          ? Text(
                              "${offertotal}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            )
                          : Text(
                              "${grandTotal}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            )
                    ],
                  ),
                  SizedBox(height: mq.height * 0.01),

                  //button
                  CustomButton(
                    onTap: () async {
                      if (shippingformKey.currentState!.validate()) {
                        Random random = Random();
                        int min = 100000;
                        int max = 999999;
                        randomSixDigitNumber =
                            min + random.nextInt(max - min + 1);
                        if (selectedOption == 'COD') {
                          if (selectedData != null) {
                            createOrder();
                          } else {
                            FlushBar.flushBarMessage(
                                message: 'Please Select Address',
                                context: context);
                          }
                        } else if (selectedOption == 'OnlinePay') {
                          if (selectedData != null) {
                            makePayment();
                          } else {
                            FlushBar.flushBarMessage(
                                message: 'Please Select Address',
                                context: context);
                          }
                        } else if (selectedData == null) {
                          FlushBar.flushBarMessage(
                              message: 'Please Select Address',
                              context: context);
                        } else {
                          FlushBar.flushBarMessage(
                              message: 'Please Select Payment Method',
                              context: context);
                        }
                      }
                    },
                    buttonText: 'Pay',
                    sizeWidth: double.infinity,
                    sizeHeight: 65,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selfpickup() {
    var selfsubtotal = double.parse(widget.price);
    addedCartItems = Provider.of<CartProvider>(context, listen: false)
        .getAddedCartItemsWithQuantity();
    formattedDate = formatter.format(now);
    var mq = MediaQuery.of(context).size;
    print(grandTotal);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Form(
              key: pickupformKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Name & last Name
                          CustomTextField(
                            onTap: () {
                              FlushBar.flushBarMessage(
                                  message: 'Update data on Profile Section',
                                  context: context);
                            },
                            readonly: true,
                            controller: nameController,
                            filled: true,
                            hintText: 'First Name',
                            validate: (value) {
                              if (value!.isEmpty) {
                                return ("Please Enter Your Name");
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: mq.height * 0.02),

                          //Number
                          CustomTextField(
                            onTap: () {
                              FlushBar.flushBarMessage(
                                  message: 'Update data on Profile Section',
                                  context: context);
                            },
                            readonly: true,
                            controller: phoneController,
                            filled: true,
                            hintText: 'Phone',
                            textInputType: TextInputType.phone,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return ("Please Enter Your Number");
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: mq.height * 0.02),

                          //Email
                          CustomTextField(
                            onTap: () {
                              FlushBar.flushBarMessage(
                                  message: 'Update data on Profile Section',
                                  context: context);
                            },
                            readonly: true,
                            controller: emailController,
                            filled: true,
                            hintText: 'Email',
                            validate: (value) {
                              if (value!.isEmpty) {
                                return ("Please Enter Your Email");
                              }
                              return null;
                            },
                          ),
                          Divider(
                            height: mq.height * 0.06,
                            color: MyColor.darkblue,
                          ),

                          //Pickup from option
                          Text(
                            'Pick Up From',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),

                          //Shaheed-e-Millat Rd
                          RadioListTile(
                            visualDensity: VisualDensity.compact,
                            activeColor: MyColor.darkblue,
                            contentPadding: EdgeInsets.all(0),
                            title: Text('Bahadurabad Branch'),
                            value: 'SEMR',
                            groupValue: pickupOption,
                            onChanged: (value) {
                              setState(() {
                                pickupOption = value!.toString();
                              });
                            },
                          ),

                          GestureDetector(
                            onTap: () {
                              openMap();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 3.0,
                                      spreadRadius: 2.0,
                                      offset: Offset(
                                        4.0,
                                        4.0,
                                      ),
                                    )
                                  ]),
                              padding: EdgeInsets.all(10),
                              child: Text(
                                  "Ground Floor, Family Heaven, S#4 Shaheed-e-Millat Rd, Jinnah Society Jinnah CHS PECHS, Karachi, Sindh 75400",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(height: mq.height * 0.03),

                          //Patment Option
                          Text(
                            'Payment Method',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),

                          //pay on shop
                          RadioListTile(
                            activeColor: MyColor.darkblue,
                            contentPadding: EdgeInsets.all(0),
                            title: Text('Pay at Shop'),
                            value: 'Pay at shop',
                            groupValue: selectedOption1,
                            onChanged: (value) {
                              setState(() {
                                selectedOption1 = value!.toString();
                              });
                            },
                          ),

                          //Pay online
                          RadioListTile(
                            activeColor: MyColor.darkblue,
                            contentPadding: EdgeInsets.all(0),
                            title: Text('Online Pay'),
                            value: 'Online Paid',
                            groupValue: selectedOption1,
                            onChanged: (value) {
                              setState(() {
                                selectedOption1 = value!.toString();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // //Total
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     SizedBox(
          //       height: mq.height * 0.02,
          //     ),
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           'Total',
          //           style: Theme.of(context).textTheme.headlineSmall,
          //         ),
          //         Text("${widget.price}",
          //             style: Theme.of(context).textTheme.titleLarge!.copyWith(
          //                 fontWeight: FontWeight.bold, color: Colors.black))
          //       ],
          //     ),
          //     SizedBox(
          //       height: mq.height * 0.02,
          //     ),
          //     CustomButton(
          //       onTap: () {
          //         if (pickupformKey.currentState!.validate()) {
          //           Random random = Random();
          //           int min = 100000;
          //           int max = 999999;
          //           randomSixDigitNumber = min + random.nextInt(max - min + 1);
          //           if (selectedOption1 == 'Pay at shop') {
          //             createOrder();
          //           } else if (selectedOption1 == 'Online Paid') {
          //             makePayment();
          //           } else {
          //             FlushBar.flushbarmessagered(
          //                 message: 'Please Select Payment Option',
          //                 context: context);
          //           }
          //         }
          //       },
          //       buttonText: 'Pay',
          //       sizeWidth: double.infinity,
          //       sizeHeight: 65,
          //     )
          //   ],
          // ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            padding: EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SubTotal',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.grey),
                      ),
                      Text(
                        "${selfsubtotal.toStringAsFixed(0)}",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Self Pickup Charges',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.grey),
                      ),
                      Text(
                        "0",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                  widget.firstlogin == "yes" &&
                          double.parse(widget.price) >= 1000
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'First Signup Discount',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.grey),
                            ),
                            Text(
                              '${widget.offerdicount}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            )
                          ],
                        )
                      : SizedBox(),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.grey),
                      ),
                      widget.firstlogin == "yes" &&
                              double.parse(widget.price) >= 1000
                          ? Text(
                              "${offertotal}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            )
                          : Text(
                              "${widget.price}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            )
                    ],
                  ),
                  SizedBox(
                    height: mq.height * 0.02,
                  ),
                  CustomButton(
                    onTap: () {
                      if (pickupformKey.currentState!.validate()) {
                        Random random = Random();
                        int min = 100000;
                        int max = 999999;
                        randomSixDigitNumber =
                            min + random.nextInt(max - min + 1);
                        if (selectedOption1 == 'Pay at shop') {
                          createOrder();
                        } else if (selectedOption1 == 'Online Paid') {
                          makePayment();
                        } else {
                          FlushBar.flushBarMessage(
                              message: 'Please Select Payment Option',
                              context: context);
                        }
                      }
                    },
                    buttonText: 'Pay',
                    sizeWidth: double.infinity,
                    sizeHeight: 65,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // //Meezan Bank Payment Api
  Future<void> makePayment() async {
    print("aaaaaaaaaaabbbbbbbbbbbbbbb ${double.parse(widget.price)}");

    print("xsknsxnsxsnxsxsskxn ${grandTotal}");
    int amount;
    widget.firstlogin == "yes" && double.parse(widget.price) >= 1000
        ? amount = offertotal * 100
        : amount = grandTotal! * 100;

    print("nkskskskskkxkx $amount");

    String currency = "586";

    //String returnUrl = "https://distrho.com/orah/index.html";
    String returnUrl = 'https://www.orah.pk/checkout-complete-mobile';

    String operation = "register.do";

    String gatewayUrl =
        "https://acquiring.meezanbank.com/payment/rest/$operation";
    String username = 'ORAHLIFE_api';
    String password = 'OL987658';

    // String gatewayUrl =
    //     "https://test-securepayment.meezanbank.com/payment/rest/$operation";
    // String username = 'meezan_sandbox';
    // String password = 'mbl@123';

    String params =
        "currency=$currency&userName=$username&password=$password&orderNumber=$randomSixDigitNumber&amount=$amount&returnUrl=$returnUrl";
    String finalUrl = "$gatewayUrl?$params";

    try {
      var response = await http.post(Uri.parse(finalUrl));
      print(" ubaid respone ${response.body.toString()}");

      if (response.statusCode == 200) {
        print(" ubaid khan ${response.statusCode}");
        Map<String, dynamic> responseData = json.decode(response.body);

        String successUrl = responseData['formUrl'];
        print("ubaid khan form url ${successUrl}");
        late WebViewController controller;

        if (responseData["errorCode"] == 0) {
          print(" order Created $OrderDetails()");

          print("Ubaid khan if condition${responseData.toString()}");
          controller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse(successUrl))
            ..setNavigationDelegate(
              NavigationDelegate(
                onPageFinished: (String url) async {
                  if (url.startsWith(
                      "https://www.orah.pk/checkout-complete-mobile")) {
                    print("Ubaid khan nasted if condition${url.toString()}");
                    print(
                        "Ubaid khan ORDERDETAIL AJJJJJJJJJJJJJJJJJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");

                    await OrderDetails();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Order created successfully!')),
                    );
                    Navigator.pop(context);
                  }

                  // hasRedirected = true;
                  // if (hasRedirected) {
                  //   createOrder();
                  // }
                  //}
                  else {
                    print("User did not redirect to return URL");
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             ShippingDetail(price: '', cartItems: [])));
                  }
                },
              ),
            );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Payment From',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: MyColor.darkblue,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                body: WebViewWidget(
                  controller: controller,
                ),
              ),
            ),
          );
        } else {
          print("Ubaid khan Navigation error");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ErrorPage(),
            ),
          );
          print("Error: ${responseData['errorMessage']}");
          // Redirect to error URL or handle the error
        }
      } else {
        print("Error: Non-200 status code - ${response.statusCode}");
        // Handle non-200 status code
      }
    } catch (error) {
      print("Error: $error");
      // Handle HTTP request error
    }
    dbhelper.deleteAllData();
  }

  // Meezan Bank Payment API
  // Future<void> makePayment(BuildContext context) async {
  //   int amount = grandTotal! * 100;
  //   String currency = "586";
  //   String returnUrl = 'https://orah.pk/check-payment-status';
  //   String operation = "register.do";
  //   String gatewayUrl =
  //       "https://acquiring.meezanbank.com/payment/rest/$operation";
  //   String username = 'ORAHLIFE_api';
  //   String password = 'OL987658';
  //   String params =
  //       "currency=$currency&userName=$username&password=$password&orderNumber=$randomSixDigitNumber&amount=$amount&returnUrl=$returnUrl";
  //   String finalUrl = "$gatewayUrl?$params";

  //   try {
  //     var response = await http.post(Uri.parse(finalUrl));
  //     print("Response: $response");

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> responseData = json.decode(response.body);

  //       if (responseData["errorCode"] == 0) {
  //         print("Order details will be fetched.");
  //         await OrderDetails(); // Directly call OrderDetails after successful payment
  //       } else {
  //         print("Navigation error: ${responseData['errorMessage']}");
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => ErrorPage(),
  //           ),
  //         );
  //       }
  //     } else {
  //       print("Error: Non-200 status code - ${response.statusCode}");
  //     }
  //   } catch (error) {
  //     print("Error ubaid: $error");
  //   } finally {
  //     dbhelper.deleteAllData();
  //   }
  // }

  //Get Payment Method Order Details
  Future OrderDetails() async {
    String username = 'ORAHLIFE_api';
    String password = 'OL987658';
    String operation = "getOrderStatusExtended.do";
    String gatewayUrl =
        "https://acquiring.meezanbank.com/payment/rest/$operation";

    String params =
        "userName=$username&password=$password&orderNumber=$randomSixDigitNumber";
    String finalUrl = "$gatewayUrl?$params";

    final response = await http.get(Uri.parse(finalUrl));
    var data = jsonDecode(response.body);
    print("Ubaid khan");
    print(" datajxkskxsk $data");

    if (response.statusCode == 200) {
      createOrder();
      print('created');

      int actionCode = data['actionCode'];
      print("ubaid respone code ${response.body.toString()}");
      print("ubaid action code ${response.body.toString()}");

      // ignore: unused_local_variable
      int orderStatus = data['OrderStatus'];
      String actionCodeDescription = data['actionCodeDescription'];
      print('Reponse of wajih Api ubaid $data');
      if (actionCode == 0) {
        hasRedirected = true;
        if (hasRedirected) {
          print("Ubaid khan create order");
        }
        print("Ubaid khan after if condition create order");
      }
      //else {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => ErrorPage(),
      //     ),
      //   );
      //   SchedulerBinding.instance.addPostFrameCallback(
      //     (_) {
      //       FlushBar.flushbarmessagegreen(
      //           message: actionCodeDescription, context: context);
      //       print("Ubaid khan error in  during  create order");
      //     },
      //   );
      // }
      print('Order Details $data');
    }
  }

  // Future<void> OrderDetails() async {
  //   String username = 'ORAHLIFE_api';
  //   String password = 'OL987658';
  //   String operation = "getOrderStatusExtended.do";
  //   String gatewayUrl =
  //       "https://acquiring.meezanbank.com/payment/rest/$operation";
  //   String params =
  //       "userName=$username&password=$password&orderNumber=$randomSixDigitNumber";
  //   String finalUrl = "$gatewayUrl?$params";

  //   try {
  //     final response = await http.get(Uri.parse(finalUrl));
  //     var data = jsonDecode(response.body);

  //     if (response.statusCode == 200) {
  //       int actionCode = data['actionCode'];
  //       String actionCodeDescription = data['actionCodeDescription'];

  //       if (actionCode == 0) {
  //         print("Order created successfully.");
  //         createOrder();
  //       } else {
  //         print("Error: $actionCodeDescription");
  //       }
  //       print('Order Details: $data');
  //     }
  //   } catch (error) {
  //     print("Error: $error");
  //   }
  // }

  Future<void> generatePDFAndSendEmail(String toEmail) async {
    final List<List<String>> tableData = [];
    final pdf = pw.Document();
    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/orah-logo.png'))
          .buffer
          .asUint8List(),
    );
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    // ignore: unused_local_variable
    double totalDiscountPrice = 0;
    double subTotal = 0; // Variable to accumulate total amount
    //double deliveryCharges = 199; // Fixed delivery charges
    // ignore: unused_local_variable
    double total = 0;

    final headers = [
      'Name',
      'Quantity',
      'MRP',
      'Discount Per',
      'Discount Price',
      'Total'
    ];

    for (final cartItem in widget.cartItems) {
      final discountPrice =
          calculateDiscountedPrice(cartItem).roundToDouble().toInt();
      totalDiscountPrice += discountPrice;

      final amount = cartItem.quantity * discountPrice;
      subTotal += amount;

      tableData.add([
        "${cartItem.product['product_name']}",
        "${cartItem.quantity}",
        "${calculateMRP(cartItem)}",
        "${calculateDiscountPercentage(cartItem)}%",
        "${calculateDiscountedPrice(cartItem)}",
        "${amount}",
      ]);
    }
    // if (subTotal > 2000) {
    //   deliveryCharges = 0;
    // }

    pdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.all(30),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(logo, height: 120, width: 120),
              pw.SizedBox(
                width: 220,
                child: pw.Text(
                  "Ground Floor, Family Heaven, S#4 Shaheed-e-Millat Rd, Jinnah Society Jinnah CHS PECHS, Karachi, Karachi City, Sindh 75400",
                  style: pw.TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
          pw.Divider(height: 20),

          //name and details
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              //name address
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  //name
                  pw.Text(
                    "Name: ${nameController.text}",
                    style: pw.TextStyle(fontSize: 10),
                  ),

                  //conatct
                  pw.Text(
                    "Contact No: ${phoneController.text}",
                    style: pw.TextStyle(fontSize: 10),
                  ),

                  //email
                  pw.Text(
                    "Email: ${emailController.text}",
                    style: pw.TextStyle(fontSize: 10),
                  ),

                  //address
                  _tabController.index == 1
                      ? pw.SizedBox(
                          width: 220,
                          child: pw.Text(
                            "Ground Floor, Family Heaven, S#4 Shaheed-e-Millat Rd, Jinnah Society Jinnah CHS PECHS, Karachi, Karachi City, Sindh 75400",
                            style: pw.TextStyle(fontSize: 10),
                          ),
                        )
                      : pw.SizedBox(
                          width: 240,
                          child: pw.Text(
                            // "Address: ${Global.addressController.text} ${apartmentController.text}"
                            "Address: ${selectedData}",
                            style: pw.TextStyle(fontSize: 10),
                          ),
                        ),

                  //Map link
                  pw.Text(
                    "https://www.google.com/maps/?q=${Global.latitude},${Global.longitude}",
                    // 'https://www.google.com/maps/search/?api=1&query=${Global.latitude},${Global.longitude}',
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),

              //other details
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Invoice no: ${randomSixDigitNumber}",
                    style: pw.TextStyle(fontSize: 10),
                  ),
                  pw.Text(
                    "Order no: OrahApp_$randomSixDigitNumber",
                    style: pw.TextStyle(fontSize: 10),
                  ),
                  _tabController.index == 1
                      ? pw.Text(
                          "Payment Status: ${selectedOption1}",
                          style: pw.TextStyle(fontSize: 10),
                        )
                      : pw.Text(
                          "Payment Status: ${selectedOption}",
                          style: pw.TextStyle(fontSize: 10),
                        ),
                  pw.Text(
                    "Date: ${formattedDate}",
                    style: pw.TextStyle(fontSize: 10),
                  ),
                  pw.Text(
                    "Delivery Type: ${_tabController.index == 1 ? 'Self pick Up ' : 'Delivery'}",
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 30),

          pw.Table.fromTextArray(
            headers: headers,
            data: tableData,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
            cellStyle: pw.TextStyle(fontSize: 10),
          ),
          pw.SizedBox(height: 20),

          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Text(""),
              ),

              //details
              pw.Expanded(
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    //subtotal
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Sub Total:',
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          '${subTotal}',
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 4),

                    //delivery charges
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Delivery Charges: ',
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          "${deliveryCharge}",
                          // '${deliveryCharges == 0 ? 'Free' : '${deliveryCharges}'}',
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),

                    widget.firstlogin == "yes" && subTotal >= 1000
                        ? pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'First Signup Discount ',
                                style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                "${widget.offerdicount}",
                                // '${deliveryCharges == 0 ? 'Free' : '${deliveryCharges}'}',
                                style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ],
                          )
                        : pw.SizedBox(),
                    pw.Divider(height: 10),

                    //total
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Total:',
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold),
                        ),
                        widget.firstlogin == "yes" && subTotal >= 1000
                            ? pw.Text(
                                '${offertotal}',
                                style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold),
                              )
                            : pw.Text(
                                '${subTotal += deliveryCharge}',
                                style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );

    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/Order_Details.pdf';

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Now, send the email with the PDF attachment
    await sendPDFEmail(toEmail, file);

    // OpenFile.open(filePath);
  }

  Future<void> sendPDFEmail(String toEmail, File pdfFile) async {
    final smtpServer = SmtpServer(
      'smtp.hostinger.com',
      username: 'no-reply@orah.pk',
      password: 'Zohaib5541@',
      ssl: true,
      port: 465,
      allowInsecure: true,
    );

    final message = Message()
      ..from = Address('no-reply@orah.pk', 'Orah Life')
      ..recipients.add(toEmail)
      ..ccRecipients.addAll(['orders@orah.pk', 'no-reply@orah.pk'])
      ..bccRecipients.add(Address('arham.khalid@rholab.net'))
      ..subject = 'New Order'
      ..text = 'You have new order'
      ..attachments.add(FileAttachment(pdfFile));

    try {
      await send(message, smtpServer);
      print('Email sent with PDF attachment');
    } catch (e) {
      print('Error sending email: $e');
    }
  }

  int calculateMRP(CartItem cartItem) {
    double mrp;

    if (cartItem.product['product_mrp_pack'] != null) {
      // If 'product_mrp_pack' is not null, parse its value and round to double
      mrp = double.parse(cartItem.product['product_mrp_pack']).roundToDouble();
    } else {
      // If 'product_mrp_pack' is null, calculate product_mrp * pack_size
      double productMRP = double.parse(cartItem.product['product_mrp']);
      int packSize = int.parse(cartItem.product['pack_size']);
      mrp = productMRP * packSize;
    }
    return mrp.floor();
  }

  int calculateDiscountPercentage(CartItem cartItem) {
    double discountPercentage =
        double.parse(cartItem.product['Discount']).roundToDouble();
    return discountPercentage.floor();
  }

  int calculateDiscountedPrice(CartItem cartItem) {
    double mrp;
    double discountPercentage;

    // Parse 'product_mrp_pack'
    if (cartItem.product['product_mrp_pack'] != null) {
      mrp = double.parse(cartItem.product['product_mrp_pack']).roundToDouble();
    } else {
      // If 'product_mrp_pack' is null, calculate product_mrp * pack_size
      double productMRP = double.parse(cartItem.product['product_mrp']);
      int packSize = int.parse(cartItem.product['pack_size']);
      mrp = productMRP * packSize;
    }

    // Parse 'Discount'
    if (cartItem.product['Discount'] != null) {
      discountPercentage =
          double.parse(cartItem.product['Discount']).roundToDouble();
    } else {
      // If 'Discount' is null, set discountPercentage to 0 (no discount)
      discountPercentage = 0;
    }

    // Calculate discounted price
    double discountedPrice =
        mrp - (mrp * discountPercentage / 100).roundToDouble();

    return discountedPrice.floor();
  }

  Future _bottomsheet() {
    // ignore: unused_local_variable
    DateTime now = DateTime.now();
    // ignore: unused_local_variable
    DateTime deliveryDate = DateTime(2024, 3, 23);
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Column(
              children: [
                //Text and Button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Address',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      CustomButton(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddressForm(),
                            ),
                          );
                        },
                        buttonText: '',
                        sizeWidth: 35,
                        sizeHeight: 35,
                        icon: Icons.add_rounded,
                        borderColor: MyColor.darkblue,
                        buttonColor: Colors.transparent,
                        buttonborderwidth: 2,
                        isIcon: true,
                      )
                    ],
                  ),
                ),

                //Address
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: dbHelper.getUserData(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      List<Map<String, dynamic>> userData = snapshot.data!;
                      return userData.isEmpty
                          ? Center(
                              child: Text(
                                "There is no data avaliable,\nPlease add address",
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: userData.length,
                              padding:
                                  EdgeInsets.only(left: 8, right: 8, bottom: 5),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                bool isSelected = selectedAddress ==
                                    userData[index]['address'];

                                // bool isSelected = selectedIndex == index;

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    // Wajih changes
                                    isSelected = false;

                                    setState(() {
                                      // Update the selected index and data
                                      selectedIndex = isSelected ? null : index;
                                      print('Selected Index $selectedIndex');
                                      print('Index $index');
                                      print('isSelected $isSelected');
                                      //
                                      selectedData = isSelected
                                          ? null
                                          : _dataToString(userData[index]);
                                      //
                                      print('Address $selectedData');

                                      // Call Delivery Charges
                                      setDeliveryCharges(selectedData);

                                      print(
                                          'Delivery Chargess $deliveryCharge');
                                      //
                                    });
                                    updateSelectedData(
                                        selectedIndex!, selectedData);
                                    selectedAddress =
                                        userData[index]['address'];
                                    mapLink = userData[index]['maplink'];
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                        // color: isSelected
                                        //     ? MyColor.darkblue
                                        //     : Colors.grey.shade400,
                                        color: Colors.grey.shade400,

                                        width: 2.0,
                                      ),
                                    ),
                                    color: Colors.white,
                                    child: ListTile(
                                      title: Text(userData[index]['address']),
                                      subtitle:
                                          Text(userData[index]['apartment']),
                                    ),
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  showMyDialog() async {
    var mq = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            child: CustomContainer(
              sizeHeight: mq.height * 0.5,
              sizeWidth: mq.width * 0.5,
              radius: 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.asset(
                    'assets/lottie/order_placed.json',
                    height: mq.height * 0.26,
                    repeat: false,
                  ),
                  SizedBox(
                    height: mq.height * 0.06,
                  ),
                  CustomButton(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavBar(),
                          ),
                          (Route<dynamic> route) =>
                              false, // This condition clears all previous routes
                        );
                        cartProvider.cartItems
                            .clear(); // Clear cart items after navigation
                      },
                      buttonText: 'Done',
                      sizeWidth: mq.width * 0.5),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
