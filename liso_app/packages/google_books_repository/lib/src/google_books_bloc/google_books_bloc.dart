import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

import 'package:google_books_repository/google_books_repository.dart';

class GbooksSearchBloc extends Bloc<GbooksSearchEvent, GbooksSearchState> {
  GbooksSearchBloc({required this.gBooksRepository})
      : super(SearchStateEmpty()) {
    on<GbooksSearchEvent>(_onEvent,
        transformer: debounce(const Duration(milliseconds: 300)));

    on<TextChanged>(_searchItem);
  }

  final GbooksRepository gBooksRepository;

  EventTransformer<MyEvent> debounce<MyEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  FutureOr<void> _onEvent(
      GbooksSearchEvent event, Emitter<GbooksSearchState> emit) async {
    print(' ======> GbooksSearchBloc Post : call _onEvent <====== ');
  }

  void _searchItem(
      GbooksSearchEvent event, Emitter<GbooksSearchState> emit) async {
    if (event is TextChanged) {
      final searchTerm = event.text;
      if (searchTerm.isEmpty) {
        emit(SearchStateEmpty());
      } else {
        emit(SearchStateLoading());
        try {
          final results = await gBooksRepository.search(searchTerm);
          emit(SearchStateSuccess(results.items));
        } catch (error) {
          emit(error is NoSearchResult
              ? SearchStateError('no search results')
              : SearchStateError('Oeps, something went terribly wrong'));
          // yield error is SearchResultError
          //     ? SearchStateError(error.message)
          //     : SearchStateError('something went wrong 2');
        }
      }
    }
  }
}
