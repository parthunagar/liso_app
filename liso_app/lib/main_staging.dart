// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:bloc/bloc.dart';
import 'package:sharish/app/app.dart';
import 'package:sharish/app/app_bloc_observer.dart';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  print(' ======> Main Staging <====== ');
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  runZonedGuarded(
    () {
      BlocOverrides.runZoned(
        () => runApp(App(
          authenticationRepository: AuthenticationRepository(),
          userRepository: UserRepository(),
        )),
        blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) => log('ERROR : $error', stackTrace: stackTrace),
  );
}
