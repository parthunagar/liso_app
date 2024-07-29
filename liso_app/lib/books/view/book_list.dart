import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharish/book_loan/view/book_loan_dialogue.dart';
import 'package:sharish/books/books.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BooksList extends StatefulWidget {
  @override
  _BooksListState createState() => _BooksListState();
}

class _BooksListState extends State<BooksList> {
  final _scrollController = ScrollController();
  late BookBloc _BookBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _BookBloc = context.read<BookBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state) {
        // print('state : $state');
        switch (state.status) {
          case BookStatus.failure:
            return const Center(child: Text('failed to fetch books'));
          case BookStatus.success:
            if (state.books.isEmpty) {
              return const Center(child: Text('no books'));
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
              itemBuilder: (BuildContext context, int index) {
                return index >= state.books.length
                    ? BottomLoader()
                    : Slidable(
                        key: ValueKey(index),
                        enabled: state.books[index].status == 'available'
                            ? true
                            : false,
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              flex: 2,
                              onPressed: (context) => _loanBook(
                                context: context,
                                bookId: state.books[index].id,
                                libraryId: state.libraryId,
                                book: state.books[index],
                              ),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              icon: Icons.send,
                              label: 'Loan',
                            ),
                          ],
                        ),
                        child: BookListItem(post: state.books[index]),
                      );
              },
              itemCount: state.hasReachedMax
                  ? state.books.length
                  : state.books.length + 1,
              controller: _scrollController,
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _loanBook({
    required BuildContext context,
    required int bookId,
    required int libraryId,
    required Book book,
  }) {
    BookLoanDialogue.show(
      context: context,
      bookId: bookId,
      libraryId: libraryId,
      book: book,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) _BookBloc.add(BookFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
