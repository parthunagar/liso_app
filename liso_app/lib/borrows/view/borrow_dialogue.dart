import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:sharish/borrows/bloc/borrow_book_bloc.dart';
import 'package:sharish/borrows/models/borrow_book.dart';
import 'package:sharish/borrows/view/borrow_form.dart';
import 'package:sharish/utils/colors_util.dart';

// ignore: must_be_immutable
class BorrowDialogue extends StatelessWidget {
  BorrowDialogue({Key? key, required this.book}) : super(key: key);
  BorrowBook book;
  static void show({
    required BuildContext context,
    required int bookId,
    required int libraryId,
    required BorrowBook book,
  }) {
    // ignore: inference_failure_on_function_invocation
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      barrierColor: AppColor.transparent,
      builder: (ctx) => BlocProvider(
        create: (_) => BorrowBookBloc(borrowBook: book),
        child: BorrowDialogue(book: book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BorrowBookBloc, BorrowBookState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: _listener,
      /*
      child: Container(
        alignment: Alignment.topCenter,
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: BookLoanForm(),
        ),
      ),
       */
      child: BorrowForm(borrowBook: book),
    );
  }

  void _listener(BuildContext context, BorrowBookState state) {
    if (state.status.isSubmissionFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Submission error occurred. Please try later.')),
      );
    } else if (state.status.isSubmissionSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The borrow was submitted successfully')),
      );
      Navigator.of(context).pop();
    }
  }
}
