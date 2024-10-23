import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/provider/cart_provider.dart';
import 'package:orah_pharmacy/screen/cart/cart.dart';
import 'package:provider/provider.dart';

class Customappbar extends StatefulWidget {
  const Customappbar({super.key});

  @override
  State<Customappbar> createState() => _CustomappbarState();
}

String address = "";
String address1 = "";

class _CustomappbarState extends State<Customappbar> {
  @override
  void initState() {
    //_getGeoLocationPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.04, vertical: mq.height * 0.02),
      child: Row(
        children: [
          // GestureDetector(
          //   onTap: () {},
          //   child: Icon(
          //     FeatherIcons.menu,
          //     color: Colors.white,
          //     size: 25,
          //   ),
          // ),
          // SizedBox(width: 10),
          Image.asset("assets/images/orah-logo-white.png", height: 44),
          // Icon(
          //   FeatherIcons.mapPin,
          //   color: Colors.white,
          //   size: 27,
          // ),
          // SizedBox(width: mq.width * 0.024),
          // GestureDetector(
          //   onTap: () async {
          //     await MapService.getLocation(context, () {
          //       setState(() {});
          //     });
          //   },
          //   child: SizedBox(
          //     width: mq.width * 0.58,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         if (Global.addressController.text.isEmpty)
          //           Text(
          //             '$address',
          //             maxLines: 2,
          //             overflow: TextOverflow.ellipsis,
          //             style: Theme.of(context)
          //                 .textTheme
          //                 .bodyLarge!
          //                 .copyWith(color: Colors.white),
          //           ),

          //         // Display addressController if it has data
          //         if (Global.addressController.text.isNotEmpty)
          //           Text(
          //             '${Global.addressController.text}',
          //             maxLines: 2,
          //             overflow: TextOverflow.ellipsis,
          //             style: Theme.of(context)
          //                 .textTheme
          //                 .bodyLarge!
          //                 .copyWith(color: Colors.white),
          //           ),
          //       ],
          //     ),
          //   ),
          // ),

          Spacer(),
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
                    size: 28,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => const ShoppingCart(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _getAddressFromLatLong(position);
  }

  Future<void> _getAddressFromLatLong(Position position) async {
    final placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    address =
        '${place.street},${place.locality}, ${place.administrativeArea}, ${place.country}';

    setState(() {});
  }
}
