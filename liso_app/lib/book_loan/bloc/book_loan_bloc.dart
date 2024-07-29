import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formz/formz.dart';
import 'package:http/http.dart' as http;
import 'package:sharish/book_loan/models/person_email.dart';
import 'package:sharish/book_loan/models/person_name.dart';

part 'book_loan_event.dart';
part 'book_loan_state.dart';

class BookLoanBloc extends Bloc<BookLoanEvent, BookLoanState> {
  BookLoanBloc({
    required int libraryId, 
    required int bookId,
  })  : _bookId = bookId,
        _libraryId = libraryId,
        super(const BookLoanState()) {
    on<BookLoanNameChangedEvent>(_mapBookLoanNameChangedEvent);
    on<BookLoanEmailChangedEvent>(_mapBookLoanEmailChangedEvent);
    on<BookLoanSubmittedEvent>(_mapBookLoanSubmittedEvent);
  }

  final int _libraryId;
  final int _bookId;

  Future<void> _mapBookLoanNameChangedEvent(
      BookLoanNameChangedEvent event, Emitter<BookLoanState> emit) async {
    emit(state.copyWith(personName: PersonName.dirty(event.name)));
  }

  Future<void> _mapBookLoanEmailChangedEvent(
      BookLoanEmailChangedEvent event, Emitter<BookLoanState> emit) async {
    emit(state.copyWith(personEmail: PersonEmail.dirty(event.email)));
  }

  FutureOr<void> _mapBookLoanSubmittedEvent(
    BookLoanSubmittedEvent event,
    Emitter<BookLoanState> emit,
  ) async {
    if (state.status.isValidated || state.status.isSubmissionFailure) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        await _postLoan();
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } catch (e) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }

  Future<void> _postLoan() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    final url = Uri.parse('http://liso.sweep6.nl/api/library/$_libraryId/loan');

    final headerValues = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final body = {
      'user': {
        'name': state.personName.value,
        'email': state.personEmail.value,
      },
      'libraryId': _libraryId,
      'bookId': _bookId,
    };

    final response = await http.Client().post(
      url,
      headers: headerValues,
      body: json.encode(body),
    );
    assert(response.statusCode == 201, 'Loan posting error occurred');
  }
}
