import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharish/book_loan/bloc/book_loan_bloc.dart';
import 'package:sharish/utils/colors_util.dart';
import 'package:sharish/widget/custom_textfield.dart';

class PersonEmailInput extends StatelessWidget {
  const PersonEmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookLoanBloc, BookLoanState>(
      buildWhen: (p, c) => p.personEmail != c.personEmail,
      builder: (context, state) {
        return CustomTextFiledWidget(
          labelText: 'E-mail',
          hintTextColor: AppColor.purple,
          textColor: AppColor.purple,
          errorText: state.personEmail.valid ? null : 'Please enter e-mail',
          onChanged: (email) => BlocProvider.of<BookLoanBloc>(context).add(
            BookLoanEmailChangedEvent(email),
          ),
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
        ); */
      },
    );
  }
}
