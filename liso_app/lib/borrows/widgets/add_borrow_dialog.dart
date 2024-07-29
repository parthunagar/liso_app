import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sharish/borrows/widgets/leading_icon.dart';
import 'package:sharish/utils/colors_util.dart';
import 'package:sharish/utils/images_util.dart';

class AddBorrowDialog extends StatelessWidget {
  AddBorrowDialog({
    Key? key,
    @required this.showDeleteIcon,
    @required this.children,
    @required this.leadingName,
    this.title,
    this.subTitle,
    this.bottomText,
    this.bottomLinkText,
    this.onTapLinkText,
    this.appBarTitle,
  }) : super(key: key);
  bool? showDeleteIcon;
  List<Widget>? children;
  String? leadingName, title, subTitle;
  String? bottomText, bottomLinkText;
  void Function()? onTapLinkText;
  String? appBarTitle;
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Container(
      height: h,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.blueDot_2x),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        // alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          richTextContainer(context),
          dialogContainer(context),
        ],
      ),
    );
  }

  Widget dialogContainer(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Align(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: h / 6),
            child: Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 35,
              ),
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
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      right: 6,
                    ),
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        debugPrint('on tap delete');
                      },
                      child: Icon(
                        Icons.delete,
                        color: showDeleteIcon ?? false
                            ? AppColor.purple
                            : AppColor.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    title ?? '',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: AppColor.purple,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subTitle ?? '',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: AppColor.purple,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  Column(
                    children: children ?? [],
                  ),
                ],
              ),
            ),
          ),
          LeadingIcon(leadingName: leadingName),
        ],
      ),
    );
  }

  Widget richTextContainer(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 16),
      margin: EdgeInsets.only(top: h / 2.5),
      // height: h / 2,
      width: w,
      color: AppColor.purple,
      /*
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: bottomText ?? '',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: AppColor.white, fontWeight: FontWeight.normal),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = onTapLinkText ?? () {},
              text: bottomLinkText ?? '',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: AppColor.white,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.underline,
                  ),
            )
          ],
        ),
      ),
       */
    );
  }
}
