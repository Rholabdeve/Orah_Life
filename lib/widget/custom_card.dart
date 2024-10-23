import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orah_pharmacy/const/color.dart';
import 'package:orah_pharmacy/services/global.dart';
import 'package:orah_pharmacy/widget/custom_container.dart';

// ignore: must_be_immutable
class CustomCard extends StatefulWidget {
  int discount = 0;
  final String image;
  final String name;
  final String price;
  final String? product_mrps;
  VoidCallback onTap;
  Widget? child;

  CustomCard({
    required this.image,
    required this.name,
    this.product_mrps,
    required this.price,
    required this.onTap,
    this.child,
    required this.discount,
    super.key,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: widget.onTap,
      child: CustomContainer(
        sizeHeight: 270,
        sizeWidth: 170,
        // sizeWidth: mq.width * 0.45,
        // sizeHeight: mq.height * 0.38,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: mq.width * 0.03,
            vertical: mq.height * 0.012,
          ),
          child: Stack(
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.topRight,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Image
                  SizedBox(
                    height: 120,
                    //  height: mq.height * 0.18,
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: Global.imageUrl + widget.image,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                          value: downloadProgress.progress,
                          color: MyColor.darkblue,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      // child: Image(
                      //   fit: BoxFit.contain,
                      //   image: NetworkImage(
                      //     Global.imageUrl + widget.image,
                      //   ),
                      // ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //name
                  SizedBox(
                    height: 40,
                    //height: mq.height * 0.052,
                    child: Text(
                      widget.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  //SizedBox(height: mq.height * 0.01),

                  //Price & Favorite
                  Row(
                    children: [
                      Text(
                        "Rs ${widget.price}",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: mq.width * 0.01),
                      widget.discount == 0
                          ? Container()
                          : Text(
                              "${widget.product_mrps}",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                    ],
                  ),
                  SizedBox(height: mq.height * 0.01),
                  Container(
                    child: widget.child,
                  )
                ],
              ),
              widget.discount == 0
                  ? Container()
                  : CustomContainer(
                      sizeHeight: 30,
                      sizeWidth: 70,
                      // sizeHeight: mq.height * 0.044,
                      // sizeWidth: mq.width * 0.2,
                      color: Colors.green,
                      radius: 24,
                      child: Center(
                        child: Text(
                          "${widget.discount}% Off",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
