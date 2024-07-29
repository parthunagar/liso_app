import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_books_repository/google_books_repository.dart';
import 'package:http/http.dart' as http;
import 'package:sharish/books/books.dart';
import 'package:sharish/books/view/book_add_select.dart';
import 'package:sharish/utils/colors_util.dart';
import 'package:user_repository/user_repository.dart';

class BooksPage extends StatelessWidget {
  BooksPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => _BooksPage());
  }

  final GbooksRepository gBooksRepository = GbooksRepository(
    GoogleBooksCache(),
    GoogleBooksClient(),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GbooksSearchBloc>(
          create: (BuildContext context) =>
              GbooksSearchBloc(gBooksRepository: gBooksRepository),
        ), // bookBloc: BlocProvider.of<BookBloc>(cx),
        BlocProvider<BookBloc>(
          create: (BuildContext context) => BookBloc(
            httpClient: http.Client(),
            userRepository: UserRepository(),
          ),
        ),
      ],
      child: const _BooksPage(),
    );
  }
}
  
class _BooksPage extends StatefulWidget {
  const _BooksPage({Key? key}) : super(key: key);

  @override
  State<_BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<_BooksPage> {
  String _scanBarcode = 'Unknown';

  late GbooksSearchBloc _gbooksSearchBloc;

  @override
  void initState() {
    super.initState();
    _gbooksSearchBloc = context.read<GbooksSearchBloc>();
  }

  Future<void> scanBarcodeNormal(BuildContext context) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      print('barcodeScanRes : $barcodeScanRes');

      _gbooksSearchBloc.add(TextChanged(text: barcodeScanRes));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (cx) => AddBookSelectScreen(
            bookBloc: BlocProvider.of<BookBloc>(context),
            initialSearchText: barcodeScanRes,
          ),
        ),
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
    return BlocProvider(
      create: (_) => BookBloc(
        httpClient: http.Client(),
        userRepository: UserRepository(),
      )..add(BookFetched()),
      child: Scaffold(
        body: BooksList(),
        floatingActionButton: Builder(
          builder: (ctx) => SizedBox(
            width: 60,
            height: 60,
            child: InkWell(
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBookPage(
                      bookBloc: BlocProvider.of<BookBloc>(ctx),
                    ),
                  ),
                );
              },
              child: FloatingActionButton(
                backgroundColor: AppColor.purple,
                key: const Key('booksView_add_book'),
                onPressed: () {
                  scanBarcodeNormal(context);
                },
                child: const Icon(
                  Icons.add,
                  color: AppColor.white,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
