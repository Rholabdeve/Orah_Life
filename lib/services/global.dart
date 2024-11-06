import 'package:flutter/material.dart';

class Global {
  // static var baseurl = "https://pos.orah.pk/api/mobileapp/";
  static var baseurl = "https://orah.distrho.com/api/mobileapp/";

  static var secretKey = "jfds3=jsldf38&r923m-cjowscdlsdfi03";
  // static var productlist = "${baseurl}products/lists";
  static var productList = "${baseurl}products/list_orahapp";
  static var setDeliveryCharges = "${baseurl}Autosalesorder/setDeliveryCharges";
  static var getCategories = "${baseurl}products/categories";
  static var createOrder = "${baseurl}salesorders/create";
  static var createOrder1 = "${baseurl}Autosalesorder/createso";
  static var orderHistory = "${baseurl}orders/order_history";
  static var orderHistory2 = "${baseurl}orders/order_historyorah";
  static var orderTracking = "${baseurl}orders/order_tracking";
  static var createCustomer = "${baseurl}customers/create";
  static var login = "${baseurl}auth/logincustomer";
  static var updateAddress = "${baseurl}customers/updateAddress";
  static var updatePassword = "${baseurl}customers/updatepassword";
  static var customersEmails = "${baseurl}customers/customerEmails";
  static var customerPhone = "${baseurl}customers/customerContact";
  static var UpdateProfile = "${baseurl}customers/updateProfile";
  static var smmAuthApi = "${baseurl}Auth/smsAPI";
  static var offer1111 = "${baseurl}/products/list_sale";
  static var getBanners = "https://www.orah.pk/api/sliderlistmob";

  // static var login = '${baseurl}auth/login';
  static var imageUrl = "https://orah.distrho.com/uploads/products/";

  static String? name;
  static String? street;
  static String? locality;
  static String? administrativeArea;
  static int medicinequantity = 0;
  static double? latitude;
  static double? longitude;

  static TextEditingController addressController = TextEditingController();

  static final sliderImage = [
    'assets/images/slider/slider1.jpeg',
    'assets/images/slider/slider3.jpeg',
    'assets/images/slider/slider4.jpeg',
    'assets/images/slider/slider2.jpeg',
    'assets/images/slider/slider5.jpeg',
    'assets/images/slider/slider6.jpeg',
  ];
}
