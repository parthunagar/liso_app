import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sharish/books/models/book.dart';
import 'package:sharish/loans/loans.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/user_repository.dart';

part 'loan_event.dart';
part 'loan_state.dart';

const _perPage = 10;

class LoanBloc extends Bloc<LoanEvent, LoanState> {
  LoanBloc({
    required this.httpClient,
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const LoanState()) {
    on<LoanEvent>(_onEvent,
        transformer: debounce(const Duration(milliseconds: 300)));

    on<LoanFetched>(
      (event, emit) async {
        final result = await _mapLoanFetchedToState(state);
        print('LoanBloc => result : $result');
        emit(result);
      },
    );

    on<LoanReceived>(_mapLoanReceivedToState);
  }

  final http.Client httpClient;
  final UserRepository _userRepository;

  EventTransformer<MyEvent> debounce<MyEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  FutureOr<void> _onEvent(LoanEvent event, Emitter<LoanState> emit) async {
    print(' ======> Loan : call _onEvent <====== ');
  }

  Future<LoanState> _mapLoanFetchedToState(LoanState state) async {
    final user = await _tryGetUser();
    if (state.hasReachedMax) return state;
    try {
      if (state.status == LoanStatus.initial) {
        final response = await _fetchLoans(1, user!.mainLibraryId);
        print('_mapLoanFetchedToState => response : ${response}');
        bool hasReachedMax =
            (response.currentPage >= response.totalPages ? true : false);
        return state.copyWith(
          status: LoanStatus.success,
          loans: response.loans,
          page: response.currentPage + 1,
          hasReachedMax: hasReachedMax,
        );
      }
      final response = await _fetchLoans(state.page, user!.mainLibraryId);
      print('_mapLoanFetchedToState => response 1 : ${response}');
      bool hasReachedMax =
          (response.currentPage >= response.totalPages ? true : false);
      return response.loans.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: LoanStatus.success,
              loans: List.of(state.loans)..addAll(response.loans),
              page: response.currentPage + 1,
              hasReachedMax: hasReachedMax,
            );
    } on Exception {
      return state.copyWith(status: LoanStatus.failure);
    }
  }

  Future<ApiResponse> _fetchLoans(
      [int startIndex = 1, int libraryId = 0]) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    var url = Uri.http(
      'liso.sweep6.nl',
      '/api/library/$libraryId/loan',
      <String, String>{
        'page[number]': '$startIndex',
        'page[size]': '$_perPage',
        'status': 'open',
      },
    );

    final response = await httpClient.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body)['data'] as List;
      print(body);
      //final pagination = json.decode(response.body)['pagination'] as Pagination;
      final currentPage =
          json.decode(response.body)['meta']['current_page'] as int;
      final totalPages = json.decode(response.body)['meta']['last_page'] as int;
      return ApiResponse(
        loans: body.map((dynamic json) {
          return Loan(
            id: json['id'] as int,
            libraryId: json['libraryId'] as int,
            book: Book.fromJson(json['book']),
            user: SimpleUser.fromJson(json['user']),
          );
        }).toList(),
        currentPage: currentPage,
        totalPages: totalPages,
      );
    }
    throw Exception('error fetching loans');
  }

  Future<User?> _tryGetUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } on Exception {
      return null;
    }
  }

  void _mapLoanReceivedToState(
      LoanReceived event, Emitter<LoanState> emit) async {
    final bool isSuccess = await _receiveLoan(
      loanId: event.loanId,
      libraryId: event.libraryId,
    );
    print('_mapLoanReceivedToState => isSuccess : $isSuccess');
    if (isSuccess) {
      final List<Loan> loans = List.of(state.loans)
        ..removeWhere((Loan loan) =>
            loan.id == event.loanId && loan.libraryId == event.libraryId);
      emit(state.copyWith(loans: loans));
    }
  }

  Future<bool> _receiveLoan({
    required int loanId,
    required int libraryId,
  }) async {
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');

      var url = Uri.parse(
          'http://liso.sweep6.nl/api/library/$libraryId/loan/$loanId/receive');

      Map<String, String> headerValues = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final response = await http.Client().patch(
        url,
        headers: headerValues,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

class ApiResponse {
  const ApiResponse(
      {required this.loans,
      required this.currentPage,
      required this.totalPages});

  final List<Loan> loans;
  final int currentPage;
  final int totalPages;

  Object get props => [loans, currentPage, totalPages];
}

class Pagination {
  const Pagination({required this.currentPage, required this.totalPages});

  final int currentPage;
  final int totalPages;

  Object get props => [currentPage, totalPages];
}
