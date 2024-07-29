import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sharish/loans/loans.dart';
import 'package:sharish/loans/widgets/custom_loan_dialog.dart';
import 'package:sharish/utils/colors_util.dart';

class LoansList extends StatefulWidget {
  @override
  _LoansListState createState() => _LoansListState();
}

class _LoansListState extends State<LoansList> {
  final _scrollController = ScrollController();
  late LoanBloc _loanBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loanBloc = context.read<LoanBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoanBloc, LoanState>(
      builder: (context, state) {
        switch (state.status) {
          case LoanStatus.failure:
            return const Center(child: Text('failed to fetch loans'));
          case LoanStatus.success:
            if (state.loans.isEmpty) {
              return const Center(child: Text('no loans'));
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 16,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return index >= state.loans.length
                    ? BottomLoader()
                    : Slidable(
                        key: ValueKey(index),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              flex: 2,
                              onPressed: (c) {
                                showDialog(
                                  context: c,
                                  barrierDismissible: true,
                                  useSafeArea: true,
                                  barrierColor: AppColor.transparent,
                                  builder: (ctx) => CustomLoanDialog(
                                    onTapRequestBack: () {
                                      BlocProvider.of<LoanBloc>(context).add(
                                        LoanReceived(
                                          loanId: state.loans[index].id,
                                          libraryId:
                                              state.loans[index].libraryId,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    },
                                    onTapCancel: () {
                                      Navigator.pop(context);
                                    },
                                    onTapEndLoan: () {
                                      Navigator.pop(context);
                                    },
                                    title: state.loans[index].book
                                        .title, // 'Clean Architecture',
                                    subTitle: '', //'Robert Martin',
                                    description: state.loans[index].user.name,
                                  ),
                                );
                              },
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              icon: Icons.arrow_back,
                              label: 'Receive',
                            ),
                          ],
                        ),
                        child: LoanListItem(loan: state.loans[index]),
                      );
              },
              itemCount: state.hasReachedMax
                  ? state.loans.length
                  : state.loans.length + 1,
              controller: _scrollController,
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) _loanBloc.add(LoanFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
