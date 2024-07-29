import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharish/book_loan/bloc/book_loan_bloc.dart';
import 'package:sharish/utils/colors_util.dart';
import 'package:sharish/widget/custom_textfield.dart';

class PersonNameInput extends StatelessWidget {
  const PersonNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookLoanBloc, BookLoanState>(
      buildWhen: (p, c) => p.personName != c.personName,
      builder: (context, state) {
        return CustomTextFiledWidget(
          labelText: 'Name',
          hintTextColor: AppColor.purple,
          textColor: AppColor.purple,
          errorText: state.personName.valid ? null : 'Please enter name',
          onChanged: (name) => BlocProvider.of<BookLoanBloc>(context).add(
            BookLoanNameChangedEvent(name),
          ),
          borderColor: AppColor.purple,
          errorTextColor: AppColor.purple,
        );
        /*
        return TextField(
          onChanged: (name) => BlocProvider.of<BookLoanBloc>(context).add(
            BookLoanNameChangedEvent(name),
          ),
          decoration: InputDecoration(
            labelText: 'Name',
            errorText: state.personName.valid ? null : 'Please enter name',
          ),
        ); */
      },
    );
  }
}
