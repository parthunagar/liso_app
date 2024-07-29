import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sharish/borrows/borrows.dart';
import 'package:sharish/books/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:user_repository/user_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'borrow_event.dart';
part 'borrow_state.dart';

const _perPage = 10;

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({
    required this.httpClient,
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const PostState()) {
    on<PostEvent>(_onEvent,
        transformer: debounce(const Duration(milliseconds: 300)));

    on<BorrowFetched>(
      (event, emit) async {
        final result = await _mapPostFetchedToState(state);
        emit(result);
      },
    );
  }

  final http.Client httpClient;
  final UserRepository _userRepository;

  EventTransformer<MyEvent> debounce<MyEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  FutureOr<void> _onEvent(PostEvent event, Emitter<PostState> emit) async {
    print(' ======> PostBloc Post : call _onEvent <====== ');
    // TODO: logic goes here...
  }

  Future<PostState> _mapPostFetchedToState(PostState state) async {
    final user = await _tryGetUser();
    if (state.hasReachedMax) return state;
    try {
      if (state.status == PostStatus.initial) {
        final response = await _fetchBorrows(1, user!.id);
        print('_mapPostFetchedToState => response : ${response.toString()}');
        bool hasReachedMax =
            (response.currentPage >= response.totalPages ? true : false);
        return state.copyWith(
          status: PostStatus.success,
          posts: response.posts,
          page: response.currentPage + 1,
          hasReachedMax: hasReachedMax,
        );
      }
      final response = await _fetchBorrows(state.page, user!.id);
      bool hasReachedMax =
          (response.currentPage >= response.totalPages ? true : false);
      return response.posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: PostStatus.success,
              posts: List.of(state.posts)..addAll(response.posts),
              page: response.currentPage + 1,
              hasReachedMax: hasReachedMax,
            );
    } on Exception {
      return state.copyWith(status: PostStatus.failure);
    }
  }

  // Future<List<Post>>
  Future<ApiResponse> _fetchBorrows([int startIndex = 1, String userId = '0']) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    print('_fetchBorrows => call api');
    var url = Uri.http(
      'liso.sweep6.nl',
      '/api/user/$userId/borrow',
      <String, String>{
        'page[number]': '$startIndex',
        'page[size]': '$_perPage'
      },
    );
    print('_fetchBorrows => url : ${url.toString()}');
    final response = await httpClient.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    print('_fetchBorrows => response : ${response.toString()}');
    if (response.statusCode == 200) {
      final body = json.decode(response.body)['data'] as List;
      print('_fetchBorrows => response : ${body.toString()}');
      //final pagination = json.decode(response.body)['pagination'] as Pagination;
      final currentPage =
          json.decode(response.body)['meta']['current_page'] as int;
      final totalPages = json.decode(response.body)['meta']['last_page'] as int;
      return ApiResponse(
        posts: body.map((dynamic json) {
          return Borrow(
            id: json['id'] as int,
            libraryId: json['libraryId'] as int,
            libraryName: json['libraryName'] as String,
            book: Book.fromJson(json['book']),
            user: SimpleUser.fromJson(json['user']),
          );
        }).toList(),
        currentPage: currentPage,
        totalPages: totalPages,
      );
    }
    throw Exception('error fetching posts');
  }

  Future<User?> _tryGetUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } on Exception {
      return null;
    }
  }
}

class ApiResponse {
  const ApiResponse(
      {required this.posts,
      required this.currentPage,
      required this.totalPages});

  final List<Borrow> posts;
  final int currentPage;
  final int totalPages;

  Object get props => [posts, currentPage, totalPages];
}

class Pagination {
  const Pagination({required this.currentPage, required this.totalPages});

  final int currentPage;
  final int totalPages;

  Object get props => [currentPage, totalPages];
}
