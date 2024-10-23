import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:orah_pharmacy/Database%20Orah/database_orah.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/provider/cart_provider.dart';
import 'package:orah_pharmacy/screen/explore_more/explore_more.dart';
import 'package:orah_pharmacy/screen/product_detail/product_details.dart';
import 'package:orah_pharmacy/screen/search/productsearch2.dart';
import 'package:orah_pharmacy/services/api.dart';
import 'package:orah_pharmacy/services/global.dart';
import 'package:orah_pharmacy/widget/custom_appbar.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:orah_pharmacy/widget/custom_container.dart';
import 'package:orah_pharmacy/widget/custom_textfield.dart';
import 'package:orah_pharmacy/widget/custom_card.dart';
import 'package:orah_pharmacy/widget/flushbar.dart';
import 'package:orah_pharmacy/widget/shimmer/home_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

import 'categories/categories.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static int currentIndex = 0;
  int activeIndex = 0;
  var categories = [];
  // ignore: unused_field
  int _quantity = 1;
  List product = [];
  List filteredMedicines = [];
  List filteredPersonalCare = [];
  List filteredVitamins = [];
  List filtereHealthCare = [];
  List filteredBabyCare = [];
  List cart = [];
  late int quantityvalue;
  late int packsize;
  late int totalquantity;
  late int medicinquantity;
  List filter = [];
  bool isLoading = true;
  bool isLoading1 = true;
  late Timer _timer;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Api.getBanners();
    _startTimer();
    fetchproduct().then(
      (value) {
        setState(
          () {
            filteredMedicines = product
                .where((data) =>
                    data['category'] == 'MEDICINE' &&
                    data['purchase_quantity'] != '0.0000')
                .toList();

            filteredMedicines.sort((a, b) {
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

            filtereHealthCare = product
                .where((data) =>
                    data['category'] == 'HEALTH CARE EQUIPMENTS' &&
                    data['purchase_quantity'] != '0.0000')
                .toList();

            print('Health Care $filtereHealthCare');

            filtereHealthCare.sort((a, b) {
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
            //filter product..................................................

            filteredPersonalCare = product
                .where((data) =>
                    data['category'] == 'PERSONAL CARE' &&
                    data['purchase_quantity'] != '0.0000')
                .toList();

            filteredPersonalCare.sort((a, b) {
              if (a['product_image'] == 'no_image.png' &&
                  b['product_image'] != 'no_image.png') {
                return 1; // 'no_image.png' should come after other images
              } else if (a['product_image'] != 'no_image.png' &&
                  b['product_image'] == 'no_image.png') {
                return -1; // Other images should come before 'no_image.png'
              } else {
                return 0; // No change in order if both have the same image
              }
            });

            filteredVitamins = product
                .where((data) =>
                    data['category'] == 'NUTRIMENTS' &&
                    data['purchase_quantity'] != '0.0000')
                .toList();
            filteredVitamins.sort((a, b) {
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

            filteredBabyCare = product
                .where((data) =>
                    data['category'] == 'BABY CARE' &&
                    data['purchase_quantity'] != '0.0000')
                .toList();
            filteredBabyCare.sort((a, b) {
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
          },
        );
      },
    );
    fetchCategory();
    fetchBanners();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (banners.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % banners.length;
      });
    });
  }

  List<dynamic> banners = [];
  Future<void> fetchBanners() async {
    try {
      var response = await Api.getBanners();
      if (response['banner_url'] != null) {
        setState(() {
          banners = response['banner_url'];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching banners: $e');
      isLoading = false;
    }
  }

  Future fetchproduct() async {
    var res = await Api.getProducts("");
    if (res['code_status'] == true) {
      setState(() {
        product = res['products'].where((p) {
          return p['product_mrp_pack'] != null || p['product_mrp'] != null;
        }).toList();

        filter = product;
        isLoading = false;
      });
      print('Products $product');
    }
  }

  Future fetchCategory() async {
    var res = await Api.getCategories();
    if (res['code_status'] == true) {
      setState(() {
        categories = res['categories']
            .where((category) => category['name'] != 'health supplement')
            .toList();

        // print('Categories ${categories[9]['name']}');
        // print('Categories ${categories[9]['name']}');
        isLoading1 = false;
      });
    }
  }

  openwhatsapp() {
    return launchUrl(
      Uri.parse('https://wa.me/+923331116724'),
    );
  }

  bool isItemInCart() {
    final cartProvider = Provider.of<CartProvider>(context);
    return cartProvider.cartItems
        .any((cartItem) => cartItem.product == product);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // ignore: unused_local_variable
    List<Map<String, dynamic>> categoriesSlider = [
      {'medicine': filteredBabyCare, 'title': 'Baby Care'},
      {'medicine': filteredMedicines, 'title': 'Medicines'},
      {'medicine': filteredPersonalCare, 'title': 'Personal Care'},
    ];

    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog(context);
      },
      child: SafeArea(
        child: UpgradeAlert(
          dialogStyle: UpgradeDialogStyle.cupertino,
          child: Scaffold(
            backgroundColor: MyColor.darkblue,
            body: Column(
              children: [
                // app bar cart and icon
                const Customappbar(),

                //Body
                // isLoading
                //     ? Homeshimmer()
                //     :
                isLoading1
                    ? Homeshimmer()
                    : Expanded(
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
                              vertical: mq.height * 0.03,
                            ),
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Search bar
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: mq.width * 0.04,
                                    ),
                                    child: CustomTextField(
                                      readonly: true,
                                      prefixIcon: const Icon(
                                        FeatherIcons.search,
                                        color: Colors.black,
                                      ),
                                      hintText: "Search Medicines & Products",
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      onTap: () {
                                        showModalBottomSheet(
                                          backgroundColor: Colors.white,
                                          isScrollControlled: true,
                                          shape: const BeveledRectangleBorder(),
                                          useSafeArea: true,
                                          context: context,
                                          builder: (context) {
                                            return FractionallySizedBox(
                                              heightFactor: 1,
                                              child: ProductSearch2(
                                                product_list: product,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: mq.height * 0.03),

                                  //Slider
                                  isLoading
                                      ? Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            margin: const EdgeInsets.all(10.0),
                                            width: double.infinity,
                                            height: 180,
                                            color: Colors.white,
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            // Ensure `dailyCategories` is not empty
                                            if (currentIndex == 1) {
                                              print('Baby Care');
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ExploreMore(
                                                    medicine: filteredBabyCare,
                                                    title: 'BABY CARE',
                                                  ),
                                                ),
                                              );
                                            } else if (currentIndex == 2) {
                                              print('Medicine');
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ExploreMore(
                                                    medicine: filteredMedicines,
                                                    title: 'MEDICINE',
                                                  ),
                                                ),
                                              );
                                            } else if (currentIndex == 3) {
                                              print('Personal Care');
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ExploreMore(
                                                    medicine:
                                                        filteredPersonalCare,
                                                    title: 'PERSONAL CARE',
                                                  ),
                                                ),
                                              );
                                            } else if (currentIndex == 4) {
                                              print('Health Care');
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ExploreMore(
                                                    medicine: filtereHealthCare,
                                                    title:
                                                        'HEALTHCARE EQUIPMENTS',
                                                  ),
                                                ),
                                              );
                                              print(filtereHealthCare);
                                            } else {
                                              print('Not Click');
                                            }
                                          },

                                          //     // if (currentIndex >= 0 &&
                                          //     //     currentIndex < categoriesslider.length) {
                                          //     //   Navigator.of(context, rootNavigator: true)
                                          //     //       .push(
                                          //     //     MaterialPageRoute(
                                          //     //       builder: (context) => ExploreMore(
                                          //     //         medicine:
                                          //     //             categoriesslider[currentIndex]
                                          //     //                 ['medicine'],
                                          //     //         title: categoriesslider[currentIndex]
                                          //     //             ['title'],
                                          //     //       ),
                                          //     //     ),
                                          //     //   );
                                          //     // } else {
                                          //     //   print(4);
                                          //     // }
                                          // },
                                          child: CarouselSlider.builder(
                                            itemCount: banners.length,
                                            itemBuilder:
                                                (context, index, realIndex) {
                                              return Container(
                                                width: double.infinity,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: banners[index],
                                                  fit: BoxFit.fill,
                                                  placeholder: (context, url) =>
                                                      Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[300]!,
                                                    highlightColor:
                                                        Colors.grey[100]!,
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 180,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              );
                                            },
                                            options: CarouselOptions(
                                              autoPlayCurve:
                                                  Curves.fastOutSlowIn,
                                              enlargeCenterPage: true,
                                              autoPlay: true,
                                              viewportFraction: 0.90,
                                              clipBehavior: Clip.antiAlias,
                                              height: 180,
                                              onPageChanged: (index, reason) {
                                                setState(() {
                                                  currentIndex = index;
                                                  print(
                                                      'Current Index $currentIndex');
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                  SizedBox(height: mq.height * 0.03),

                                  //category
                                  SizedBox(
                                    height: mq.height * 0.58,
                                    child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        childAspectRatio: mq.aspectRatio / 0.68,
                                      ),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: categories.length,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: mq.width * 0.04),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            print(categories[index]['id']);
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Categories(
                                                  category: categories[index]
                                                      ['name'],
                                                  category_id: categories[index]
                                                      ['id'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 110,
                                                width: 120,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Image.network(
                                                    "${Global.imageUrl + categories[index]['image']}",
                                                    cacheHeight: 100,
                                                    cacheWidth: 100,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: mq.height * 0.01,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  categories[index]['name'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  //Upload Prescription
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: mq.width * 0.04),
                                    child: GestureDetector(
                                      onTap: () {
                                        openwhatsapp();
                                      },
                                      child: CustomContainer(
                                        color: Colors.white,
                                        clipBehavior: Clip.antiAlias,
                                        sizeHeight: mq.height * 0.18,
                                        sizeWidth:
                                            MediaQuery.of(context).size.width,
                                        child: Image.asset(
                                          'assets/images/whatapp.png',
                                          // fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: mq.height * 0.02),

                                  //Medicines & Listview
                                  ProductHeading(
                                    label: 'Medicine',
                                    ontap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (context) => ExploreMore(
                                            medicine: filteredMedicines,
                                            title: 'Medicines',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: mq.height * 0.01),

                                  SizedBox(
                                    height: 260,
                                    // height: mq.height * 0.39,
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        width: mq.width * 0.04,
                                      ),
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount:
                                          filteredMedicines.length.clamp(0, 10),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      itemBuilder: (context, index) {
                                        double apiValue = double.parse(
                                                filteredMedicines[index]
                                                    ['product_mrp_pack'])
                                            .roundToDouble();
                                        int integerValue = apiValue.toInt();

                                        double api1Value = double.parse(
                                            filteredMedicines[index]
                                                ['purchase_quantity']);
                                        int purchasequantity =
                                            api1Value.toInt();

                                        double api2Value = double.parse(
                                            filteredMedicines[index]
                                                ['Discount']);
                                        int discount = api2Value.toInt();

                                        double _packsize = double.parse(
                                            filteredMedicines[index]
                                                ['pack_size']);
                                        int packsize = _packsize.toInt();

                                        int checkquantity = purchasequantity;

                                        double result =
                                            purchasequantity / packsize;
                                        int totalquantity = result.toInt();

                                        double discountedPrice = integerValue -
                                            (integerValue * discount / 100);
                                        int AfterdiscountPrice = discountedPrice
                                            .roundToDouble()
                                            .toInt();

                                        return totalquantity == 0
                                            ? SizedBox()
                                            : CustomCard(
                                                image: filteredMedicines[index]
                                                    ['product_image'],
                                                name:
                                                    "${filteredMedicines[index]['product_name']}",
                                                price: "$AfterdiscountPrice",
                                                product_mrps: "$integerValue",
                                                discount: discount,
                                                onTap: () {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetails(
                                                        data: filteredMedicines[
                                                            index],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                //add cart
                                                child: totalquantity == 0
                                                    ? SizedBox()
                                                    : CustomButton(
                                                        onTap:
                                                            totalquantity == 0
                                                                ? () {
                                                                    print(
                                                                        " check quantity ${checkquantity}");
                                                                    FlushBar.flushBarMessage(
                                                                        message:
                                                                            'Out of Stock',
                                                                        context:
                                                                            context);
                                                                  }
                                                                : () {
                                                                    dbhelper
                                                                        .insertData(filteredMedicines[index]
                                                                            [
                                                                            'product_id'])
                                                                        .then(
                                                                            (value) {
                                                                      //
                                                                      cartProvider.addToCart(
                                                                          filteredMedicines[
                                                                              index],
                                                                          totalquantity);
                                                                      //
                                                                      dbhelper
                                                                          .readData();
                                                                      FlushBar
                                                                          .flushbarmessagegreen(
                                                                        message:
                                                                            'Item Added',
                                                                        context:
                                                                            context,
                                                                      );
                                                                      //
                                                                    }).onError((error,
                                                                            stackTrace) {
                                                                      print(
                                                                          'Error ${error.toString()}');
                                                                      FlushBar
                                                                          .flushBarMessage(
                                                                        message:
                                                                            'Item already added',
                                                                        context:
                                                                            context,
                                                                      );
                                                                    });
                                                                  },
                                                        buttonText:
                                                            "${totalquantity == 0 ? 'Out of Stock' : 'Add to Cart'}",
                                                        sizeWidth:
                                                            double.infinity,
                                                        sizeHeight: 40,
                                                        boderRadius: 30,
                                                        buttontextsize: 12,
                                                        buttonColor:
                                                            totalquantity == 0
                                                                ? Colors.red
                                                                : MyColor
                                                                    .darkblue,
                                                      ),
                                              );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: mq.height * 0.02),

                                  //Personal Care &  Listview
                                  ProductHeading(
                                      label: 'Personal Care',
                                      ontap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) => ExploreMore(
                                              medicine: filteredPersonalCare,
                                              title: 'Personal Care',
                                            ),
                                          ),
                                        );
                                      }),
                                  SizedBox(height: mq.height * 0.01),

                                  SizedBox(
                                    height: 260,
                                    //  height: mq.height * 0.39,
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        width: mq.width * 0.04,
                                      ),
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: filteredPersonalCare.length
                                          .clamp(0, 10),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      itemBuilder: (context, index) {
                                        double apiValue = double.parse(
                                                filteredPersonalCare[index]
                                                    ['product_mrp_pack'])
                                            .roundToDouble();
                                        int integerValue = apiValue.toInt();

                                        double api1Value = double.parse(
                                            filteredPersonalCare[index]
                                                ['purchase_quantity']);
                                        int purchasequantity =
                                            api1Value.toInt();
                                        double api2Value = double.parse(
                                            filteredPersonalCare[index]
                                                ['Discount']);

                                        int discount = api2Value.toInt();

                                        double _packsize = double.parse(
                                            filteredPersonalCare[index]
                                                ['pack_size']);
                                        int packsize = _packsize.toInt();

                                        double result =
                                            purchasequantity / packsize;
                                        int totalquantity = result.toInt();

                                        double discountedPrice = integerValue -
                                            (integerValue * discount / 100);
                                        int AfterdiscountPrice = discountedPrice
                                            .roundToDouble()
                                            .toInt();
                                        return CustomCard(
                                          onTap: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetails(
                                                  data: filteredPersonalCare[
                                                      index],
                                                ),
                                              ),
                                            );
                                          },
                                          image: filteredPersonalCare[index]
                                              ['product_image'],
                                          name:
                                              "${filteredPersonalCare[index]['product_name']}",
                                          price: "$AfterdiscountPrice",
                                          product_mrps: "${integerValue}",
                                          discount: discount,
                                          child: CustomButton(
                                            onTap: totalquantity == 0
                                                ? () {
                                                    FlushBar.flushBarMessage(
                                                        message: 'Out of Stock',
                                                        context: context);
                                                  }
                                                : () {
                                                    dbhelper
                                                        .insertData(
                                                            filteredPersonalCare[
                                                                    index]
                                                                ['product_id'])
                                                        .then((value) {
                                                      //
                                                      cartProvider.addToCart(
                                                          filteredPersonalCare[
                                                              index],
                                                          totalquantity);
                                                      //
                                                      dbhelper.readData();
                                                      FlushBar
                                                          .flushbarmessagegreen(
                                                        message: 'Item Added',
                                                        context: context,
                                                      );
                                                      //
                                                    }).onError((error,
                                                            stackTrace) {
                                                      print(
                                                          'Error ${error.toString()}');
                                                      FlushBar.flushBarMessage(
                                                        message:
                                                            'Item already added',
                                                        context: context,
                                                      );
                                                    });
                                                  },
                                            buttonText:
                                                "${totalquantity == 0 ? 'Out of Stock' : 'Add to Cart'}",
                                            sizeWidth: double.infinity,
                                            sizeHeight: 40,
                                            //  sizeHeight: mq.height * 0.055,
                                            boderRadius: 30,
                                            buttontextsize: 12,
                                            buttonColor: totalquantity == 0
                                                ? Colors.red
                                                : MyColor.darkblue,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: mq.height * 0.02),

                                  //Vitamines & ListView
                                  ProductHeading(
                                      label: 'Vitamins',
                                      ontap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) => ExploreMore(
                                              medicine: filteredVitamins,
                                              title: 'vitamins',
                                            ),
                                          ),
                                        );
                                      }),
                                  SizedBox(height: mq.height * 0.01),

                                  SizedBox(
                                    height: 260,
                                    //  height: mq.height * 0.39,
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        width: mq.width * 0.04,
                                      ),
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount:
                                          filteredVitamins.length.clamp(0, 10),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      itemBuilder: (context, index) {
                                        double apiValue = double.parse(
                                                filteredVitamins[index]
                                                    ['product_mrp_pack'])
                                            .roundToDouble();
                                        int integerValue = apiValue.toInt();

                                        double api1Value = double.parse(
                                            filteredVitamins[index]
                                                ['purchase_quantity']);
                                        int purchasequantity =
                                            api1Value.toInt();

                                        double api2Value = double.parse(
                                            filteredVitamins[index]
                                                ['Discount']);
                                        int discount = api2Value.toInt();

                                        double _packsize = double.parse(
                                            filteredVitamins[index]
                                                ['pack_size']);
                                        int packsize = _packsize.toInt();

                                        double discountedPrice = integerValue -
                                            (integerValue * discount / 100);
                                        int AfterdiscountPrice = discountedPrice
                                            .roundToDouble()
                                            .toInt();

                                        double result =
                                            purchasequantity / packsize;
                                        int totalquantity = result.toInt();
                                        return CustomCard(
                                          onTap: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetails(
                                                  data: filteredVitamins[index],
                                                ),
                                              ),
                                            );
                                          },
                                          image: filteredVitamins[index]
                                              ['product_image'],
                                          name:
                                              "${filteredVitamins[index]['product_name']}",
                                          price: "$AfterdiscountPrice",
                                          product_mrps: "${integerValue}",
                                          discount: discount,
                                          child: CustomButton(
                                            onTap: totalquantity == 0
                                                ? () {
                                                    FlushBar.flushBarMessage(
                                                        message: 'Out of Stock',
                                                        context: context);
                                                  }
                                                : () {
                                                    dbhelper
                                                        .insertData(
                                                            filteredVitamins[
                                                                    index]
                                                                ['product_id'])
                                                        .then((value) {
                                                      //
                                                      cartProvider.addToCart(
                                                          filteredVitamins[
                                                              index],
                                                          totalquantity);
                                                      //
                                                      dbhelper.readData();
                                                      FlushBar
                                                          .flushbarmessagegreen(
                                                        message: 'Item Added',
                                                        context: context,
                                                      );
                                                      //
                                                    }).onError((error,
                                                            stackTrace) {
                                                      print(
                                                          'Error ${error.toString()}');
                                                      FlushBar.flushBarMessage(
                                                        message:
                                                            'Item already added',
                                                        context: context,
                                                      );
                                                    });
                                                  },
                                            buttonText:
                                                "${totalquantity == 0 ? 'Out of Stock' : 'Add to Cart'}",
                                            sizeWidth: double.infinity,
                                            // sizeHeight: mq.height * 0.055,
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
                                  ),
                                  SizedBox(height: mq.height * 0.02),

                                  //babycare & ListView
                                  ProductHeading(
                                      label: 'Baby Care',
                                      ontap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) => ExploreMore(
                                              medicine: filteredBabyCare,
                                              title: 'Baby Care',
                                            ),
                                          ),
                                        );
                                      }),
                                  SizedBox(height: mq.height * 0.01),

                                  SizedBox(
                                    height: 260,
                                    //  height: mq.height * 0.39,
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        width: mq.width * 0.04,
                                      ),
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount:
                                          filteredBabyCare.length.clamp(0, 10),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      itemBuilder: (context, index) {
                                        double apiValue = double.parse(
                                                filteredBabyCare[index]
                                                    ['product_mrp_pack'])
                                            .roundToDouble();
                                        int integerValue = apiValue.toInt();

                                        double api1Value = double.parse(
                                            filteredBabyCare[index]
                                                ['purchase_quantity']);
                                        int purchasequantity =
                                            api1Value.toInt();

                                        double _packsize = double.parse(
                                            filteredBabyCare[index]
                                                ['pack_size']);
                                        int packsize = _packsize.toInt();

                                        double api2Value = double.parse(
                                            filteredBabyCare[index]
                                                ['Discount']);
                                        int discount = api2Value.toInt();

                                        double discountedPrice = integerValue -
                                            (integerValue * discount / 100);
                                        int AfterdiscountPrice = discountedPrice
                                            .roundToDouble()
                                            .toInt();

                                        double result =
                                            purchasequantity / packsize;
                                        int totalquantity = result.toInt();
                                        return CustomCard(
                                          onTap: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetails(
                                                  data: filteredBabyCare[index],
                                                ),
                                              ),
                                            );
                                          },
                                          image: filteredBabyCare[index]
                                              ['product_image'],
                                          name:
                                              "${filteredBabyCare[index]['product_name']}",
                                          price: "$AfterdiscountPrice",
                                          product_mrps: "${integerValue}",
                                          discount: discount,
                                          child: CustomButton(
                                            onTap: totalquantity == 0
                                                ? () {
                                                    FlushBar.flushBarMessage(
                                                        message: 'Out of Stock',
                                                        context: context);
                                                  }
                                                : () {
                                                    dbhelper
                                                        .insertData(
                                                            filteredBabyCare[
                                                                    index]
                                                                ['product_id'])
                                                        .then((value) {
                                                      //
                                                      cartProvider.addToCart(
                                                          filteredBabyCare[
                                                              index],
                                                          totalquantity);
                                                      //
                                                      dbhelper.readData();
                                                      FlushBar
                                                          .flushbarmessagegreen(
                                                        message: 'Item Added',
                                                        context: context,
                                                      );
                                                      //
                                                    }).onError((error,
                                                            stackTrace) {
                                                      print(
                                                          'Error ${error.toString()}');
                                                      FlushBar.flushBarMessage(
                                                        message:
                                                            'Item already added',
                                                        context: context,
                                                      );
                                                    });
                                                  },
                                            buttonText:
                                                "${totalquantity == 0 ? 'Out of Stock' : 'Add to Cart'}",
                                            sizeWidth: double.infinity,
                                            sizeHeight: 40,
                                            // sizeHeight: mq.height * 0.055,
                                            boderRadius: 30,
                                            buttontextsize: 12,
                                            buttonColor: totalquantity == 0
                                                ? Colors.red
                                                : MyColor.darkblue,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: mq.height * 0.02),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Exit'),
            content: Text('Do you really want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}

// ignore: must_be_immutable
class ProductHeading extends StatefulWidget {
  String label;
  VoidCallback ontap;
  ProductHeading({super.key, required this.label, required this.ontap});

  @override
  State<ProductHeading> createState() => _ProductHeadingState();
}

DatabaseOrah dbhelper = DatabaseOrah();

class _ProductHeadingState extends State<ProductHeading> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              widget.label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          TextButton(
            style: ButtonStyle(
              side: MaterialStateProperty.all<BorderSide>(
                BorderSide(color: MyColor.darkblue, width: 1),
              ),
            ),
            onPressed: widget.ontap,
            child: const Text(
              "Explore More",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
