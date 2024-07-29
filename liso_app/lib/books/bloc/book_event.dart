part of 'book_bloc.dart';

abstract class BookEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BookFetched extends BookEvent {}

class BookRefreshRequestedEvent extends BookEvent {
  BookRefreshRequestedEvent(this.targetBookId);
  
  final int targetBookId;

  @override
  List<Object> get props => [targetBookId];

  @override
  bool? get stringify => true;
}
