import 'package:equatable/equatable.dart';

import 'package:google_books_repository/google_books_repository.dart';

abstract class GbooksSearchState extends Equatable {
  const GbooksSearchState();

  @override
  List<Object> get props => [];
}

class SearchStateEmpty extends GbooksSearchState {}

class SearchStateLoading extends GbooksSearchState {}

class SearchStateSuccess extends GbooksSearchState {
  const SearchStateSuccess(this.items);

  final List<SearchResultItem> items;

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'SearchStateSuccess { items: ${items.length} }';
}

class SearchStateError extends GbooksSearchState {
  const SearchStateError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
