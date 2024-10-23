import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orah_pharmacy/Database%20Orah/database_orah.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/provider/cart_provider.dart';
import 'package:orah_pharmacy/screen/cart/cart.dart';
import 'package:orah_pharmacy/services/global.dart';
import 'package:orah_pharmacy/widget/custom_Container.dart';
import 'package:orah_pharmacy/widget/flushbar.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final data;
  static var product_mrpsss;

  const ProductDetails({
    this.data,
    super.key,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _quantity = 1;
  int totalPrice = 0;
  bool isFavorite = false;
  late int quantityvalue;
  late int packsize;
  late int totalquantity;
  late int medicinquantity;

  bool isItemInCart() {
    final cartProvider = Provider.of<CartProvider>(context);
    return cartProvider.cartItems
        .any((cartItem) => cartItem.product == widget.data);
  }

  final String favoriteKey = 'favorite_products';

  void _incrementQuantity() {
    if (_quantity < totalquantity)
      setState(() {
        _quantity++;
      });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  DatabaseOrah dbhelper = DatabaseOrah();

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    double apiValue;
    int _productmrppack;

    if (widget.data!['product_mrp_pack'] != null) {
      // If 'product_mrp_pack' is not null, parse its value and round to double
      apiValue = double.parse(widget.data!['product_mrp_pack']).roundToDouble();
      _productmrppack = apiValue.toInt();
    } else {
      // If 'product_mrp_pack' is null, calculate product_mrp * pack_size
      if (widget.data!['product_mrp'] != null &&
          widget.data!['pack_size'] != null) {
        double productMRP = double.parse(widget.data!['product_mrp']);
        int packSize = int.parse(widget.data!['pack_size']);
        _productmrppack = (productMRP * packSize).toInt();
      } else {
        // Handle the case where either 'product_mrp' or 'pack_size' is null
        _productmrppack = 0; // or perform a fallback calculation
      }
    }

    double _purchasequantity = double.parse(widget.data!['purchase_quantity']);
    quantityvalue = _purchasequantity.toInt();
    double _packsize = double.parse(widget.data!['pack_size']);
    packsize = _packsize.toInt();

    double api2Value = double.parse(widget.data!['Discount']);
    int discount = api2Value.toInt();

    double discountedPrice =
        _productmrppack - (_productmrppack * discount / 100);
    int AfterdiscountPrice = discountedPrice.roundToDouble().toInt();

    double result = quantityvalue / packsize;
    totalquantity = result.toInt();
    medicinquantity = _quantity * packsize;

    int amountSaved = _productmrppack - AfterdiscountPrice;
    print('Amount Saved: $amountSaved');
    print('quantity value: $quantityvalue');
    print('hello');

    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //image and appbar
            Expanded(
              flex: 2,
              child: ClipPath(
                clipper: CurveImage(),
                child: Container(
                  color: Colors.grey.shade100,
                  child: Column(
                    children: [
                      //App bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded),
                            ),
                            Flexible(
                              child: Text(
                                "Product Details",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Consumer<CartProvider>(
                              builder: (context, cartProvider, child) {
                                final cartItemsCount =
                                    cartProvider.cartItems.length;
                                return Badge(
                                  offset: Offset(-3, 5),
                                  label: Text(cartItemsCount.toString()),
                                  backgroundColor: MyColor.lightblue,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 28,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(
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
                      CachedNetworkImage(
                        height: mq.height * 0.24,
                        width: mq.width * 0.6,
                        imageUrl:
                            Global.imageUrl + widget.data!['product_image'],
                        placeholder: (context, url) =>
                            CircularProgressIndicator(), // Placeholder widget while loading
                        errorWidget: (context, url, error) => Icon(
                            Icons.error), // Widget to show in case of error
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // bosy Name Price Counter add to cart
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //category & discount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Category
                          Text("${widget.data!['category']}"),

                          //discout
                          discount == 0
                              ? Container()
                              : CustomContainer(
                                  sizeHeight: mq.height * 0.044,
                                  sizeWidth: mq.width * 0.2,
                                  color: Colors.green,
                                  radius: 24,
                                  child: Center(
                                    child: Text(
                                      "${discount}% Off",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(height: mq.height * 0.02),

                      //Name
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "${widget.data!['product_name']}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: mq.height * 0.01),

                      //Brand & Quantity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Brand: ${widget.data!['brand']}"),
                          Text("Quantity: $totalquantity"),
                        ],
                      ),
                      SizedBox(height: mq.height * 0.02),

                      //Counter & Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Counter
                          totalquantity == 0
                              ? Text(
                                  "Out of Stock",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.red),
                                )
                              : CustomContainer(
                                  sizeWidth: 120,
                                  sizeHeight: 40,
                                  color: Colors.transparent,
                                  border: Border.all(),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove_rounded,
                                          color: MyColor.darkblue,
                                        ),
                                        onPressed: _decrementQuantity,
                                      ),
                                      Text(
                                        '$_quantity',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add_rounded,
                                          color: MyColor.darkblue,
                                        ),
                                        onPressed: _incrementQuantity,
                                      ),
                                    ],
                                  ),
                                ),

                          //Price
                          Row(
                            children: [
                              Text(
                                "Rs: $AfterdiscountPrice",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: mq.width * 0.02,
                              ),
                              discount == 0
                                  ? Container()
                                  : Text(
                                      "$_productmrppack",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                    )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: mq.height * 0.02),

                      //Product Description
                      Text(
                        widget.data['product_description'],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //Add to catt & favourite
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: SizedBox(
                height: 65,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(MyColor.darkblue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: totalquantity == 0
                      ? null
                      : isItemInCart()
                          ? () {
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShoppingCart(),
                                  ));
                            }
                          : () {
                              FocusScope.of(context).unfocus();

                              final cartProvider = Provider.of<CartProvider>(
                                  context,
                                  listen: false);

                              dbhelper
                                  .insertData(widget.data['product_id'])
                                  .then((value) {
                                //
                                for (int i = 0; i < _quantity; i++) {
                                  cartProvider.addToCart(
                                      widget.data, totalquantity);
                                }
                                //
                                // checkIfProductInCart();
                                FlushBar.flushbarmessagegreen(
                                  message: 'Product Added in Cart',
                                  context: context,
                                );
                                //
                              }).onError((error, stackTrace) {
                                print('Error ${error.toString()}');
                                FlushBar.flushBarMessage(
                                  message: 'Product already added',
                                  context: context,
                                );
                              });
                            },
                  child: Text(
                    totalquantity == 0
                        ? 'Out of Stock'
                        : isItemInCart()
                            ? 'View in Cart'
                            : 'Add to Cart',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CurveImage extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 30);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
