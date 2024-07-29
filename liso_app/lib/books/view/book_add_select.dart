import 'dart:async';
import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_books_repository/google_books_repository.dart';
import 'package:http/http.dart' as http;
import 'package:sharish/authentication/authentication.dart';
import 'package:sharish/books/bloc/book_bloc.dart';
import 'package:sharish/books/view/book_add_manually.dart';
import 'package:sharish/books/widgets/add_book_dialog.dart';
import 'package:sharish/books/widgets/custome_button.dart';
import 'package:sharish/utils/colors_util.dart';

class AddBookSelectScreen extends StatelessWidget {
  AddBookSelectScreen({
    Key? key,
    required this.bookBloc,
    this.initialSearchText,
  }) : super(key: key);

  final BookBloc bookBloc;
  final String? initialSearchText;

  final GbooksRepository gBooksRepository = GbooksRepository(
    GoogleBooksCache(),
    GoogleBooksClient(),
  );

  Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => _AddBookSelectScreen(bookBloc: bookBloc),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchBloc = GbooksSearchBloc(gBooksRepository: gBooksRepository);

    if (initialSearchText != null) {
      searchBloc.add(TextChanged(text: initialSearchText!));
    }

    return BlocProvider(
      create: (_) => searchBloc,
      child: _AddBookSelectScreen(bookBloc: bookBloc),
    );
    // return _AddBookSelectScreen(bookBloc: bookBloc);
  }
}

class _AddBookSelectScreen extends StatelessWidget {
  const _AddBookSelectScreen({Key? key, required this.bookBloc})
      : super(key: key);
  final BookBloc bookBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a book'), centerTitle: true),
      body: BlocBuilder<GbooksSearchBloc, GbooksSearchState>(
        builder: (context, state) {
          if (state is SearchStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SearchStateError) {
            return Center(child: Text(state.error));
          }
          if (state is SearchStateSuccess) {
            debugPrint('state.items : ${state.items}');
            return state.items.isEmpty
                ? const Text('No Results')
                : _SearchResults(items: state.items.first, bookBloc: bookBloc);
          }
          return Center(child: Text('Please enter a term to begin : $state'));
        },
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    Key? key,
    required this.items,
    required this.bookBloc,
  }) : super(key: key);

  // final List<SearchResultItem> items;
  final SearchResultItem items;
  final BookBloc bookBloc;

  @override
  Widget build(BuildContext context) {
    // debugPrint('items.length : ${items.length}');
    debugPrint('title : ${items.volumeInfo.title}');
    debugPrint('authors : ${items.volumeInfo.authors}');
    debugPrint(
        'industryIdentifiers[0].identifier : ${items.volumeInfo.industryIdentifiers[0].identifier}');
    String getInitials(String title) => title.isNotEmpty
        ? title.trim().split(' ').map((l) => l[0]).take(2).join()
        : '';
    return AddBookDialog(
      showDeleteIcon: false,
      leadingName: getInitials(items.volumeInfo.title),
      title: items.volumeInfo.title,
      subTitle: items.volumeInfo.authors.first.toString(),
      bottomText: 'Not Working? ',
      bottomLinkText: 'Enter manually',
      // appBarTitle: 'Add a book',
      children: [
        const SizedBox(height: 26),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AddBookButton(
              onPressed: () {
                _addItem(context, items, bookBloc);
                // Navigator.pop(context);
              },
              title: 'Looks good!',
              padding: const EdgeInsets.symmetric(
                horizontal: 46,
                vertical: 14,
              ),
            ),
            AddBookButton(
              onPressed: () {
                Navigator.pop(context);
              },
              padding: const EdgeInsets.symmetric(
                horizontal: 36,
                vertical: 14,
              ),
              title: 'Retry',
              backgroundColor: AppColor.white,
              titleColor: AppColor.purple,
            ),
          ],
        ),
      ],
      onTapLinkText: () {
        debugPrint('on tap Enter manually');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddBookManuallyScreen(),
          ),
        );
      },
    );
    /*
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return _SearchResultItem(item: items[index], bookBloc: bookBloc);
      },
    ); */
  }
}

void _addItem(
  BuildContext context,
  SearchResultItem item,
  BookBloc bookBloc,
) async {
  print('Trying to add book');
  //Navigator.pop(context, false);
  final id = await _addBook(context, item);
  if (id != -1) {
    bookBloc.add(BookRefreshRequestedEvent(id));
    // ignore: use_build_context_synchronously
    Navigator.pop(context, false);
  }
}

Future<int> _addBook(BuildContext context, item) async {
  final authState =
      BlocProvider.of<AuthenticationBloc>(context).state;

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
    'title': item.volumeInfo.title,
    'authors': item.volumeInfo.authors,
    'isbn13': item.volumeInfo.industryIdentifiers[0].identifier,
  };

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
}
/*
class _SearchResultItem extends StatelessWidget {
  const _SearchResultItem({
    Key? key,
    required this.item,
    required this.bookBloc,
  }) : super(key: key);

  final SearchResultItem item;
  final BookBloc bookBloc;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.book),
      title: Text(item.volumeInfo.title),
      subtitle: Column(
        children: [
          _displayAuthors(item.volumeInfo.authors),
          Row(
            children: [
              const Text('isbn13: '),
              Text(item.volumeInfo.industryIdentifiers[0].identifier),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.add),
        tooltip: 'Add book to library',
        onPressed: () => _addItem(context, item, bookBloc),
      ),
    );
  }
} */

/*
Widget _displayAuthors(List<dynamic>? authors) {
  return Row(
    children: authors
            ?.map(
              (author) => Text(author.toString()),
            )
            .toList() ??
        [],
  );
} */


