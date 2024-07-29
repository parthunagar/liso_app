import 'package:flutter/material.dart';
import 'package:sharish/splash/view/splash_widget.dart';

class SplashPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
    // return Scaffold(
    //   body: SplashWidget(),
    // );
  }
}
