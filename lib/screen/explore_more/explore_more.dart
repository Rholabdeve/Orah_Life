import 'package:flutter/material.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/provider/cart_provider.dart';
import 'package:orah_pharmacy/screen/cart/cart.dart';
import 'package:orah_pharmacy/screen/product_detail/product_details.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:orah_pharmacy/widget/custom_card.dart';
import 'package:orah_pharmacy/widget/flushbar.dart';
import 'package:orah_pharmacy/widget/shimmer/explore_more_shimmer.dart';
import 'package:provider/provider.dart';

class ExploreMore extends StatefulWidget {
  final List? medicine;
  final String? title;
  const ExploreMore({super.key, this.title, this.medicine});

  @override
  State<ExploreMore> createState() => _ExploreMoreState();
}

class _ExploreMoreState extends State<ExploreMore> {
  void initState() {
    isLoading = true;
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  late bool isLoading;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Filter out products with zero quantity
    List filteredMedicine = widget.medicine?.where((item) {
          try {
            double apiValue = double.parse(item['purchase_quantity']) /
                double.parse(item['pack_size']);
            int quantityValue = apiValue.isFinite ? apiValue.toInt() : 0;
            return quantityValue > 0;
          } catch (e) {
            return false;
          }
        }).toList() ??
        [];

    return SafeArea(
        child: Scaffold(
      backgroundColor: MyColor.darkblue,
      body: Column(
        children: [
          // App Bar $ cart
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width * 0.04,
              vertical: mq.height * 0.02,
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
                  width: mq.width * 0.5,
                  child: Text(
                    widget.title!,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  ),
                ),
                const Spacer(),
                Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    final cartItemsCount = cartProvider.cartItems.length;
                    return Badge(
                      offset: Offset(-3, 5),
                      label: Text(cartItemsCount.toString()),
                      backgroundColor: MyColor.lightblue,
                      child: IconButton(
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => ShoppingCart(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Body
          isLoading
              ? const ExploreMoreShimmer()
              : Expanded(
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
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: mq.width * 0.03,
                          crossAxisSpacing: mq.height * 0.02,
                          childAspectRatio: mq.aspectRatio / 0.84,
                        ),
                        itemCount: filteredMedicine.length,
                        itemBuilder: (context, index) {
                          double apiValue;
                          int integerValue;

                          var medicineItem = filteredMedicine[index];

                          try {
                            if (medicineItem['product_mrp_pack'] != null) {
                              apiValue =
                                  double.parse(medicineItem['product_mrp_pack'])
                                      .roundToDouble();
                              integerValue = apiValue.toInt();
                            } else {
                              if (medicineItem['product_mrp'] != null &&
                                  medicineItem['pack_size'] != null) {
                                double productMRP =
                                    double.parse(medicineItem['product_mrp']);
                                int packSize =
                                    int.parse(medicineItem['pack_size']);
                                integerValue = (productMRP * packSize).toInt();
                              } else {
                                integerValue = 0;
                              }
                            }

                            double api1Value =
                                double.parse(medicineItem['purchase_quantity']);
                            int quantityValue =
                                api1Value.isFinite ? api1Value.toInt() : 0;

                            double _packsize =
                                double.parse(medicineItem['pack_size']);
                            int packsize = _packsize.isFinite
                                ? _packsize.toInt()
                                : 1; // Use 1 as a fallback

                            double api2Value =
                                double.parse(medicineItem['Discount']);
                            int discount =
                                api2Value.isFinite ? api2Value.toInt() : 0;

                            double discountedPrice =
                                integerValue - (integerValue * discount / 100);
                            int afterDiscountPrice =
                                discountedPrice.roundToDouble().toInt();

                            double result =
                                packsize != 0 ? quantityValue / packsize : 0;
                            int totalQuantity =
                                result.isFinite ? result.toInt() : 0;

                            return totalQuantity == 0
                                ? SizedBox()
                                : CustomCard(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetails(
                                            data: medicineItem,
                                          ),
                                        ),
                                      );
                                    },
                                    image: medicineItem['product_image'],
                                    name: medicineItem['product_name'],
                                    price: "$afterDiscountPrice",
                                    product_mrps: "${integerValue}",
                                    discount: discount,
                                    child: CustomButton(
                                      onTap: totalQuantity == 0
                                          ? () {
                                              FlushBar.flushBarMessage(
                                                  message: 'Out of Stock',
                                                  context: context);
                                            }
                                          : () {
                                              cartProvider.addToCart(
                                                  medicineItem, totalQuantity);
                                              FlushBar.flushbarmessagegreen(
                                                  message: 'Item Added',
                                                  context: context);
                                            },
                                      buttonText:
                                          "${totalQuantity == 0 ? 'Out of Stock' : 'Add to Cart'}",
                                      sizeWidth: double.infinity,
                                      sizeHeight: 40,
                                      boderRadius: 30,
                                      buttontextsize: 12,
                                      buttonColor: totalQuantity == 0
                                          ? Colors.red
                                          : MyColor.darkblue,
                                    ),
                                  );
                          } catch (e) {
                            // Handle any exceptions that occur
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                  ),
                ),
        ],
      ),
    ));
  }
}
