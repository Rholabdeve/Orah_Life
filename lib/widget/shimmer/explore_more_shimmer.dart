import 'package:flutter/material.dart';
import 'package:orah_pharmacy/widget/custom_container.dart';
import 'package:shimmer/shimmer.dart';

class ExploreMoreShimmer extends StatefulWidget {
  const ExploreMoreShimmer({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ExploreMoreShimmerState createState() => _ExploreMoreShimmerState();
}

class _ExploreMoreShimmerState extends State<ExploreMoreShimmer> {
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
              mainAxisSpacing: mq.width * 0.04,
              crossAxisSpacing: mq.height * 0.03,
              // childAspectRatio: 22 / 28,
              childAspectRatio: mq.aspectRatio / 0.8,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Product Image Box
                          Container(
                            height: mq.height * 0.2,
                            width: mq.width * 0.4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                          ),

                          // Product name Box
                          Container(
                            height: mq.height * 0.05,
                            width: mq.width * 0.4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                          ),

                          //Product Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text(
                              //   "Rs: ${widget.medicine![index]['product_mrp']}",
                              //   overflow: TextOverflow.ellipsis,
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .bodyMedium!
                              //       .copyWith(fontWeight: FontWeight.bold),
                              // ),
                              // TextButton(
                              //   onPressed: () {},
                              //   child: Text(
                              //     '+ ADD',
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .bodyMedium!
                              //         .copyWith(
                              //             color: MyColor.darkblue,
                              //             fontWeight: FontWeight.bold),
                              //   ),
                              // ),
                            ],
                          )
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
