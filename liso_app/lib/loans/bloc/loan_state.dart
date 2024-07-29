part of 'loan_bloc.dart';

enum LoanStatus { initial, success, failure }

class LoanState extends Equatable {
  const LoanState({
    this.status = LoanStatus.initial,
    this.loans = const <Loan>[],
    this.page = 1,
    this.hasReachedMax = false,
  });

  final LoanStatus status;
  final List<Loan> loans;
  final int page;
  final bool hasReachedMax;

  LoanState copyWith({
    LoanStatus? status,
    List<Loan>? loans,
    int? page,
    bool? hasReachedMax,
  }) {
    return LoanState(
      status: status ?? this.status,
      loans: loans ?? this.loans,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''LoanState { status: $status, page: $page, hasReachedMax: $hasReachedMax, loans: ${loans.length} }''';
  }

  @override
  List<Object> get props => [status, loans, page, hasReachedMax];
}
