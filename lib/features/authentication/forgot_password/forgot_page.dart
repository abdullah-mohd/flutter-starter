import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/core/extensions/app_consumer_state.dart';
import 'package:app/core/theme/theme.dart';
import 'package:app/core/utils/validations_mixin.dart';
import 'package:app/features/authentication/forgot_password/forgot_view_model.dart';
import 'package:app/features/authentication/login/login_page.dart';
import 'package:app/features/widgets/buttons/app_button.dart';
import 'package:app/features/widgets/const_widgets.dart';
import 'package:app/features/widgets/form_inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  static String get name => 'Forgot Password';

  static String get path => '/forgotPassword';
  @override
  AppConsumerState<ConsumerStatefulWidget> createState() {
    return _ForgotPasswordState();
  }
}

class _ForgotPasswordState extends AppConsumerState<ForgotPassword> {
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DecoratedBox(
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
                        // left: context.layout.width * 0.35,
                        // right: context.layout.width * 0.35,
                      ),
                      child: Center(
                        child: appLogo(context, height: 100),
                      ),
                    ),
                    Text(
                      'Reset Password',
                      style: appTheme.textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 26,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        color: Colors.black,
                      ),
                    ),
                    sized(h: 60),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        // kIsWeb ? context.layout.width * 0.25 : 15,
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
                    const Spacer(),
                    if (viewModel.loading)
                      const Padding(
                        padding: EdgeInsets.all(4),
                        child: AppLoader(),
                      )
                    else
                      SizedBox(
                        width: kIsWeb
                            ? context.layout.width * 0.7
                            : context.layout.width,
                        child: AppButton(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0, //20,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              viewModel.forgotPassword();
                            }
                          },
                          text: 'Send Reset Link',
                        ),
                      ),
                    sized(h: 20),
                    TextButton(
                      onPressed: () {
                        navigationGo(LoginPage.path);
                      },
                      child: Text(
                        "Sign in now",
                        style: appTheme.textTheme.bodySmall!.copyWith(
                          // ignore: deprecated_member_use
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
