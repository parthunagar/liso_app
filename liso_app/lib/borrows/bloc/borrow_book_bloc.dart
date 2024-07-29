import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formz/formz.dart';
import 'package:http/http.dart' as http;
import 'package:sharish/borrows/models/borrow_book.dart';
import 'package:sharish/borrows/models/borrow_person_email.dart';
import 'package:sharish/borrows/models/borrow_person_name.dart';
part 'borrow_book_event.dart';
part 'borrow_book_state.dart';

class BorrowBookBloc extends Bloc<BorrowBookEvent, BorrowBookState> {
  BorrowBookBloc({required BorrowBook borrowBook})
      : _borrowBook = borrowBook,
        super(const BorrowBookState()) {
    on<BorrowBookNameChangedEvent>(_mapBorrwBookNameChangedEvent);
    on<BorrowBookEmailChangedEvent>(_mapBorrowBookEmailChangedEvent);
    on<BorrowBookSubmittedEvent>(_mapBorrowBookSubmittedEvent);
  }

  final BorrowBook _borrowBook;

  Future<void> _mapBorrwBookNameChangedEvent(
      BorrowBookNameChangedEvent event, Emitter<BorrowBookState> emit) async {
    emit(state.copyWith(personName: BorrowPersonName.dirty(event.name)));
  }

  Future<void> _mapBorrowBookEmailChangedEvent(
      BorrowBookEmailChangedEvent event, Emitter<BorrowBookState> emit) async {
    emit(state.copyWith(personEmail: BorrowPersonEmail.dirty(event.email)));
  }

  FutureOr<void> _mapBorrowBookSubmittedEvent(
    BorrowBookSubmittedEvent event,
    Emitter<BorrowBookState> emit,
  ) async {
    if (state.status.isValidated || state.status.isSubmissionFailure) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        await createBorrow();
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } catch (e) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }

  Future<void> createBorrow() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    final url = Uri.parse('http://liso.sweep6.nl/api/borrow');

    final headerValues = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final body = {
      "book": {
        "title": _borrowBook.title,
        "authors": _borrowBook.authors,
        "isbn13": _borrowBook.isbn13
      },
      "libraryOwner": {
        "name": state.personName.value,
        "email": state.personEmail.value
      }
    };
    print('_postLoan => body : ${body.toString()}');
    final response = await http.Client().post(
      url,
      headers: headerValues,
      body: json.encode(body),
    );
    print('_postLoan => response : ${response.toString()}');
    assert(response.statusCode == 201, 'Borrow creating error occurred');
  }
}
