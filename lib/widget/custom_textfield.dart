// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orah_pharmacy/const/color.dart';

class CustomTextField extends StatefulWidget {
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? textInputType;
  final String? hintText;
  final Widget? prefixIcon;
  final String? defaultText;
  final FocusNode? focusNode;
  bool obscureText;
  final TextEditingController? controller;
  final Function? functionValidate;
  final String? parametersValidate;
  final TextInputAction? actionKeyboard;
  final int? maxLines;
  final Widget? suffixIcon;
  final Color? iconColor;
  final FormFieldValidator? validate;
  final int? maxlength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final String? label;
  final GestureTapCallback? onTap;
  final bool? readonly;
  final IconData? suffixicon;
  final IconData? suffixIcon2;
  final Color? fillColor;
  final bool? filled;
  final ValueChanged<String>? onChanged;
  final Widget? prefix;

  // final SpellCheckConfiguration? spellCheckConfiguration;

  CustomTextField(
      {super.key,
      this.hintText,
      this.focusNode,
      this.textInputType,
      this.defaultText,
      this.obscureText = false,
      this.controller,
      this.functionValidate,
      this.parametersValidate,
      this.actionKeyboard = TextInputAction.next,
      this.prefixIcon,
      this.iconColor,
      this.maxLines,
      this.suffixIcon,
      this.validate,
      this.inputFormatters,
      this.maxlength,
      this.maxLengthEnforcement,
      this.label,
      this.onTap,
      this.readonly,
      this.suffixicon,
      this.suffixIcon2,
      this.fillColor,
      this.filled,
      this.onChanged,
      this.prefix});

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  double bottomPaddingToError = 12;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TextFormField(
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        maxLength: widget.maxlength,
        inputFormatters: widget.inputFormatters,
        maxLengthEnforcement: widget.maxLengthEnforcement,
        validator: widget.validate,
        // spellCheckConfiguration: SpellCheckConfiguration(),
        maxLines: widget.maxLines,
        cursorColor: Colors.black,
        obscureText: widget.obscureText,
        keyboardType: widget.textInputType,
        textInputAction: widget.actionKeyboard,
        focusNode: widget.focusNode,
        readOnly: widget.readonly ?? false,

        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          labelText: widget.label,
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
          hintText: widget.hintText,
          labelStyle: const TextStyle(color: Colors.black),
          fillColor: widget.fillColor ?? Colors.grey.shade100,
          filled: widget.filled,
          prefix: widget.prefix,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MyColor.darkblue, width: 2.0),
            borderRadius: BorderRadius.circular(8),
          ),
          hintStyle: const TextStyle(
            color: Colors.black,
            // fontFamily: 'Ubuntu Regular',
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 12.0,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.normal,
            letterSpacing: 1.2,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        controller: widget.controller,
      ),
    );
  }
}

String? commonValidation(String value, String messageError) {
  var required = requiredValidator(value, messageError);
  if (required != null) {
    return required;
  }
  return null;
}

String? requiredValidator(value, messageError) {
  if (value.isEmpty) {
    return messageError;
  }
  return null;
}

void changeFocus(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
