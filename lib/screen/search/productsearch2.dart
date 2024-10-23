import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/provider/cart_provider.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:orah_pharmacy/widget/custom_textfield.dart';
import 'package:orah_pharmacy/widget/custom_card.dart';
import 'package:orah_pharmacy/widget/flushbar.dart';
import '../product_detail/product_details.dart';

class ProductSearch2 extends StatefulWidget {
  final List product_list;

  ProductSearch2({super.key, required this.product_list});

  @override
  State<ProductSearch2> createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch2> {
  TextEditingController searchController = TextEditingController();
  List filter = [];

  @override
  void initState() {
    filter = widget.product_list;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Filter products based on search query
    List filteredProducts = searchController.text.isEmpty
        ? filter
        : filter
            .where((product) => product['product_name']
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();

    // Filter out products with totalquantity == 0
    List displayedProducts = filteredProducts.where((product) {
      try {
        double apiValue = product['product_mrp_pack'] != null
            ? double.parse(product['product_mrp_pack'])
            : double.parse(product['product_mrp']) *
                int.parse(product['pack_size']);

        double api1Value = double.parse(product['purchase_quantity']);
        double _packsize = double.parse(product['pack_size']);
        // ignore: unused_local_variable
        double discountedPrice =
            apiValue - (apiValue * double.parse(product['Discount']) / 100);
        int totalquantity = (api1Value / _packsize).toInt();

        return totalquantity > 0 &&
            !totalquantity.isNaN &&
            !totalquantity.isInfinite;
      } catch (e) {
        print("Error processing product: $e");
        return false;
      }
    }).toList();

    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.04,
          vertical: mq.height * 0.03,
        ),
        child: Column(
          children: [
            // Search field
            CustomTextField(
              controller: searchController,
              prefixIcon: const Icon(
                FeatherIcons.search,
                color: Colors.black,
              ),
              hintText: "Search Medicines & Products",
              fillColor: Colors.grey.shade100,
              filled: true,
              onChanged: (value) => setState(() {}),
            ),
            SizedBox(height: mq.height * 0.02),

            // Body
            displayedProducts.isEmpty
                ? Center(
                    child: searchController.text.isEmpty
                        ? const CircularProgressIndicator(
                            color: MyColor.darkblue)
                        : const Text(
                            'No Products Found',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  )
                : Expanded(
                    child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: mq.width * 0.03,
                        crossAxisSpacing: mq.height * 0.02,
                        childAspectRatio: mq.aspectRatio / 0.84,
                      ),
                      shrinkWrap: true,
                      itemCount: displayedProducts.length,
                      itemBuilder: (context, index) {
                        var product = displayedProducts[index];
                        try {
                          double apiValue = product['product_mrp_pack'] != null
                              ? double.parse(product['product_mrp_pack'])
                              : double.parse(product['product_mrp']) *
                                  int.parse(product['pack_size']);

                          int integerValue = apiValue.toInt();
                          double discountedPrice = integerValue -
                              (integerValue *
                                  double.parse(product['Discount']) /
                                  100);
                          int AfterdiscountPrice = discountedPrice.round();
                          int quantityvalue =
                              (double.parse(product['purchase_quantity']) /
                                      double.parse(product['pack_size']))
                                  .toInt();

                          return CustomCard(
                            image: product['product_image'],
                            name: product['product_name'],
                            price: "$AfterdiscountPrice",
                            product_mrps: "$integerValue",
                            discount: double.parse(product['Discount']).toInt(),
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetails(data: product),
                                ),
                              );
                            },
                            child: CustomButton(
                              onTap: () {
                                if (quantityvalue == 0) {
                                  FlushBar.flushBarMessage(
                                    message: 'Out of Stock',
                                    context: context,
                                  );
                                } else {
                                  cartProvider.addToCart(
                                      product, quantityvalue);
                                  FlushBar.flushbarmessagegreen(
                                    message: 'Item Added',
                                    context: context,
                                  );
                                }
                              },
                              buttonText: quantityvalue == 0
                                  ? 'Out of Stock'
                                  : 'Add to Cart',
                              sizeWidth: double.infinity,
                              sizeHeight: 40,
                              boderRadius: 30,
                              buttontextsize: 12,
                              buttonColor: quantityvalue == 0
                                  ? Colors.red
                                  : MyColor.darkblue,
                            ),
                          );
                        } catch (e) {
                          print("Error building product card: $e");
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
