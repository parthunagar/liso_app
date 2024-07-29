import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_books_repository/google_books_repository.dart';
import 'package:sharish/books/bloc/book_bloc.dart';
import 'package:sharish/books/view/book_add.dart';
import 'package:sharish/books/view/book_add_select.dart';
import 'package:sharish/borrows/borrows.dart';
import 'package:http/http.dart' as http;
import 'package:sharish/borrows/view/borrow_add_select.dart';
import 'package:sharish/utils/colors_util.dart';
import 'package:user_repository/user_repository.dart';

class BorrowsPage extends StatelessWidget {
  BorrowsPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => _BorrowsPage());
  }

  final GbooksRepository gBooksRepository = GbooksRepository(
    GoogleBooksCache(),
    GoogleBooksClient(),
  );

  @override
  Widget build(BuildContext context) {
    /*
     return Scaffold(
      body: BlocProvider(
        create: (_) => PostBloc(
            httpClient: http.Client(), userRepository: UserRepository())
          ..add(BorrowFetched()),
        child: BorrowsList(),
      ),
    );
     */
    return MultiBlocProvider(
      providers: [
        BlocProvider<GbooksSearchBloc>(
          create: (BuildContext context) =>
              GbooksSearchBloc(gBooksRepository: gBooksRepository),
        ), // bookBloc: BlocProvider.of<BookBloc>(cx),
        BlocProvider<PostBloc>(
          create: (BuildContext context) => PostBloc(
            httpClient: http.Client(),
            userRepository: UserRepository(),
          )..add(BorrowFetched()),
        ),
        BlocProvider<BookBloc>(
          create: (BuildContext context) => BookBloc(
            httpClient: http.Client(),
            userRepository: UserRepository(),
          ),
        ),
      ],
      child: const _BorrowsPage(),
    );
  }
}

class _BorrowsPage extends StatefulWidget {
  const _BorrowsPage({Key? key}) : super(key: key);

  @override
  State<_BorrowsPage> createState() => __BorrowsPageState();
}

class __BorrowsPageState extends State<_BorrowsPage> {
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
      print('borrow => barcodeScanRes : $barcodeScanRes');

      _gbooksSearchBloc.add(TextChanged(text: barcodeScanRes));
      // ignore: use_build_context_synchronously
      await Navigator.push(
        context,
        // ignore: inference_failure_on_instance_creation
        MaterialPageRoute(
          builder: (cx) => AddBorrowSelectScreen(
            bookBloc: BlocProvider.of<PostBloc>(context),
            initialSearchText: barcodeScanRes,
          ),
        ),
      );
    } on PlatformException {
      //  catch (e) {
      barcodeScanRes = 'Failed to get platform version.';
      // print('ERROR : $e');
    }
    //  on PlatformException {
    //   barcodeScanRes = 'Failed to get platform version.';
    // }

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
      create: (_) => PostBloc(
        httpClient: http.Client(),
        userRepository: UserRepository(),
      )..add(BorrowFetched()),
      child: Scaffold(
        body: BorrowsList(),
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
                  print('ON TAP ADD BORROW');
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
