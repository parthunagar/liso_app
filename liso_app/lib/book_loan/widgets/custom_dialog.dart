import 'package:flutter/material.dart';
import 'package:sharish/borrows/widgets/leading_icon.dart';
import 'package:sharish/utils/colors_util.dart';
import 'package:sharish/utils/images_util.dart';

// ignore: must_be_immutable
class CustomDialog extends StatelessWidget {
  CustomDialog({
    Key? key,
    this.title,
    this.subTitle,
    this.description,
    this.onTapApprove,
    this.onTapCancel,
  }) : super(key: key);
  String? title, subTitle, description;
  void Function()? onTapApprove;
  void Function()? onTapCancel;

  @override
  Widget build(BuildContext context) {
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
                      // top: 60,
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
                            child: const Icon(
                              Icons.delete,
                              color: AppColor.purple,
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),
                        Text(
                          'clean Architecture',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: AppColor.purple,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Robert Martin',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: AppColor.purple,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                        const SizedBox(height: 26),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: onTapApprove, // () {},
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all<Size>(
                                  const Size(175, 50),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  AppColor.purple,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: const BorderSide(
                                      color: AppColor.purple,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Loan',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: onTapCancel, //() {},
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all<Size>(
                                  const Size(130, 50),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  AppColor.white,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: const BorderSide(
                                      color: AppColor.purple,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Cencel',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                      color: AppColor.purple,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                LeadingIcon(leadingName: '?'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
