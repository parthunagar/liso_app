import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharish/borrows/bloc/borrow_book_bloc.dart';
import 'package:sharish/utils/colors_util.dart';
import 'package:sharish/widget/custom_textfield.dart';

class BorrowPersonEmailInput extends StatelessWidget {
  const BorrowPersonEmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BorrowBookBloc, BorrowBookState>(
      buildWhen: (p, c) => p.personEmail != c.personEmail,
      builder: (context, state) {
        return CustomTextFiledWidget(
          labelText: 'E-mail',
          hintTextColor: AppColor.purple,
          textColor: AppColor.purple,
          errorText: state.personEmail.valid ? null : 'Please enter e-mail',
          onChanged: (email) => BlocProvider.of<BorrowBookBloc>(context)
              .add(BorrowBookEmailChangedEvent(email)),
          borderColor: AppColor.purple,
          errorTextColor: AppColor.purple,
        );
        /*
        return TextField(
        onChanged: (email) => BlocProvider.of<BookLoanBloc>(context).add(
          BookLoanEmailChangedEvent(email),
        ),
          decoration: InputDecoration(
            labelText: 'E-mail',
            errorText: state.personEmail.valid ? null : 'Please enter e-mail',
          ),
        );
         */
      },
    );
  }
}
