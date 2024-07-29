import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharish/borrows/bloc/borrow_book_bloc.dart';
import 'package:sharish/utils/colors_util.dart';
import 'package:sharish/widget/custom_textfield.dart';

class BorrowPersonNameInput extends StatelessWidget {
  const BorrowPersonNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BorrowBookBloc, BorrowBookState>(
      buildWhen: (p, c) => p.personName != c.personName,
      builder: (context, state) {
        return CustomTextFiledWidget(
          labelText: 'Name',
          hintTextColor: AppColor.purple,
          textColor: AppColor.purple,
          errorText: state.personName.valid ? null : 'Please enter name',
          onChanged: (name) => BlocProvider.of<BorrowBookBloc>(context)
              .add(BorrowBookNameChangedEvent(name)),
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
        );
         */
      },
    );
  }
}
