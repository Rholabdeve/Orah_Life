import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:orah_pharmacy/screen/account/account.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/screen/home/home.dart';

import '../screen/order tracking/order_tracking.dart';

// ignore: must_be_immutable
class NavBar extends StatefulWidget {
  NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List<Widget> _buildScreens() {
    return [
      const Home(),
      const OrderTracking(),
      // const Favorite(),
      const Account(),
    ];
  }

  PersistentTabController controller = PersistentTabController();

  @override
  void initState() {
    super.initState();
    controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      padding: const NavBarPadding.only(left: 0, right: 0),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: const NavBarDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0.2,
            blurRadius: 6,
          ),
        ],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style3,
      navBarHeight: 70,
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: const Icon(FeatherIcons.home),
          title: ("Home"),
          iconSize: 26,
          activeColorPrimary: MyColor.darkblue,
          inactiveColorPrimary: Colors.grey),
      PersistentBottomNavBarItem(
          icon: const Icon(FeatherIcons.package),
          title: ("Order History"),
          iconSize: 26,
          activeColorPrimary: MyColor.darkblue,
          inactiveColorPrimary: Colors.grey),
      // PersistentBottomNavBarItem(
      //     icon: const Icon(FeatherIcons.heart),
      //     title: ("Favorite"),
      //     iconSize: 26,
      //     activeColorPrimary: MyColor.darkblue,
      //     inactiveColorPrimary: Colors.grey),
      PersistentBottomNavBarItem(
          icon: const Icon(FeatherIcons.user),
          title: ("Account"),
          iconSize: 26,
          activeColorPrimary: MyColor.darkblue,
          inactiveColorPrimary: Colors.grey),
    ];
  }
}
