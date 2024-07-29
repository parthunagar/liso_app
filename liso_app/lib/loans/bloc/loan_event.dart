part of 'loan_bloc.dart';

abstract class LoanEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoanFetched extends LoanEvent {}

class LoanReceived extends LoanEvent {
  final int loanId;
  final int libraryId;

  LoanReceived({
    required this.loanId,
    required this.libraryId,
  });

  @override
  List<Object> get props => [
        loanId,
        libraryId,
      ];
}
