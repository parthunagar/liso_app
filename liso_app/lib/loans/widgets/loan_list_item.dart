import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sharish/borrows/widgets/leading_icon.dart';
import 'package:sharish/loans/loans.dart';
import 'package:sharish/utils/colors_util.dart';

class LoanListItem extends StatelessWidget {
  const LoanListItem({Key? key, required this.loan}) : super(key: key);

  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    String getInitials(String title) => title.isNotEmpty
        ? title.trim().split(' ').map((l) => l[0]).take(2).join()
        : '';
    // return ListTile(
    //   leading: Text('${loan.id}', style: textTheme.caption),
    //   title: Text(loan.book.title),
    //   isThreeLine: true,
    //   subtitle: Text(loan.user.name), //Text(loan.body)
    //   dense: true,
    // );
    return Row(
      children: [
        LeadingIcon(leadingName: getInitials(loan.book.title)),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loan.book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColor.purple,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Lent to ',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: AppColor.greyFont,
                          fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()..onTap = () {},
                      text: loan.user.name,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: AppColor.green,
                            fontWeight: FontWeight.bold,
                          ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
