import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/core/extensions/app_consumer_state.dart';
import 'package:app/core/theme/theme.dart';
import 'package:app/core/utils/validations_mixin.dart';
import 'package:app/features/authentication/forgot_password/forgot_page.dart';
import 'package:app/features/authentication/login/login_view_model.dart';
import 'package:app/features/authentication/register/register_page.dart';
import 'package:app/features/widgets/buttons/app_button.dart';
import 'package:app/features/widgets/buttons/google_sign_in_button.dart';
import 'package:app/features/widgets/const_widgets.dart';
import 'package:app/features/widgets/form_inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  static String get name => 'Login';

  static String get path => '/login';
  @override
  AppConsumerState<ConsumerStatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends AppConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final viewModel = ref.read(viewModelProvider);
    viewModel.init();
    viewModel.setAppConsumerState(this);

    super.initState();
  }

  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(themeProvider).current.themeData;
    final viewModel = ref.watch(viewModelProvider);
    // final isLowWidth = context.layout.width <= 600;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: context.layout.height,
        decoration: BoxDecoration(
          color: appTheme.scaffoldBackgroundColor,
        ),
        child: Form(
          key: _formKey,
          child: Align(
            child: SingleChildScrollView(
              child: SizedBox(
                height:
                    context.layout.height < 600 ? 600 : context.layout.height,
                width: context.layout.width,
                child: Column(
                  children: <Widget>[
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 40.0,
                        bottom: 20,
                        left: 25,
                        right: 25,
                        // left: !isLowWidth ? context.layout.width * 0.35 : 20,
                        // right:
                        //     !isLowWidth ? context.layout.width * 0.35 : 20),
                      ),
                      child: appLogo(
                        context,
                        fit: BoxFit.fitWidth,
                        height: 100,
                      ),
                    ),
                    Text(
                      'SIGN IN',
                      style: appTheme.textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 26,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        color: Colors.black,
                      ),
                    ),
                    sized(h: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        // !isLowWidth ? context.layout.width * 0.25 : 15,
                      ),
                      child: AppTextField(
                        action: TextInputAction.next,
                        value: viewModel.email,
                        onSaved: (value) {
                          if (value != null) {
                            viewModel.updateEmail(value);
                          }
                        },
                        label: "Email",
                        validator: (v) => ValidationsMixin.isEmailValid(v),
                        hint: "Enter your email address",
                        onChanged: (value) {
                          viewModel.updateEmail(value);
                        },
                      ),
                    ),
                    sized(
                      h: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        // !isLowWidth ? context.layout.width * 0.25 : 15,
                      ),
                      child: AppTextField(
                        action: TextInputAction.next,
                        suffixIcon: InkWell(
                          onTap: () {
                            viewModel.togglePasswordVisibility();
                          },
                          child: Icon(
                            viewModel.passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                        ),
                        value: viewModel.password,
                        onSaved: (value) {
                          if (value != null) {
                            viewModel.updatePassword(value);
                          }
                        },
                        obscureText: !viewModel.passwordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        label: "Password ",
                        validator: (v) => ValidationsMixin.isPasswordValid(v),
                        hint: "Enter a strong password",
                        onChanged: (value) {
                          viewModel.updatePassword(value);
                        },
                      ),
                    ),
                    sized(h: 15),
                    TextButton(
                      onPressed: () {
                        navigationGo(ForgotPassword.path);
                      },
                      child: Text(
                        "Forgot Password?",
                        style: appTheme.textTheme.bodySmall!.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (viewModel.loading)
                      const AppLoader()
                    else
                      SizedBox(
                        width: kIsWeb
                            ? context.layout.width * 0.7
                            : context.layout.width,
                        child: AppButton(
                          autoFocus: true,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          disabled: viewModel.loading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              viewModel.login();
                            }
                          },
                          text: 'Sign In',
                        ),
                      ),
                    sized(h: 16),
                    if (viewModel.loading)
                      Container()
                    else
                      SizedBox(
                        width: kIsWeb
                            ? context.layout.width * 0.7
                            : context.layout.width,
                        child: GoogleSignInButton(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          disabled: viewModel.loading,
                          onPressed: () {
                            viewModel.loginWithGoogle();
                          },
                          text: 'Sign in with Google',
                        ),
                      ),
                    sized(h: 16),
                    TextButton(
                      onPressed: () {
                        navigationGo(RegisterPage.path);
                      },
                      child: Text(
                        "Don't have an account? Sign Up",
                        style: appTheme.textTheme.bodySmall!.copyWith(
                          color: appTheme.colorScheme.onBackground,
                        ),
                      ),
                    ),
                    sized(h: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
