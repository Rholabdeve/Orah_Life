import 'package:flutter/material.dart';
import 'package:orah_pharmacy/const/color.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({
    required this.onTap,
    required this.buttonText,
    this.sizeHeight,
    required this.sizeWidth,
    this.buttonColor,
    this.boderRadius,
    this.textColor,
    this.borderColor,
    this.icon,
    this.iconColor,
    this.isIcon = false,
    this.fontFamily,
    this.buttontextsize,
    this.buttontextweight,
    this.buttonborderwidth,
    this.isloading,
    Key? key,
  }) : super(key: key);

  VoidCallback onTap;
  Color? buttonColor;
  double? boderRadius;
  Color? textColor;
  String buttonText;
  Color? borderColor;
  IconData? icon;
  bool? isIcon;
  Color? iconColor;
  double? sizeHeight;
  double sizeWidth;
  String? fontFamily;
  double? buttontextsize;
  FontWeight? buttontextweight;
  double? buttonborderwidth;
  bool? isloading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizeHeight ?? 50,
      width: sizeWidth,
      decoration: BoxDecoration(
        color: buttonColor ?? MyColor.darkblue,
        borderRadius: BorderRadius.circular(boderRadius ?? 10),
        border: Border.all(
            color: borderColor ?? Colors.transparent,
            //strokeAlign: borderstroke ?? 1,
            width: buttonborderwidth ?? 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            //  padding: const EdgeInsets.all(10),
            child: Center(
              child: isIcon == false
                  ? isloading == true
                      ? CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        )
                      : Text(
                          buttonText,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: textColor ?? Colors.white,
                              fontSize: buttontextsize ?? 15,
                              fontWeight:
                                  buttontextweight ?? FontWeight.normal),
                        )
                  : Icon(
                      icon,
                      color: iconColor,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
