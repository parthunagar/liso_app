import 'package:flutter/material.dart';
import 'package:sharish/utils/colors_util.dart';

class CustomTextFiledWidget extends StatelessWidget {
  String? labelText, errorText;
  void Function(String)? onChanged;
  bool? obscureText;
  TextEditingController? controller;
  Color? errorTextColor;
  Color? hintTextColor;
  Color? textColor;
  Color? borderColor;
  Color? cursorColor;
  CustomTextFiledWidget({
    Key? key,
    @required this.labelText,
    this.errorText,
    this.onChanged,
    this.obscureText,
    this.controller,
    this.errorTextColor,
    this.hintTextColor,
    this.textColor,
    this.borderColor,
    this.cursorColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      key: key,
      onChanged: onChanged,
      obscureText: obscureText ?? false,
      style: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(color: textColor ?? AppColor.white),
      cursorColor: cursorColor,
      decoration: InputDecoration(
        hintText: labelText,
        errorText: errorText,
        errorStyle: TextStyle(
          color: errorTextColor ?? AppColor.white,
        ),
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: hintTextColor ?? AppColor.white),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? AppColor.purple,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? AppColor.white,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? AppColor.white,
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? AppColor.white,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? AppColor.white,
          ),
        ),
      ),
    );
  }
}
