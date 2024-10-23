import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/helper/database.dart';
import 'package:orah_pharmacy/screen/account/sub_screen/address_form.dart';
import 'package:orah_pharmacy/widget/custom_container.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColor.darkblue,
        body: Column(
          children: [
            //App Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04,
                vertical: mq.height * 0.03,
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
                  Text(
                    'Address',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),

            //body
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
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: dbHelper.getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: MyColor.darkblue,
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text('No data available.'),
                      );
                    }

                    List<Map<String, dynamic>> userData = snapshot.data!;

                    return ListView.separated(
                      itemCount: userData.length,
                      padding: EdgeInsets.symmetric(
                        vertical: mq.height * 0.02,
                        horizontal: mq.width * 0.04,
                      ),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: mq.height * 0.02),
                      itemBuilder: (context, index) {
                        return CustomContainer(
                          color: Colors.white,
                          sizeHeight: mq.height * 0.17,
                          offset: Offset(2, 4),
                          shadowBlurRadius: 6,
                          shadowColor: Colors.grey.shade400,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: mq.width * 0.02,
                                  vertical: mq.height * 0.02),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userData[index]['address'],
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            userData[index]['apartment'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          // Text(userData[index]['maplink'])
                                        ],
                                      )),
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(
                                        FeatherIcons.trash,
                                        color: Colors.red,
                                        size: 22,
                                      ),
                                      onPressed: () async {
                                        await dbHelper.deleteUserData(
                                            userData[index]['id']);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              )),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyColor.darkblue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddressForm(),
              ),
            ).then((result) {
              if (result != null && result) {
                setState(() {});
              }
            });
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
