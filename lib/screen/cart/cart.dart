// ignore_for_file: unused_local_variable

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:orah_pharmacy/Database%20Orah/database_orah.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/provider/cart_provider.dart';
import 'package:orah_pharmacy/screen/cart/shipping_details.dart';
import 'package:orah_pharmacy/screen/login%20&%20Register%20&%20forgot/loginselection.dart';
import 'package:orah_pharmacy/services/global.dart';
import 'package:orah_pharmacy/widget/custom_Container.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  void initState() {
    getloginid();
    super.initState();
  }

  void getloginid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loginid = prefs.getString('login_id');
      firstdiscount = prefs.getInt('discount');

      username = prefs.getString('name');
      email = prefs.getString('email');
      phone = prefs.getString('phone');
      firstlogin = prefs.getString('firstlogin');
      print(loginid);
      print("ubaid check login ${firstlogin}");
      print("ubaid discount login ${firstdiscount}");
    });
  }

  var loginid;
  var username;
  var email;
  var phone;
  var firstlogin;
  bool isloading = false;
  var firstdiscount;
  //
  DatabaseOrah? dbHelper = DatabaseOrah();

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    final cartProvider = Provider.of<CartProvider>(context);
    final totalAmount = cartProvider.getTotalPrice();
    final totalDiscount = cartProvider.getTotalDiscount();
    // final offerdiscount = (totalDiscount ) + (firstdiscount ?? 200);
    //print("offer discount $offerdiscount");
    //print(offerdiscount);

    // final deliveryCharge =
    //     cartProvider.cartItems.isEmpty ? 0 : (totalAmount >= 2000 ? 0 : 199);

    //final grandTotal = totalAmount + deliveryCharge - totalDiscount;
    final grandTotal = totalAmount - totalDiscount;

    //final offertotal = totalAmount- offerdiscount.roundToDouble().toInt();

    int quantityvalue;
    int packsize;
    int totalquantity;
    int medicinquantity;

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
                      'Cart',
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
            cartProvider.cartItems.length == 0
                ? Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Center(child: Text('No Cart in Item')),
                    ),
                  )
                : Expanded(
                    flex: 4,
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
                            // horizontal: mq.width * 0.04,
                            vertical: mq.height * 0.03),
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(
                            height: mq.height * 0.03,
                          ),
                          itemCount: cartProvider.cartItems.length,
                          itemBuilder: (context, index) {
                            //
                            final cartItem = cartProvider.cartItems[index];
                            final product = cartItem.product;
                            var quantity = cartItem.quantity;

                            double apiValue =
                                double.parse(product['product_mrp_pack']);
                            //
                            int integerValue = apiValue.toInt();

                            double _purchasequantity =
                                double.parse(product['purchase_quantity']);
                            //
                            quantityvalue = _purchasequantity.toInt();
                            //
                            double api2Value =
                                double.parse(product['Discount']);
                            //
                            int discount = api2Value.toInt();

                            double discountedPrice =
                                integerValue - (integerValue * discount / 100);
                            //
                            int AfterdiscountPrice =
                                discountedPrice.roundToDouble().toInt();

                            double _packsize =
                                double.parse(product['pack_size']);
                            packsize = _packsize.toInt();

                            double result = _purchasequantity / _packsize;
                            totalquantity = result.toInt();

                            medicinquantity = quantity * packsize;

                            final savedAmount =
                                integerValue - AfterdiscountPrice;
                            print(" saved amount $savedAmount");

                            final totalDiscount = savedAmount * quantity;
                            print(" total discount $totalDiscount");

                            return CustomContainer(
                              sizeHeight: 140,
                              sizeWidth: double.maxFinite,
                              // sizeWidth: mq.width * 0.2,

                              color: Colors.white,
                              child: Row(
                                children: [
                                  //product iamge
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      CustomContainer(
                                        sizeHeight: 140,
                                        sizeWidth: 130,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Image.network(
                                            "${Global.imageUrl + product['product_image']}",
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: discount == 0
                                            ? Container()
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
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: mq.width * 0.04),

                                  //product detail
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      //Name
                                      Container(
                                        width: mq.width * 0.5,
                                        child: Text(
                                          maxLines: 2,
                                          '${product['product_name']}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),

                                      //Price
                                      Row(
                                        children: [
                                          Text(
                                            "RS: $AfterdiscountPrice",
                                          ),
                                          SizedBox(width: mq.width * 0.02),
                                          discount == 0
                                              ? Text("")
                                              : Text(
                                                  "$integerValue",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                        ],
                                      ),

                                      //Counter And delet button
                                      Row(
                                        children: [
                                          buildQuantityButton(
                                            icon: Icons.remove_rounded,
                                            onPressed: () {
                                              if (quantity > 1) {
                                                cartProvider.updateQuantity(
                                                    cartItem, quantity - 1);
                                              }
                                            },
                                          ),
                                          Text(
                                            '$quantity',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),

                                          buildQuantityButton(
                                            icon: Icons.add_rounded,
                                            onPressed: () {
                                              if (cartItem.quantity <
                                                  cartItem.stockQuantity) {
                                                setState(() {
                                                  cartProvider.updateQuantity(
                                                      cartItem,
                                                      cartItem.quantity + 1);
                                                });
                                              }
                                            },
                                          ),
                                          SizedBox(width: mq.width * 0.18),

                                          // Delete button
                                          IconButton(
                                            onPressed: () {
                                              dbHelper!.deleteData(
                                                  product['product_id']);
                                              cartProvider
                                                  .removeFromCart(cartItem);
                                            },
                                            icon:
                                                const Icon(FeatherIcons.trash2),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

            cartProvider.cartItems.length == 0
                ? Container()
                : Expanded(
                    flex: 2,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: mq.width * 0.04,
                            vertical: mq.height * 0.02),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Subtotal amount
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sub Total',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.grey),
                                ),
                                Text(
                                  '${totalAmount}',
                                  // 'Rs: ${cartProvider.getTotalPrice()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                )
                              ],
                            ),

                            //Discount

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Discount',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.grey),
                                ),
                                Text(
                                  '${totalDiscount}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                )
                              ],
                            ),
                            Divider(height: mq.height * 0.03),

                            //total amount

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
                                Text('Rs: ${grandTotal}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                              ],
                            ),
                            SizedBox(height: mq.height * 0.01),

                            //Button
                            CustomButton(
                              onTap: () {
                                loginid == null
                                    ? _showMyDialog()
                                    : cartProvider.getTotalPrice() == 0
                                        ? null
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ShippingDetail(
                                                // price:
                                                //     '${cartProvider.getTotalPrice()}',
                                                price: "${grandTotal}",
                                                firstlogin: firstlogin,
                                                offerdicount: firstdiscount,

                                                cartItems:
                                                    cartProvider.cartItems,
                                              ),
                                            ),
                                          );

                                print(loginid);
                              },
                              buttonText: cartProvider.getTotalPrice() == 0
                                  ? 'Empty Cart'
                                  : ('Checkout'),
                              sizeHeight: 65,
                              sizeWidth: double.infinity,
                            )
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

  Future<void> _showMyDialog() async {
    var mq = MediaQuery.of(context).size;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          child: CustomContainer(
            sizeHeight: mq.height * 0.5,
            sizeWidth: mq.width * 0.5,
            radius: 15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                  'assets/lottie/login.json',
                  height: mq.height * 0.2,
                ),
                Text(
                  'Login Required',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(
                  height: mq.height * 0.03,
                ),
                CustomButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginSelection(),
                        ),
                      );
                    },
                    buttonText: 'Login',
                    sizeWidth: mq.width * 0.5)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildQuantityButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      iconSize: 20,
      icon: Icon(
        icon,
        color: MyColor.darkblue,
      ),
      onPressed: onPressed,
    );
  }
}
