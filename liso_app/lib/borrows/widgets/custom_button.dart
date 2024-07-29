import 'package:flutter/material.dart';
import 'package:sharish/utils/colors_util.dart';

class ButtonWidget extends StatelessWidget {
  ButtonWidget({
    Key? key,
    this.onPressed,
    this.title,
    this.borderColor,
    this.backgroundColor,
    this.titleColor,
  }) : super(key: key);
  void Function()? onPressed;
  String? title;
  Color? borderColor;
  Color? backgroundColor;
  Color? titleColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 37, vertical: 14),
        ),
        // fixedSize: MaterialStateProperty.all<Size>(
        //   const Size(175, 50),
        // ),
        backgroundColor: MaterialStateProperty.all<Color>(
          backgroundColor ?? AppColor.purple,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: borderColor ?? AppColor.purple,
              width: 2,
            ),
          ),
        ),
      ),
      child: Text(
        title ?? '',
        style: Theme.of(context).textTheme.headline6!.copyWith(
              color: titleColor ?? AppColor.white,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
