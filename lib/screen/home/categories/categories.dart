import 'package:flutter/material.dart';
import 'package:orah_pharmacy/Database%20Orah/database_orah.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/provider/cart_provider.dart';
import 'package:orah_pharmacy/screen/cart/cart.dart';
import 'package:orah_pharmacy/screen/product_detail/product_details.dart';
import 'package:orah_pharmacy/services/api.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:orah_pharmacy/widget/custom_card.dart';
import 'package:orah_pharmacy/widget/flushbar.dart';
import 'package:orah_pharmacy/widget/shimmer/explore_more_shimmer.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  final String category;
  final String? category_id;

  const Categories({
    required this.category,
    super.key,
    this.category_id,
  });

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  String selectedColor = '';
  List product = [];
  List categoryData = [];
  List<Map<String, dynamic>> result = [];

  @override
  void initState() {
    print("Test Category id: ${widget.category_id}");
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    final res = await Api.getProducts(widget.category_id ?? '');
    if (res['code_status'] == true) {
      setState(() {
        product = res['products'];
        _updateCategoryData();
      });
    } else {
      // Handle error
      print("Error fetching products");
    }
  }

  void _updateCategoryData() {
    final filteredSubCategoryData = product
        .where((data) => data['category'] == widget.category)
        .where((data) {
      final quantity = double.tryParse(data['purchase_quantity'] ?? '0') ?? 0;
      double packSize = double.tryParse(data['pack_size'] ?? '0') ??
          1; // Avoid division by zero

      if (packSize == 0) {
        packSize = 1; // Fallback to 1 to avoid division by zero
      }

      double totalQuantityDouble = quantity / packSize;
      if (totalQuantityDouble.isFinite) {
        int totalQuantity = totalQuantityDouble.toInt();
        return totalQuantity >
            0; // Only include products with totalQuantity > 0
      } else {
        return false; // Exclude if the totalQuantity is NaN or infinite
      }
    }).toList();

    setState(() {
      result = filteredSubCategoryData
          .map((item) => item['subcategory'])
          .where((subcategory) => subcategory != null)
          .toSet()
          .map((subcategory) => {'subcategory': subcategory})
          .toList();

      categoryData = filteredSubCategoryData;
    });
  }

  void fetchSubCategory(String? selectedSubCategory) {
    setState(() {
      categoryData = product
          .where((data) => data['subcategory'] == selectedSubCategory)
          .where((data) {
        final quantity = double.tryParse(data['purchase_quantity'] ?? '0') ?? 0;
        double packSize = double.tryParse(data['pack_size'] ?? '0') ??
            1; // Avoid division by zero
        int totalQuantity = (quantity / packSize).toInt();
        return totalQuantity >
            0; // Only include products with totalQuantity > 0
      }).toList();
      _sortCategoryData();
    });
  }

  void _sortCategoryData() {
    categoryData.sort((a, b) {
      if (a['product_image'] == 'no_image.png' &&
          b['product_image'] != 'no_image.png') {
        return 1;
      } else if (a['product_image'] != 'no_image.png' &&
          b['product_image'] == 'no_image.png') {
        return -1;
      } else {
        return 0;
      }
    });
  }

  DatabaseOrah? dbHelper = DatabaseOrah();

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

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
                  Expanded(
                    child: Text(
                      widget.category,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                          ),
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
            categoryData.isEmpty
                ? ExploreMoreShimmer()
                : Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Filter chip
                          SizedBox(height: mq.height * 0.01),
                          if (result.isNotEmpty)
                            SizedBox(
                              height: mq.height * 0.08,
                              child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: mq.width * 0.04,
                                ),
                                separatorBuilder: (context, index) => SizedBox(
                                  width: mq.width * 0.02,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: result.length,
                                itemBuilder: (context, index) {
                                  final color = result[index]['subcategory'];
                                  return FilterChip(
                                    checkmarkColor: Colors.white,
                                    backgroundColor: selectedColor == color
                                        ? MyColor.darkblue
                                        : Colors.white,
                                    selected: selectedColor == color,
                                    selectedColor: MyColor.darkblue,
                                    label: Text(
                                      '${result[index]['subcategory'] ?? ''}',
                                      style: TextStyle(
                                        color: selectedColor == color
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    onSelected: (bool onSelected) {
                                      setState(() {
                                        selectedColor =
                                            onSelected ? color ?? '' : '';
                                        if (onSelected) {
                                          fetchSubCategory(color);
                                        } else {
                                          _updateCategoryData();
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                            ),

                          // Data
                          Expanded(
                            child: GridView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(
                                vertical: mq.height * 0.02,
                                horizontal: mq.width * 0.04,
                              ),
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: mq.width * 0.03,
                                crossAxisSpacing: mq.height * 0.02,
                                childAspectRatio: mq.aspectRatio / 0.79,
                              ),
                              itemCount: categoryData.length,
                              itemBuilder: (context, index) {
                                final item = categoryData[index];
                                double apiValue = 0;
                                int integerValue = 0;

                                if (item['product_mrp_pack'] != null) {
                                  apiValue = double.tryParse(
                                          item['product_mrp_pack']) ??
                                      0;
                                  integerValue = apiValue.toInt();
                                } else {
                                  if (item['product_mrp'] != null &&
                                      item['pack_size'] != null) {
                                    double productMRP =
                                        double.tryParse(item['product_mrp']) ??
                                            0;
                                    int packSize =
                                        int.tryParse(item['pack_size']) ??
                                            1; // Avoid division by zero
                                    integerValue =
                                        (productMRP * packSize).toInt();
                                  } else {
                                    integerValue = 0;
                                  }
                                }

                                double api1Value = double.tryParse(
                                        item['purchase_quantity']) ??
                                    0;
                                int quantityValue = api1Value.toInt();

                                double packSize =
                                    double.tryParse(item['pack_size']) ??
                                        1; // Avoid division by zero
                                if (packSize == 0)
                                  packSize = 1; // Fallback to 1

                                double api2Value =
                                    double.tryParse(item['Discount']) ?? 0;
                                int discount = api2Value.toInt();

                                double discountedPrice = integerValue -
                                    (integerValue * discount / 100);
                                int afterDiscountPrice =
                                    discountedPrice.round();

                                double result =
                                    (quantityValue / packSize).isFinite
                                        ? quantityValue / packSize
                                        : 0;
                                int totalQuantity = result.toInt();

                                return totalQuantity > 0
                                    ? CustomCard(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetails(data: item),
                                            ),
                                          );
                                        },
                                        image: item['product_image'],
                                        name: item['product_name'],
                                        price: "$afterDiscountPrice",
                                        product_mrps: "${integerValue}",
                                        discount: discount,
                                        child: CustomButton(
                                          onTap: totalQuantity == 0
                                              ? () {
                                                  FlushBar.flushBarMessage(
                                                    message: 'Out of Stock',
                                                    context: context,
                                                  );
                                                }
                                              : () {
                                                  dbHelper!
                                                      .insertData(
                                                          item['product_id'])
                                                      .then((value) {
                                                    cartProvider.addToCart(
                                                        item, totalQuantity);
                                                    dbHelper!.readData();
                                                    FlushBar
                                                        .flushbarmessagegreen(
                                                      message: 'Item Added',
                                                      context: context,
                                                    );
                                                  }).onError(
                                                          (error, stackTrace) {
                                                    FlushBar.flushBarMessage(
                                                      message:
                                                          'Item already added',
                                                      context: context,
                                                    );
                                                  });
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
                                      )
                                    : SizedBox.shrink();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
