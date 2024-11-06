import 'dart:convert';
import 'package:http/http.dart' as http;
import 'global.dart';

class Api {
  static var secret = Global.secretKey;

  //get Product Api
  static Future getProducts(var category_id) async {
    var apiUrl = Global.productList;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "category": category_id,
    });

    final data = jsonDecode(response.body);
    return data;
  }

  static Future getCategories() async {
    var apiUrl = Global.getCategories;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      // "page": page,
      // "limit": limit,
      // "text": text,
      // "parent_id": parent_id,
    });
    final data = jsonDecode(response.body);
    return data;
  }

  static Future DeliveryChargesSet(
      var totalPrice, var address, var app_name) async {
    var apiUrl = Global.setDeliveryCharges;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "app_name": app_name,
      "total": totalPrice,
      "address": address,
    });
    final data = jsonDecode(response.body);

    return data;
  }

  static Future addOrder(
    String warehouse_id,
    String po_number,
    String po_date,
    String customer_id,
    String supplier_id,
    String user_id,
    String items,
    String payment_method,
  ) async {
    var apiUrl = Global.createOrder;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "warehouse_id": warehouse_id,
      "po_number": po_number,
      "po_date": po_date,
      "customer_id": customer_id,
      "supplier_id": supplier_id,
      "user_id": user_id,
      "items": items,
      "payment_method": payment_method,
    });

    final data = json.decode(response.body);
    print(data);
    return data;
  }

  static Future addOrder1(
      // String warehouse_id,
      String po_number,
      //String po_date,
      String customer_id,
      String supplier_id,
      //String user_id,
      String items,
      String payment_method,
      String delivery_charge) async {
    var apiUrl = Global.createOrder1;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      // "warehouse_id": warehouse_id,
      "po_number": po_number,
      //"po_date": po_date,
      "customer_id": customer_id,
      "supplier_id": supplier_id,
      //"user_id": user_id,
      "items": items,
      "payment_method": payment_method,
      "delivery_charge": delivery_charge,
    });

    final data = json.decode(response.body);
    print(data);
    print("ubaid$delivery_charge");
    print("ubaid$payment_method");
    print("ubaid$items");
    print("ubaid$supplier_id");
    print("ubaid$customer_id");
    print("ubaid$po_number");
    return data;
  }

  static Future orderHistory(String customer_id) async {
    var apiUrl = Global.orderHistory;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "customer_id": customer_id,
    });

    final data = json.decode(response.body);
    return data;
  }

  static Future orderHistory1(String customer_id) async {
    var apiUrl = Global.orderHistory2;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "customer_id": customer_id,
    });

    final data = json.decode(response.body);
    return data;
  }

  static Future login(
    String email,
    String password,
  ) async {
    var apiUrl = Global.login;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "email": email,
      "password": password,
    });
    final data = json.decode(response.body);

    return data;
  }

  static Future create_customer(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    var apiUrl = Global.createCustomer;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
    });
    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 10), () {
    return data;
    // });
  }

  static Future orderTracking(String customer_id) async {
    var apiUrl = Global.orderTracking;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "customer_id": customer_id,
    });

    final data = jsonDecode(response.body);
    return data;
  }

  static Future updateAddress(
    String customer_id,
    String address,
    String mapLink,
  ) async {
    var apiUrl = Global.updateAddress;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "id": customer_id,
      "address": address,
      "maplink": mapLink,
    });

    final data = json.decode(response.body);
    return data;
  }

  static Future updatePassword(String email, String password) async {
    var apiUrl = Global.updatePassword;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "email": email,
      "password": password,
    });

    final data = json.decode(response.body);
    return data;
  }

  static Future updateProfile(
      String id, String name, String email, String number) async {
    var apiUrl = Global.UpdateProfile;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "id": id,
      "name": name,
      "email": email,
      "phone": number,
    });

    final data = json.decode(response.body);
    return data;
  }

  static Future customersEmails({email}) async {
    var apiUrl = Global.customersEmails;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "email": email,
    });

    final data = json.decode(response.body);
    print(data);

    return data;
  }

  static Future customersPhone() async {
    var apiUrl = Global.customerPhone;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
    });

    final data = json.decode(response.body);
    return data;
  }

  static Future smsApi(
      String mobileNum, String message, String shortCode) async {
    var apiUrl = Global.smmAuthApi;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "*/*",
    }, body: {
      "secret_key": secret,
      "mobilenum": mobileNum,
      "message": message,
      "shortcode": shortCode,
    });

    final data = jsonDecode(response.body);
    return data;
  }

  static Future getBanners() async {
    var apiUrl = Global.getBanners;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
    });
    final data = jsonDecode(response.body);
    print("Banners ${data}");
    return data;
  }

  static Future offer1111() async {
    var apiUrl = Global.offer1111;
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
    });
    final data = jsonDecode(response.body);
    print("offer1111 ${data}");
    return data;
  }
}
