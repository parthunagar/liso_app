import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharish/login/view/login_page.dart';
import 'package:sharish/registration/bloc/registration_bloc.dart';
import 'package:sharish/registration/view/registration_page.dart';
import 'package:sharish/utils/colors_util.dart';
import 'package:sharish/utils/images_util.dart';
import 'package:sharish/widget/custom_textfield.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegistrationForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return BlocListener<RegistrationBloc, RegistrationState>(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: h * 0.15),
                  SvgPicture.asset(
                    Assets.sharishBlue,
                    color: AppColor.purple,
                  ),
                  const SizedBox(height: 26),
                  Container(
                    // color: Colors.yellow,
                    height: 530,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          // bottom: 0, //h * 0.2, // 110,
                          right: 60,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: SvgPicture.asset(
                              Assets.bookMarkGreen,
                              color: AppColor.green,
                              height: 100,
                            ),
                          ),
                        ),
                        Container(
                          height: 450,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 30, bottom: 20),
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
                                'Sign Up',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                        color: AppColor.white,
                                        fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Let's start getting to know you.",
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
                              _EmailInput(),
                              const SizedBox(height: 16),
                              _PasswordInput(),
                              const SizedBox(height: 16),
                              _ConfirmPasswordInput(),
                              const SizedBox(height: 23),
                              _RegistrationButton(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: h * 0.06),
                  _SignInTextButton(),
                  const SizedBox(height: 16)
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return CustomTextFiledWidget(
          key: const Key('registrartionForm_usernameInput_textField'),
          labelText: 'Name',
          errorText: state.username.invalid ? 'invalid username' : null,
          onChanged: (username) => context
              .read<RegistrationBloc>()
              .add(RegistrationUsernameChanged(username)),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return CustomTextFiledWidget(
          key: const Key('registrartionForm_passwordInput_textField'),
          labelText: 'E-mail',
          errorText: state.password.invalid ? 'invalid password' : null,
          obscureText: true,
          onChanged: (password) => context
              .read<RegistrationBloc>()
              .add(RegistrationEmailChanged(password)),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return CustomTextFiledWidget(
          key: const Key('registrartionForm_passwordInput_textField'),
          labelText: 'Password',
          errorText: state.password.invalid ? 'invalid password' : null,
          obscureText: true,
          onChanged: (password) => context
              .read<RegistrationBloc>()
              .add(RegistrationPasswordChanged(password)),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return CustomTextFiledWidget(
          key: const Key('registrartionForm_passwordInput_textField'),
          labelText: 'Confirm Password',
          errorText: state.password.invalid ? 'invalid password' : null,
          obscureText: true,
          onChanged: (conPassword) => context
              .read<RegistrationBloc>()
              .add(RegistrationConfirmPasswordChanged(conPassword)),
        );
      },
    );
  }
}

class _RegistrationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('registrartionForm_continue_raisedButton'),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(Size(w, 50)),
                  // padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 5,horizontal: 15)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    AppColor.white,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      // side: BorderSide(color: AppColor.white),
                    ),
                  ),
                ),
                onPressed: state.status.isValidated
                    ? () {
                        // context.read<RegistrationBloc>().add(const RegistrationSubmitted());
                      }
                    : null,
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

class _SignInTextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Already a Sharish-account? ',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: AppColor.black, fontWeight: FontWeight.normal),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            text: 'Sign in.',
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
