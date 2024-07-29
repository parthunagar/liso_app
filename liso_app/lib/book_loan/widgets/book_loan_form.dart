import 'package:flutter/material.dart';
import 'package:sharish/book_loan/widgets/book_loan_submit_button.dart';
import 'package:sharish/book_loan/widgets/person_email_input.dart';
import 'package:sharish/book_loan/widgets/person_name_input.dart';
import 'package:sharish/books/models/book.dart';
import 'package:sharish/borrows/widgets/leading_icon.dart';
import 'package:sharish/utils/colors_util.dart';
import 'package:sharish/utils/images_util.dart';

// ignore: must_be_immutable
class BookLoanForm extends StatelessWidget {
  BookLoanForm({
    Key? key,
    @required this.book,
  }) : super(key: key);
  Book? book;

  @override
  Widget build(BuildContext context) {
    /*
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [],
        ),
      ),
    );
     */
    String getInitials(String title) => title.isNotEmpty
        ? title.trim().split(' ').map((l) => l[0]).take(2).join()
        : '';
    return _FormDialogWidget(
      leadingName: getInitials(book!.title), //'CA',
      showDeleteIcon: false,
      title: book!.title.toString(),
      subTitle: '', // 'Robert Martin',
      children: const [
        SizedBox(height: 16),
        PersonNameInput(),
        PersonEmailInput(),
        SizedBox(height: 36),
        BookLoanSubmitButton(),
      ],
    );
  }
}

// ignore: must_be_immutable
class _FormDialogWidget extends StatelessWidget {
  _FormDialogWidget({
    Key? key,
    @required this.showDeleteIcon,
    @required this.children,
    @required this.leadingName,
    @required this.title,
    this.subTitle,
  }) : super(key: key);
  bool? showDeleteIcon;
  List<Widget>? children;
  String? leadingName, title, subTitle;

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
            ListView(
              shrinkWrap: true,
              children: [
                Stack(
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
                              title!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    color: AppColor.purple,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subTitle ?? '-',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
