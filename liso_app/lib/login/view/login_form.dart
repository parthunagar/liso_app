import 'package:authentication_repository/utils/toast_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharish/login/login.dart';
import 'package:sharish/registration/bloc/registration_bloc.dart';
import 'package:sharish/registration/view/registration_page.dart';
import 'package:sharish/utils/colors_util.dart';
import 'package:sharish/utils/images_util.dart';
import 'package:sharish/widget/custom_textfield.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: h / 2,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(
                Assets.whiteDot,
                color: AppColor.backgroungPattern,
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: h * 0.15),
                  SvgPicture.asset(
                    Assets.sharishBlue,
                    color: AppColor.purple,
                  ),
                  const SizedBox(height: 26),
                  Column(
                    children: [
                      Container(
                        // height: 320,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 30,
                          bottom: 20,
                        ),
                        // height: 550,
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColor.purple,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sign in',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                    color: AppColor.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Let's start sharing things you love.",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(height: 16),
                            _UsernameInput(),
                            const SizedBox(height: 16),
                            _PasswordInput(),
                            const SizedBox(height: 23),
                            _LoginButton(),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 60),
                        // bottom: 0, //h * 0.2, // 110,
                        // right: 60,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: SvgPicture.asset(
                            Assets.bookMarkGreen,
                            color: AppColor.green,
                            height: 100,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.2),
                  _SignUpTextButton(),
                  const SizedBox(height: 16)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  // TextEditingController cEmail = TextEditingController(text: 'robertbouten@gmail.com');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return CustomTextFiledWidget(
          // controller: cEmail,
          cursorColor: AppColor.white,
          key: const Key('loginForm_usernameInput_textField'),
          labelText: 'E-mail',
          errorText: state.username.invalid ? 'invalid username' : null,
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
        );
        // return TextField(
        //   key: const Key('loginForm_usernameInput_textField'),
        //   onChanged: (username) =>
        //       context.read<LoginBloc>().add(LoginUsernameChanged(username)),
        //   decoration: InputDecoration(
        //     labelText: 'username',
        //     errorText: state.username.invalid ? 'invalid username' : null,
        //   ),
        // );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  // TextEditingController cPass = TextEditingController(text: 'test123456');
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return CustomTextFiledWidget(
          // controller: cPass,
          cursorColor: AppColor.white,
          key: const Key('loginForm_passwordInput_textField'),
          labelText: 'password',
          errorText: state.password.invalid ? 'invalid password' : null,
          obscureText: true,
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
        );
        // return TextField(
        //   key: const Key('loginForm_passwordInput_textField'),
        // onChanged: (password) =>
        //     context.read<LoginBloc>().add(LoginPasswordChanged(password)),
        //   obscureText: true,
        //   decoration: InputDecoration(
        //     labelText: 'password',
        //     errorText: state.password.invalid ? 'invalid password' : null,
        //   ),
        // );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColor.white,
                ),
              )
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(Size(w, 50)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    AppColor.white,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                onPressed: state.status.isValidated
                    ? () {
                        print(' ===> On CLick Sign in Button <=== ');
                        context.read<LoginBloc>().add(const LoginSubmitted());
                      }
                    : () {
                        AppToast().showToast(
                            'Please Enter the Username or Passwrod.');
                      },
                child: Text(
                  'Start sharing',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: AppColor.purple,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              );
      },
    );
  }
}

class _SignUpTextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'No Sharish-account? ',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: AppColor.black, fontWeight: FontWeight.normal),
          ),
          TextSpan(
            text: 'Sign up.',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistrationPage(
                        // bookBloc: BlocProvider.of<BookBloc>(ctx),
                        ),
                  ),
                );
              },
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: AppColor.black,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.underline,
                ),
          )
        ],
      ),
    );
  }
}
