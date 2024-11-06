// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/provider/cart_provider.dart';
import 'package:orah_pharmacy/services/global.dart';
import 'package:orah_pharmacy/widget/custom_container.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatefulWidget {
  OrderDetails({super.key, required this.data, this.getlength});

  final Map<String, dynamic> data;
  final dynamic getlength;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    final cartprovider = Provider.of<CartProvider>(context);

    final dis = cartprovider.getTotalDiscount();

    var mq = MediaQuery.of(context).size;
    List<dynamic> products = widget.data['products'];
    int subtotal = 0;
    int savedAmount = 0;
    int totalDiscount = 0;
    int shipping = 0;
    int checkAble = 0;
    int discountPrice = 0;
    int dealdiscount = 200;
    int intofferdiscount = 0;

    for (var item in products) {
      double apiValue = double.parse(item['product_mrp_pack']).roundToDouble();
      int integerValue = apiValue.toInt();

      double api1Value = double.parse(item['quantity']);
      int purchasequantity = api1Value.toInt();

      // double api1Value = double.parse(item['unit_quantity']);
      // int purchasequantity = api1Value.toInt();

      double api2Value = double.parse(item['discount_one']);
      int discount = api2Value.toInt();

      double _packsize = double.parse(item['pack_size']);
      int packsize = _packsize.toInt();

      double result = purchasequantity / packsize;
      int totalquantity = result.toInt();

      double discountedPrice = integerValue - (integerValue * discount / 100);

      // int AfterdiscountPrice = discount.roundToDouble().toInt();

      double shippingdou = double.parse(widget.data['shipping']);
      shipping = shippingdou.toInt();

      subtotal += integerValue * totalquantity;

      savedAmount = integerValue - discountedPrice.roundToDouble().toInt();

      totalDiscount += savedAmount * totalquantity;

      double offerdisount = double.parse(widget.data["order_discount"]);
      intofferdiscount = offerdisount.toInt();

      print("ubaid kha offer discount ${intofferdiscount}");
    }

    int total = subtotal + shipping - totalDiscount;

    int offertotal = total - intofferdiscount;

    int grandtotal = subtotal - totalDiscount;
    //int grandtotal = total - totalDiscount;
    int finalamount = total + shipping;

    for (var item in products) {
      double apiValue = double.parse(item['product_mrp_pack']).roundToDouble();

      int integerValue = apiValue.toInt();

      double api1Value = double.parse(item['quantity']);
      int purchasequantity = api1Value.toInt();

      double api2Value = double.parse(item['discount_one']);
      int discount = api2Value.toInt();

      double _packsize = double.parse(item['pack_size']);
      int packsize = _packsize.toInt();

      double result = purchasequantity / packsize;
      int totalquantity = result.toInt();

      double discountedPrice = integerValue - (integerValue * discount / 100);

      // var discountedPrice = integerValue - discount;
      //
      int AfterdiscountPrice = discountedPrice.roundToDouble().toInt();

      //
      // print("ubaid khan discount offer ${item["order_discount"]}");
      print("PayAble Value ${integerValue}");
      print(" ubaid khan ${widget.getlength}");
      print("Discountable Price ${AfterdiscountPrice}");
      print(discountedPrice);

      checkAble += integerValue - AfterdiscountPrice;
      print("Check Kr${checkAble}");
      //print(products);
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColor.darkblue,
        body: Column(
          children: [
            //app bar
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
                  SizedBox(
                    width: mq.width * 0.8,
                    child: Text(
                      'Order Details',
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
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.builder(
                        itemCount: products.length,
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            top: mq.height * 0.03,
                            right: mq.width * 0.04,
                            left: mq.width * 0.04),
                        itemBuilder: (context, index) {
                          var item = products[index];

                          double apiValue =
                              double.parse(item['product_mrp_pack'])
                                  .roundToDouble();

                          int integerValue = apiValue.toInt();

                          double api1Value = double.parse(item['quantity']);
                          int purchasequantity = api1Value.toInt();

                          double api2Value = double.parse(item['discount_one']);
                          int discount = api2Value.toInt();

                          double _packsize = double.parse(item['pack_size']);
                          int packsize = _packsize.toInt();

                          double result = purchasequantity / packsize;
                          int totalquantity = result.toInt();

                          double discountedPrice =
                              integerValue - (integerValue * discount / 100);

                          // var discountedPrice = integerValue - discount;
                          //
                          int AfterdiscountPrice =
                              discountedPrice.roundToDouble().toInt();

                          //
                          print("ubaid khan ${widget.data["products"].length}");
                          print("PayAble Value ${integerValue}");
                          print("Discountable Price ${AfterdiscountPrice}");
                          print(discountedPrice);

                          checkAble += integerValue - AfterdiscountPrice;
                          print("discount ${checkAble}");
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            // height: mq.height * 0.22,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  offset: Offset(2, 4),
                                  blurRadius: 6,
                                  spreadRadius: 0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      Image.network(
                                        '${Global.imageUrl}${item['product_image']}',
                                        // height: mq.height * 0.4,
                                        width: mq.width * 0.3,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      ),
                                      discount == 0
                                          ? Container()
                                          : discount >= 10
                                              ? CustomContainer(
                                                  sizeHeight: 35,
                                                  sizeWidth: 60,
                                                  color: Colors.transparent,

                                                  // sizeHeight: mq.height * 0.044,
                                                  // sizeWidth: mq.width * 0.2,

                                                  radius: 24,
                                                  child: Center(
                                                      child: Image.asset(
                                                          'assets/images/offerlogo.png')),
                                                )
                                              : CustomContainer(
                                                  sizeHeight: 30,
                                                  sizeWidth: 70,
                                                  color: Colors.green,
                                                  radius: 24,
                                                  child: Center(
                                                    child: Text(
                                                      "${discount}% Off",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                    ],
                                  ),
                                  SizedBox(width: 8),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['product_name'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Text(
                                              "Rs ${AfterdiscountPrice}",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            SizedBox(width: mq.width * 0.01),
                                            discount == 0
                                                ? Container()
                                                : Text(
                                                    "${integerValue}",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                            // 'Quantity: ${double.parse(item['quantity']).roundToDouble().toInt()}',
                                            "Quantity: ${totalquantity}"),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      TextButton(
                          onPressed: () async {
                            Uri phoneno = Uri.parse('tel:+923331116724');
                            if (await launchUrl(phoneno)) {
                            } else {}
                          },
                          child: Text(
                            "Reach us out at +923331116724",
                            style: TextStyle(color: MyColor.darkblue),
                          ))
                    ],
                  ),
                ),
              ),
            ),

            //bottom
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mq.width * 0.04,
                    vertical: mq.height * 0.03,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //subtotal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "SubTotal:",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.grey),
                          ),
                          Text(
                            "$grandtotal",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      //delivery
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery Fee",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.grey),
                          ),
                          Text(
                            "${shipping}",
                            //"${deliveryCharge == 0 ? 'Free' : deliveryCharge}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      //discount
                      intofferdiscount > 0 && grandtotal >= 1000
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  " First Signup Discount:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.grey),
                                ),
                                Text(
                                  "${intofferdiscount}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          : SizedBox(),
                      Divider(),

                      //total

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.grey),
                          ),
                          intofferdiscount > 0 && grandtotal >= 1000
                              ? Text(
                                  "Rs: $offertotal",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  "Rs: $total",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                ),
                        ],
                      )
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
}
