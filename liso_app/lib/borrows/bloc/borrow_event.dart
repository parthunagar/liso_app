part of 'borrow_bloc.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BorrowFetched extends PostEvent {}

class BorrwBookEvent extends PostEvent {
  BorrwBookEvent(this.targetBookId);
  
  final int targetBookId;

  @override
  List<Object> get props => [targetBookId];

  @override
  bool? get stringify => true;
}
