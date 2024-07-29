import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:sharish/borrows/bloc/borrow_book_bloc.dart';
import 'package:sharish/borrows/models/borrow_book.dart';
import 'package:sharish/borrows/widgets/custom_button.dart';
import 'package:sharish/utils/colors_util.dart';

// ignore: must_be_immutable
class BorrowSubmitButton extends StatelessWidget {
   BorrowSubmitButton({Key? key,required this.borrowBook}) : super(key: key);
  BorrowBook borrowBook;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BorrowBookBloc, BorrowBookState>(
      buildWhen: (p, c) => p.status != c.status,
      builder: (context, state) {
        final status = state.status;
        return status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonWidget(
                    onPressed: status.isSubmissionFailure || status.isValidated
                        ? () => BlocProvider.of<BorrowBookBloc>(context)
                            .add(BorrowBookSubmittedEvent(borrowBook))
                        : null,
                    title: 'Borrow Now',
                  ),
                  ButtonWidget(
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

  /*
  void _addItem(
    BuildContext context,
    SearchResultItem item,
    BookBloc bookBloc,
  ) async {
    print('Trying to add book');
    //Navigator.pop(context, false);
    final id = await _addBorrowBook(context, item);
    if (id != -1) {
      bookBloc.add(BookRefreshRequestedEvent(id));
      Navigator.pop(context, false);
    }
  } */

  /*
  
  Future<int> _addBorrowBook(BuildContext context, item) async {
    final authState = BlocProvider.of<AuthenticationBloc>(context).state;

    if (authState.status != AuthenticationStatus.authenticated) {
      print('User is not authenticated');
      return -1;
    }
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    final url = Uri.parse(
      'http://liso.sweep6.nl/api/library/${authState.user.mainLibraryId}/book',
    );
    final headerValues = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final body = {
      // 'title': item.volumeInfo.title,
      // 'authors': item.volumeInfo.authors,
      // 'isbn13': item.volumeInfo.industryIdentifiers[0].identifier,
      "book": {
        "title": item.volumeInfo.title,
        "authors": item.volumeInfo.authors,
        "isbn13": item.volumeInfo.industryIdentifiers[0].identifier
      },
      "libraryOwner": {
        "name": "Maarten Bouten",
        "email": "maarten@rechtstreex.nl"
      }
    };

    // 'name':state.personName.value, 'email': state.personEmail.value,
    final response = await http.Client().post(
      url,
      headers: headerValues,
      body: json.encode(body),
    );
    final results = json.decode(response.body);

    if (response.statusCode == 201) {
      //final responseJson = json.decode(response.body);
      // ToDo: add book to book state
      print('book added');
      return results['data']['id'] as int;
    } else {
      print('to bad couldnt add book');
      //throw AuthenticationException(message: 'Wrong username or password');
      return -1;
    }
  } */
}
