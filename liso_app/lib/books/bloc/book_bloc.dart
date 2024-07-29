import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:sharish/books/books.dart';
import 'package:user_repository/user_repository.dart';

part 'book_event.dart';
part 'book_state.dart';

const _perPage = 40;

class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc({
    required this.httpClient,
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const BookState()) {
    on<BookEvent>(_onEvent,
        transformer: debounce(const Duration(milliseconds: 300)));

    on<BookFetched>(
      (event, emit) async {
        final result = await _mapBookFetchedToState(state);
        emit(result);
      },
    );

    on<BookRefreshRequestedEvent>((event, emit) async* {
      yield* _mapBookRefreshRequestedEvent(event);
    });
  }

  final http.Client httpClient;
  final UserRepository _userRepository;

  EventTransformer<MyEvent> debounce<MyEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  FutureOr<void> _onEvent(BookEvent event, Emitter<BookState> emit) async {
    print(' ======> BookBloc Post : call _onEvent <====== ');
  }

  Future<BookState> _mapBookFetchedToState(BookState state) async {
    final user = await _tryGetUser();
    if (state.hasReachedMax) return state;
    try {
      if (state.status == BookStatus.initial) {
        final response = await _fetchBooks(1, user!.mainLibraryId);
        bool hasReachedMax =
            (response.currentPage >= response.totalPages ? true : false);
        return state.copyWith(
          status: BookStatus.success,
          books: response.books,
          page: response.currentPage + 1,
          hasReachedMax: hasReachedMax,
          libraryId: user.mainLibraryId,
        );
      }
      final response = await _fetchBooks(state.page, user!.mainLibraryId);
      bool hasReachedMax =
          (response.currentPage >= response.totalPages ? true : false);
      return response.books.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: BookStatus.success,
              books: List.of(state.books)..addAll(response.books),
              page: response.currentPage + 1,
              hasReachedMax: hasReachedMax,
              libraryId: user.mainLibraryId,
            );
    } on Exception {
      return state.copyWith(status: BookStatus.failure);
    }
  }

  Future<ApiResponse> _fetchBooks([int startIndex = 1, int libraryId = 0]) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    print('_fetchBooks => call api');
    var url = Uri.http(
      'liso.sweep6.nl',
      '/api/library/$libraryId/book',
      <String, String>{
        'page[number]': '$startIndex',
        'page[size]': '$_perPage'
      },
    );
    print('_fetchBooks => url : ${url.toString()}');
    final response = await httpClient.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    print('_fetchBooks => response : ${response.toString()}');
    if (response.statusCode == 200) {
      final body = json.decode(response.body)['data'] as List;
      print('_fetchBooks => body : ${body.toString()}');
      final currentPage =
          json.decode(response.body)['meta']['current_page'] as int;
      final totalPages = json.decode(response.body)['meta']['last_page'] as int;
      return ApiResponse(
        books: body.map((dynamic json) {
          return Book(
            id: json['id'] as int,
            title: json['title'] as String,
            status: json['status'] as String,
          );
        }).toList(),
        currentPage: currentPage,
        totalPages: totalPages,
      );
    }
    throw Exception('error fetching books');
  }

  Future<User?> _tryGetUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } on Exception {
      return null;
    }
  }

  Stream<BookState> _mapBookRefreshRequestedEvent(BookRefreshRequestedEvent event) async* {
    if (!state.isBookIdPresent(event.targetBookId)) {
      BookState curState = BookState();
      while (!curState.isBookIdPresent(event.targetBookId) &&
          !curState.hasReachedMax) {
        curState = await _mapBookFetchedToState(curState);
      }
      yield curState;
    }
  }
}

extension _BookIdExtension on BookState {
  bool isBookIdPresent(int id) => books.indexWhere((b) => b.id == id) != -1;
}

class ApiResponse {
  const ApiResponse(
      {required this.books,
      required this.currentPage,
      required this.totalPages});

  final List<Book> books;
  final int currentPage;
  final int totalPages;

  Object get props => [books, currentPage, totalPages];
}

class Pagination {
  const Pagination({required this.currentPage, required this.totalPages});

  final int currentPage;
  final int totalPages;

  Object get props => [currentPage, totalPages];
}
