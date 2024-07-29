import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sharish/utils/colors_util.dart';
import 'package:sharish/utils/images_util.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset(
              Assets.whiteDot,
              color: AppColor.backgroungPattern,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 750,
          child: Stack(
            children: [
              Positioned.fill(
                bottom: 20,
                right: 40,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: SvgPicture.asset(
                    Assets.bookMarkGreen,
                    color: AppColor.green,
                    height: 100,
                  ),
                ),
              ),
              Container(
                height: 650,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: AppColor.purple,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                ),
                child: SvgPicture.asset(
                  Assets.sharishWhite,
                  fit: BoxFit.scaleDown,
                  color: AppColor.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
