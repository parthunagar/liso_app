import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:sharish/book_loan/bloc/book_loan_bloc.dart';
import 'package:sharish/utils/colors_util.dart';

class BookLoanSubmitButton extends StatelessWidget {
  const BookLoanSubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookLoanBloc, BookLoanState>(
      buildWhen: (p, c) => p.status != c.status,
      builder: (context, state) {
        final status = state.status;
        return status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ButtonWidget(
                    onPressed: status.isSubmissionFailure || status.isValidated
                        ? () => BlocProvider.of<BookLoanBloc>(context)
                            .add(BookLoanSubmittedEvent())
                        : null,
                    title: 'Loan Now',
                  ),
                  _ButtonWidget(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    title: 'Cancel',
                    backgroundColor: AppColor.white,
                    titleColor: AppColor.purple,
                  ),
                ],
              );
      },
    );
  }
}

// ignore: must_be_immutable
class _ButtonWidget extends StatelessWidget {
  _ButtonWidget({
    Key? key,
    this.onPressed,
    this.title,
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
          const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
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
