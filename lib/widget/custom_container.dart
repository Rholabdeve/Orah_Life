import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomContainer extends StatelessWidget {
  CustomContainer({
    required this.child,
    this.sizeWidth,
    this.sizeHeight,
    this.color,
    this.radius,
    this.margin,
    this.border,
    this.clipBehavior,
    this.shadowBlurRadius,
    this.shadowColor,
    this.offset = const Offset(0, 0),
    super.key,
  });

  Widget child;
  double? sizeWidth;
  double? sizeHeight;
  Color? color;
  double? radius;
  EdgeInsetsGeometry? margin;
  BoxBorder? border;
  Clip? clipBehavior;
  double? shadowBlurRadius;
  Color? shadowColor;
  Offset offset;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizeHeight ?? 45,
      width: sizeWidth ?? 100,
      margin: margin,
      clipBehavior: clipBehavior ?? Clip.none,
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(radius ?? 10),
        border: border ?? const Border(),
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? Colors.white,
            blurRadius: shadowBlurRadius ?? 0,
            offset: offset,
          ),
        ],
      ),
      child: child,
    );
  }
}
