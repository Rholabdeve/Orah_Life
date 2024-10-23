import 'package:flutter/material.dart';
import 'package:orah_pharmacy/widget/custom_container.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesShimmer extends StatefulWidget {
  const CategoriesShimmer({Key? key}) : super(key: key);

  @override
  _CategoriesShimmerState createState() => _CategoriesShimmerState();
}

class _CategoriesShimmerState extends State<CategoriesShimmer> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Expanded(
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
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: mq.width * 0.03,
              crossAxisSpacing: mq.height * 0.02,
              childAspectRatio: 20 / 30,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: CustomContainer(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 206, 206, 206),
                      highlightColor: Color.fromARGB(255, 187, 187, 187),
                      enabled: true,
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: mq.height * 0.25,
                            width: mq.width * 0.4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          SizedBox(
                            height: mq.height * 0.02,
                          ),
                          // Product name Box
                          Container(
                            height: mq.height * 0.05,
                            width: mq.width * 0.4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
