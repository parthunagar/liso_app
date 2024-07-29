import 'package:flutter/material.dart';
import 'package:sharish/books/widgets/add_book_dialog.dart';
import 'package:sharish/books/widgets/custome_button.dart';
import 'package:sharish/utils/colors_util.dart';
import 'package:sharish/widget/custom_textfield.dart';

class AddBookManuallyScreen extends StatelessWidget {
  const AddBookManuallyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add manually'),
        centerTitle: true,
      ),
      body: const _AddBookManuallyScreen(),
    );
  }
}

class _AddBookManuallyScreen extends StatelessWidget {
  const _AddBookManuallyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AddBookDialog(
      // appBarTitle: 'Add manually',
      showDeleteIcon: false,
      leadingName: '?',
      // title: '',
      // subTitle: '',
      bottomText: 'Add books faster? ',
      bottomLinkText: 'Try scanning.',
      onTapLinkText: () {
        debugPrint('on tap try scanning');
        Navigator.pop(context);
        Navigator.pop(context);
      },
      children: [
        const _BookTitleInput(),
        const SizedBox(height: 16),
        const _BookAuthorInput(),
        const SizedBox(height: 56),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: AddBookButton(
            onPressed: () {
              Navigator.pop(context);
            },
            title: 'Go to final check',
          ),
        ),
      ],
    );
  }
}

class _BookTitleInput extends StatelessWidget {
  const _BookTitleInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextFiledWidget(
      labelText: 'Title',
      hintTextColor: AppColor.purple,
      textColor: AppColor.purple,
      // errorText: 'Please enter title',
      onChanged: (title) {},
      borderColor: AppColor.purple,
      errorTextColor: AppColor.purple,
    );
  }
}

class _BookAuthorInput extends StatelessWidget {
  const _BookAuthorInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextFiledWidget(
      labelText: 'Author',
      hintTextColor: AppColor.purple,
      textColor: AppColor.purple,
      // errorText: 'Please enter author',
      onChanged: (title) {},
      borderColor: AppColor.purple,
      errorTextColor: AppColor.purple,
    );
  }
}
