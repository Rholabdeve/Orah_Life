import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/screen/login%20&%20Register%20&%20forgot/loginselection.dart';
import 'package:orah_pharmacy/screen/order%20tracking/order_details.dart';
import 'package:orah_pharmacy/services/api.dart';
import 'package:orah_pharmacy/widget/custom_appbar.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderTracking extends StatefulWidget {
  const OrderTracking({super.key});

  @override
  State<OrderTracking> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking>
    with SingleTickerProviderStateMixin {
  //
  @override
  void initState() {
    getdata();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  List history = [];

  late TabController _tabController;
  var loginid;
  var username;
  var email;
  var phone;

  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loginid = prefs.getString('login_id');
      username = prefs.getString('username');
      email = prefs.getString('email');
      phone = prefs.getString('phone');
    });
    getHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Future getHistory() async {
  //   var apiUrl =
  //       'https://orah.distrho.com/api/mobileapp/orders/order_historyorah';
  //   final response = await http.post(Uri.parse(apiUrl), headers: {
  //     "Accept": "application/json",
  //     "Content-Type": "application/x-www-form-urlencoded"
  //   }, body: {
  //     "secret_key": "jfds3=jsldf38&r923m-cjowscdlsdfi03",
  //     "customer_id": loginid,
  //   });

  //   final res = json.decode(response.body);
  //   if (res['code_status'] == true) {
  //     setState(() {
  //       history = res['nested_json'];
  //     });

  //     print(history);
  //   }
  // }

  Future getHistory() async {
    var res = await Api.orderHistory1(loginid);
    if (res['code_status'] == true) {
      setState(
        () {
          history = res['nested_json'];
        },
      );
      print("Respone arha hai bhai $res");
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColor.darkblue,
        body: Column(
          children: [
            //appbar
            Customappbar(),

            //TabBar
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: mq.height * 0.02,
                        horizontal: mq.width * 0.03,
                      ),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(
                            25.0,
                          ),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              25.0,
                            ),
                            color: MyColor.darkblue,
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: [
                            Tab(
                              text: 'Pending',
                            ),
                            Tab(
                              text: 'Complete',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          // First tab bar view widget (Place Bid)
                          _pending(),

                          // Second tab bar view widget (Buy Now)
                          _complete(),
                        ],
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

  Widget _pending() {
    var mq = MediaQuery.of(context).size;
    List pendingDeliveries = history
        .where((data) =>
            data['delivery_status'] == 'pending' ||
            data['delivery_status'] == 'dispatch')
        .toList();
    return loginid == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please Login\n if you want to see your orders',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: mq.height * 0.02),
              CustomButton(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginSelection(),
                      ),
                    );
                  },
                  buttonText: 'Login',
                  sizeWidth: mq.width * 0.35)
            ],
          )
        : history.isEmpty
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/order_tracking.json',
                        height: 250,
                      ),
                      Text(
                        'No Order Avaliable',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Check back after you\nplace a order!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                      SizedBox(height: 18),
                    ]),
              )
            : RefreshIndicator(
                color: MyColor.darkblue,
                onRefresh: () async {
                  setState(() {});
                  return getHistory();
                },
                child: ListView.builder(
                  itemCount: pendingDeliveries.length,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: mq.width * 0.03),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          print("Ubaid khan ${pendingDeliveries.length}");
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => OrderDetails(
                                data: pendingDeliveries[index],
                                getlength: pendingDeliveries.length,
                              ),
                            ),
                          );
                        },
                        child: GroupedItemCard(
                          refNo: pendingDeliveries[index]['reference_no'],
                          deliverystatus: pendingDeliveries[index]
                              ['delivery_status'],
                          createdAt: DateFormat("dd/MM/yyyy").format(
                            DateTime.parse(
                              pendingDeliveries[index]['created_at'],
                            ),
                          ),
                          itemCount: pendingDeliveries[index]['total_items'],
                        ));
                  },
                ),
              );
  }

  Widget _complete() {
    var mq = MediaQuery.of(context).size;
    List deliveredDeliveries = history
        .where((data) =>
            data['delivery_status'] == 'delivered' ||
            data['delivery_status'] == 'cancel')
        .toList();
    return loginid == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please Login\n if you want to see your orders',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: mq.height * 0.02),
              CustomButton(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginSelection(),
                      ),
                    );
                  },
                  buttonText: 'Login',
                  sizeWidth: mq.width * 0.35)
            ],
          )
        : history.isEmpty
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/order_tracking.json',
                        height: 250,
                      ),
                      Text(
                        'No Order Avaliable',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Check back after you\nplace a order!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                      SizedBox(height: 18),
                    ]),
              )
            : RefreshIndicator(
                color: MyColor.darkblue,
                onRefresh: () {
                  setState(() {});
                  return getHistory();
                },
                child: ListView.builder(
                  itemCount: deliveredDeliveries.length,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: mq.width * 0.03),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => OrderDetails(
                              data: deliveredDeliveries[index],
                            ),
                          ),
                        );
                      },
                      child: GroupedItemCard(
                        refNo: deliveredDeliveries[index]['reference_no'],
                        deliverystatus: deliveredDeliveries[index]
                            ['delivery_status'],
                        createdAt: DateFormat("dd/MM/yyyy").format(
                          DateTime.parse(
                            deliveredDeliveries[index]['created_at'],
                          ),
                        ),
                        itemCount: deliveredDeliveries[index]['total_items'],
                      ),
                    );
                  },
                ),
              );
  }
}

class GroupedItemCard extends StatelessWidget {
  final String refNo;
  final String deliverystatus;
  final String createdAt;
  final int itemCount;

  GroupedItemCard({
    required this.refNo,
    required this.deliverystatus,
    required this.createdAt,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var mq = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      height: 150,
      // height: mq.height * 0.21,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: Offset(2, 4),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 210,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Order# $refNo',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Date: $createdAt'),
                  SizedBox(height: 4),
                  Text("Total Products: $itemCount ")
                ],
              ),
            ),
            if (deliverystatus == "pending")
              Container(
                height: 100,
                width: 100,
                // height: mq.height * 0.22,
                // width: mq.width * 0.30,
                child: Lottie.asset('assets/lottie/pending.json'),
              ),
            if (deliverystatus == "dispatch")
              Container(
                height: 100,
                width: 100,
                child: Lottie.asset('assets/lottie/theway.json'),
              ),
            if (deliverystatus == "delivered")
              Container(
                height: 100,
                width: 100,
                child: Lottie.asset(
                  'assets/lottie/delivered.json',
                ),
              ),
            if (deliverystatus == "cancel")
              Container(
                height: 100,
                width: 100,
                child: Lottie.asset(
                  'assets/lottie/cancel.json',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
