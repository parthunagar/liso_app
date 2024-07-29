import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharish/loans/loans.dart';
import 'package:http/http.dart' as http;
import 'package:user_repository/user_repository.dart';

class LoansPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoanBloc(
            httpClient: http.Client(), userRepository: UserRepository())
          ..add(LoanFetched()),
        child: LoansList(),
      ),
    );
  }
}
