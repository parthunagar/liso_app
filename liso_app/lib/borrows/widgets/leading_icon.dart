import 'package:flutter/material.dart';
import 'package:sharish/utils/colors_util.dart';

class LeadingIcon extends StatelessWidget {
  String? leadingName;
  Color? borderColor, TextColor;
  LeadingIcon({
    Key? key,
    @required this.leadingName,
    this.borderColor,
    this.TextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      // alignment: Alignment.center,
      children: [
        Container(
          height: 85,
          width: 70,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor ?? AppColor.purple, width: 3),
          ),
        ),
        Positioned.fill(
          right: 5,
          child: Container(
            height: 80,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: borderColor ?? AppColor.purple, width: 3),
            ),
          ),
        ),
        Positioned.fill(
          right: 10,
          child: Container(
            alignment: Alignment.center,
            height: 80,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: borderColor ?? AppColor.purple, width: 3),
            ),
            child: Text(
              leadingName!,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: TextColor ?? AppColor.purple,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            ),
          ),
        )
      ],
    );
  }
}
