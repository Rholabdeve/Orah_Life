import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/provider/cart_provider.dart';
import 'package:orah_pharmacy/services/api.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:orah_pharmacy/widget/custom_textfield.dart';
import 'package:orah_pharmacy/widget/custom_card.dart';
import 'package:orah_pharmacy/widget/flushbar.dart';
import 'package:provider/provider.dart';

import '../product_detail/product_details.dart';

class ProductSearch extends StatefulWidget {
  const ProductSearch({super.key});

  @override
  State<ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  TextEditingController searchController = TextEditingController();
  List product = [];
  List filter = [];

  Future<void> fetchproduct() async {
    var res = await Api.getProducts("");
    if (res['code_status'] == true) {
      setState(
        () {
          product = res['products']
              .where((item) => item['product_mrp'] != null)
              .toList();
          //
          product = res['products']
              .where((item) => item['product_mrp_pack'] != null)
              .toList();
          //
          filter = res['products']
              .where((item) => item['product_mrp'] != null)
              .toList();
        },
      );

      product.sort((a, b) {
        if (a['product_image'] == 'no_image.png' &&
            b['product_image'] != 'no_image.png') {
          return 1; // 'no_image.png' should come after other images
        } else if (a['product_image'] != 'no_image.png' &&
            b['product_image'] == 'no_image.png') {
          return -1; // Other images should come before 'no_image.png'
        } else if (a['purchase_quantity'] == '0.0000' &&
            b['purchase_quantity'] != '0.0000') {
          return 1; // '0.0000' should come after other quantities
        } else if (a['purchase_quantity'] != '0.0000' &&
            b['purchase_quantity'] == '0.0000') {
          return -1; // Other quantities should come before '0.0000'
        } else {
          return 0; // No change in order if both have the same image and quantity
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchproduct();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.04,
          vertical: mq.height * 0.03,
        ),
        child: Column(
          children: [
            //serch field
            CustomTextField(
              controller: searchController,
              prefixIcon: const Icon(
                FeatherIcons.search,
                color: Colors.black,
              ),
              hintText: "Search Medicines & Products",
              fillColor: Colors.grey.shade100,
              filled: true,
              onChanged: (value) => {
                setState(
                  () {
                    if (searchController.text.isNotEmpty) {
                      List tempSearch = filter
                          .where((element) => element['product_name']
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase()))
                          .toList();

                      product = tempSearch;
                    }
                  },
                ),
              },
            ),
            SizedBox(height: mq.height * 0.02),

            //body
            product.length == 0 && searchController.text.isNotEmpty
                ? Center(
                    child: Text(
                    'No Products Found',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
                : Expanded(
                    child: product.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: MyColor.darkblue,
                            ),
                          )
                        : GridView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: mq.width * 0.03,
                              crossAxisSpacing: mq.height * 0.02,
                              // childAspectRatio: 15.9 / 24,
                              childAspectRatio: mq.aspectRatio / 0.84,
                            ),
                            shrinkWrap: true,
                            itemCount: product.length,
                            itemBuilder: (context, index) {
                              double apiValue;
                              int integerValue;

                              if (product[index]['product_mrp_pack'] != null) {
                                // If 'product_mrp_pack' is not null, parse its value and round to double
                                apiValue = double.parse(
                                        product[index]['product_mrp_pack'])
                                    .roundToDouble();
                                integerValue = apiValue.toInt();
                              } else {
                                // If 'product_mrp_pack' is null, calculate product_mrp * pack_size
                                double productMRP =
                                    double.parse(product[index]['product_mrp']);
                                int packSize =
                                    int.parse(product[index]['pack_size']);
                                integerValue = (productMRP * packSize).toInt();
                              }

                              double api1Value = double.parse(
                                  product[index]['purchase_quantity']);
                              int quantityvalue = api1Value.toInt();

                              double _packsize =
                                  double.parse(product[index]['pack_size']);
                              int packsize = _packsize.toInt();

                              double api2Value =
                                  double.parse(product[index]['Discount']);
                              int discount = api2Value.toInt();

                              double discountedPrice = integerValue -
                                  (integerValue * discount / 100);
                              int AfterdiscountPrice =
                                  discountedPrice.roundToDouble().toInt();

                              double result = quantityvalue / packsize;
                              int totalquantity = result.toInt();
                              print(" quantity $quantityvalue");
                              return CustomCard(
                                image: product[index]['product_image'],
                                name: product[index]['product_name'],
                                price: "$AfterdiscountPrice",
                                product_mrps: "$integerValue",
                                discount: discount,
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetails(
                                        data: product[index],
                                      ),
                                    ),
                                  );
                                },
                                child: CustomButton(
                                  onTap: totalquantity == 0
                                      ? () {
                                          FlushBar.flushBarMessage(
                                              message: 'Out of Stock',
                                              context: context);
                                        }
                                      : () {
                                          print(product[index]);
                                          cartProvider.addToCart(
                                              product[index], totalquantity);
                                          FlushBar.flushbarmessagegreen(
                                              message: 'Item Added',
                                              context: context);
                                        },
                                  buttonText:
                                      "${totalquantity == 0 ? 'Out of Stock' : 'Add to Cart'}",
                                  sizeWidth: double.infinity,
                                  sizeHeight: 40,
                                  boderRadius: 30,
                                  buttontextsize: 12,
                                  buttonColor: totalquantity == 0
                                      ? Colors.red
                                      : MyColor.darkblue,
                                ),
                              );
                            },
                          ),
                  )
          ],
        ),
      ),
    );
  }
}
