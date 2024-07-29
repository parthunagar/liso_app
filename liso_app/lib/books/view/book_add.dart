import 'dart:async';
import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_books_repository/google_books_repository.dart';
import 'package:http/http.dart' as http;
import 'package:sharish/authentication/authentication.dart';
import 'package:sharish/books/bloc/book_bloc.dart';

class AddBookPage extends StatelessWidget {
  AddBookPage({Key? key, required this.bookBloc}) : super(key: key);
  final BookBloc bookBloc;

  final GbooksRepository gBooksRepository = GbooksRepository(
    GoogleBooksCache(),
    GoogleBooksClient(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add a book'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: BlocProvider(
        create: (_) => GbooksSearchBloc(gBooksRepository: gBooksRepository),
        child: SearchForm(bookBloc: bookBloc),
      ),
    );
  }
}

class SearchForm extends StatelessWidget {
  const SearchForm({Key? key, required this.bookBloc}) : super(key: key);

  final BookBloc bookBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //_SearchBar(),
        _BarcodeScan(),
        _SearchBody(bookBloc: bookBloc),
      ],
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _textController = TextEditingController();
  late GbooksSearchBloc _gbooksSearchBloc;

  @override
  void initState() {
    super.initState();
    _gbooksSearchBloc = context.read<GbooksSearchBloc>();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      autocorrect: false,
      onChanged: (text) {
        _gbooksSearchBloc.add(
          const TextChanged(text: '9780321834577'), //9780321834577
        );
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: GestureDetector(
          onTap: _onClearTapped,
          child: const Icon(Icons.clear),
        ),
        border: InputBorder.none,
        hintText: 'Enter a search term',
      ),
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    _gbooksSearchBloc.add(const TextChanged(text: ''));
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody({Key? key, required this.bookBloc}) : super(key: key);

  final BookBloc bookBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GbooksSearchBloc, GbooksSearchState>(
      builder: (context, state) {
        if (state is SearchStateLoading) {
          return const CircularProgressIndicator();
        }
        if (state is SearchStateError) {
          return Text(state.error);
        }
        if (state is SearchStateSuccess) {
          return state.items.isEmpty
              ? const Text('No Results')
              : Expanded(
                  child: _SearchResults(
                    items: state.items,
                    bookBloc: bookBloc,
                  ),
                );
        }
        return const Text('Please enter a term to begin');
      },
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    Key? key,
    required this.items,
    required this.bookBloc,
  }) : super(key: key);

  final List<SearchResultItem> items;
  final BookBloc bookBloc;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return _SearchResultItem(item: items[index], bookBloc: bookBloc);
      },
    );
  }
}

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
}

void _addItem(
  BuildContext context,
  SearchResultItem item,
  BookBloc bookBloc,
) async {
  print('Trying to add book');
  //Navigator.pop(context, false);
  final int id = await _addBook(context, item);
  if (id != -1) {
    bookBloc.add(BookRefreshRequestedEvent(id));
    Navigator.pop(context, false);
  }
}

Widget _displayAuthors(List<dynamic>? authors) {
  return Row(
    children: authors
            ?.map(
              (author) => Text(author.toString()),
            )
            .toList() ??
        [],
  );
}

Future<int> _addBook(BuildContext context, item) async {
  final AuthenticationState authState =
      BlocProvider.of<AuthenticationBloc>(context).state;

  if (authState.status != AuthenticationStatus.authenticated) {
    print('User is not authenticated');
    return -1;
  }
  final storage = const FlutterSecureStorage();
  final token = await storage.read(key: 'token');

  var url = Uri.parse(
    'http://liso.sweep6.nl/api/library/${authState.user.mainLibraryId}/book',
  );
  Map<String, String> headerValues = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };

  var body = {
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

class _BarcodeScan extends StatefulWidget {
  @override
  State<_BarcodeScan> createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<_BarcodeScan> {
  String _scanBarcode = 'Unknown';
  late GbooksSearchBloc _gbooksSearchBloc;

  @override
  void initState() {
    super.initState();
    _gbooksSearchBloc = context.read<GbooksSearchBloc>();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      print(barcodeScanRes);
      _gbooksSearchBloc.add(
        TextChanged(text: barcodeScanRes),
      );
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: scanBarcodeNormal,
            child: const Text('Start barcode scan'),
          ),
          Text(
            'Scan result : $_scanBarcode\n',
            style: const TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
