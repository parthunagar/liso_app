import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharish/book_loan/bloc/book_loan_bloc.dart';
import 'package:formz/formz.dart';
import 'package:sharish/book_loan/widgets/book_loan_form.dart';
import 'package:sharish/book_loan/widgets/custom_dialog.dart';
import 'package:sharish/books/models/book.dart';
import 'package:sharish/utils/colors_util.dart';

class BookLoanDialogue extends StatelessWidget {
  BookLoanDialogue({Key? key, @required this.book}) : super(key: key);
  Book? book;
  static void show({
    required BuildContext context,
    required int bookId,
    required int libraryId,
    required Book book,
  }) {
    // ignore: inference_failure_on_function_invocation
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      barrierColor: AppColor.transparent,
      builder: (ctx) => BlocProvider(
          create: (_) => BookLoanBloc(bookId: bookId, libraryId: libraryId),
          child: BookLoanDialogue(book: book)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookLoanBloc, BookLoanState>(
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
      child: BookLoanForm(book: book),
    );
  }

  void _listener(BuildContext context, BookLoanState state) {
    if (state.status.isSubmissionFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Submission error occurred. Please try later.')),
      );
    } else if (state.status.isSubmissionSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The loan was submitted successfully')),
      );
      Navigator.of(context).pop();
    }
  }
}
