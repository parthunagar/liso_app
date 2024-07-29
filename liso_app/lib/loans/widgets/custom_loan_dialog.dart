import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sharish/borrows/widgets/leading_icon.dart';
import 'package:sharish/utils/colors_util.dart';
import 'package:sharish/utils/images_util.dart';

// ignore: must_be_immutable
class CustomLoanDialog extends StatelessWidget {
  CustomLoanDialog({
    Key? key,
    this.title,
    this.subTitle,
    this.description,
    this.onTapRequestBack,
    this.onTapCancel,
    this.onTapEndLoan,
    this.leadingName,
  }) : super(key: key);
  String? title, subTitle, description, leadingName;
  void Function()? onTapRequestBack;
  void Function()? onTapCancel;
  void Function()? onTapEndLoan;

  @override
  Widget build(BuildContext context) {
    String getInitials(String title) => title.isNotEmpty
        ? title.trim().split(' ').map((l) => l[0]).take(2).join()
        : '';
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 89),
      child: Scaffold(
        backgroundColor: AppColor.purple,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                Assets.blueDot_8x,
                height: h,
                width: w,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: h / 2,
                width: w,
                color: AppColor.purple,
              ),
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: h / 6),
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 35),
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(
                        40,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Container(
                        //   padding: const EdgeInsets.only(
                        //     top: 10,
                        //     right: 6,
                        //   ),
                        //   alignment: Alignment.topRight,
                        //   child: InkWell(
                        //     onTap: () {
                        //       debugPrint('on tap delete');
                        //     },
                        //     child: Icon(
                        //       Icons.delete,
                        //       color: AppColor.purple,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 66),
                        Text(
                          title!,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: AppColor.purple,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        /* 
                        const SizedBox(height: 2),
                        Text(
                          subTitle!,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: AppColor.purple,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        */
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Lent to ',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        color: AppColor.greyFont,
                                        fontWeight: FontWeight.normal),
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                                text: description,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                      color: AppColor.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 26),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _LonButton(
                              onPressed: onTapRequestBack, // () {},
                              title: 'Request back',
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                            ),
                            _LonButton(
                              onPressed: onTapCancel,
                              title: 'Cancel',
                              backgroundColor: AppColor.white,
                              titleColor: AppColor.purple,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: _LonButton(
                            onPressed: onTapEndLoan, // () {},
                            title: 'End loan',
                            // padding: const EdgeInsets.symmetric(
                            //   horizontal: 24,
                            //   vertical: 14,
                            // ),
                            backgroundColor: AppColor.green,
                            borderColor: AppColor.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                LeadingIcon(leadingName: getInitials(title!)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LonButton extends StatelessWidget {
  _LonButton({
    Key? key,
    this.onPressed,
    this.title,
    this.borderColor,
    this.backgroundColor,
    this.titleColor,
    this.padding,
  }) : super(key: key);

  void Function()? onPressed;
  String? title;
  Color? borderColor;
  Color? backgroundColor;
  Color? titleColor;
  EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          padding ?? const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
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
