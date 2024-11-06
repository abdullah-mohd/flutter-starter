import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/core/extensions/app_consumer_state.dart';
import 'package:app/core/theme/app_text.dart';
import 'package:app/core/theme/theme.dart';
import 'package:app/core/utils/validations_mixin.dart';
import 'package:app/features/authentication/login/login_page.dart';
import 'package:app/features/authentication/register/register_view_model.dart';
import 'package:app/features/dashboard/dashboard_root.dart';
import 'package:app/features/widgets/_app_form_widgets.dart';
import 'package:app/features/widgets/buttons/google_sign_in_button.dart';
import 'package:app/features/widgets/const_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

class RegisterPage extends ConsumerStatefulWidget {
  static String get name => 'Register';

  static String get path => '/register';
  const RegisterPage({super.key});

  @override
  AppConsumerState<ConsumerStatefulWidget> createState() =>
      _RegisterPageState();
}

class _RegisterPageState extends AppConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final viewModel = ref.read(viewModelProvider);

    viewModel.init();
    viewModel.setAppConsumerState(this);
    super.initState();
  }

  Future<void> sendEmailConfirmation() async {
    final viewModel = ref.watch(viewModelProvider);

    await viewModel.onPasswordConfirmed();
    showSnackBarMessage(
      'Verification email sent.',
      Colors.black,
    );
  }

  Future<void> showConfirmationDialog() async {}

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(themeProvider).current.themeData;

    final viewModel = ref.watch(viewModelProvider);
    // final constWebPad = context.layout.width * 0.25;
    // final isLowWidth = context.layout.width <= 600;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DecoratedBox(
        decoration: BoxDecoration(color: appTheme.scaffoldBackgroundColor),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: SizedBox(
              height: context.layout.height < 600 ? 600 : context.layout.height,
              width: context.layout.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: 80.0,
                      bottom: 10,
                      // left: context.layout.width * 0.35,
                      // right: context.layout.width * 0.35,
                    ),
                    child: appLogo(context, height: 40),
                  ),

                  AppText(
                    'SIGN UP',
                    fontWeight: FontWeight.w800,
                    fontSize: 26,
                    fontFamily: GoogleFonts.montserrat().fontFamily!,
                    color: Colors.black,
                  ),
                  sized(h: 40),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25,

                      // horizontal: !isLowWidth ? constWebPad : 15,
                      vertical: 10,
                    ),
                    child: AppTextField(
                      action: TextInputAction.next,
                      onSaved: (value) {
                        viewModel.updateFName(value!);
                      },
                      value: viewModel.firstName,
                      label: "First Name",
                      hint: "Enter your first name",
                      onChanged: (value) {
                        viewModel.updateFName(value);
                      },
                      validator: (v) => ValidationsMixin.isFNameValid(v),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25,

                      // horizontal: !isLowWidth ? constWebPad : 15,
                      vertical: 10,
                    ),
                    child: AppTextField(
                      action: TextInputAction.next,
                      onSaved: (value) {
                        viewModel.updateLName(value!);
                      },
                      value: viewModel.lastName,
                      label: "Last Name",
                      hint: "Enter your last name",
                      onChanged: (value) {
                        viewModel.updateLName(value);
                      },
                      validator: (v) => ValidationsMixin.isLNameValid(v),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25, // !isLowWidth ? constWebPad : 15,
                      vertical: 10,
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
                      hint: "Enter a valid email address",
                      onChanged: (value) {
                        viewModel.updateEmail(value);
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25,
                      // !isLowWidth ? constWebPad : 15,
                      vertical: 10,
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

                  // sized(
                  //   h: 20,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15),
                  //   child: IntlPhoneField(
                  //     style: appTheme.textTheme.bodyMedium!
                  //         .copyWith(color: Colors.white),
                  //     dropdownTextStyle: appTheme.textTheme.bodyMedium!
                  //         .copyWith(color: Colors.white),
                  //     decoration: InputDecoration(
                  //       filled: true,
                  //       fillColor:
                  //           const Color.fromRGBO(136, 136, 136, 0.26),
                  //       alignLabelWithHint: false,
                  //       counter: Container(),
                  //       labelText: 'Phone Number',
                  //       border: OutlineInputBorder(
                  //         borderSide: BorderSide.none,
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //     ),
                  //     initialCountryCode: 'RO',
                  //     onSaved: (phone) {
                  //       viewModel.updatePhone(phone!.completeNumber);
                  //     },
                  //     onChanged: (phone) {
                  //       viewModel.updatePhone(phone.completeNumber);
                  //     },
                  //     validator: (p0) {
                  //       return ValidationsMixin.isPhoneValid(
                  //         p0?.completeNumber,
                  //       );
                  //     },
                  //   ),
                  // ),

                  // AppButton(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15),
                  //   disabled: viewModel.phoneOTPDisabled,
                  //   onPressed: () {
                  //     //logInfo('pressed');
                  //     showAppDialog();
                  //     viewModel.verifyPhoneNumber();
                  //   },
                  //   text: 'Verify Phone',
                  // ),
                  const Spacer(),
                  SizedBox(
                    width: kIsWeb
                        ? context.layout.width * 0.7
                        : context.layout.width,
                    child: AppButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      disabled: viewModel.signUpDisabled || viewModel.loading,
                      onPressed: () async {
                        final form = _formKey.currentState;
                        if (form!.validate()) {
                          form.save();
                          await sendEmailConfirmation();
                          await viewModel.registerUser();
                          navigationGo(DashboardRoot.path);
                        }
                      },
                      text: 'Sign Up',
                    ),
                  ),
                  sized(h: 20),
                  if (viewModel.loading)
                    Container()
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: kIsWeb
                              ? context.layout.width * 0.7
                              : context.layout.width,
                          child: GoogleSignInButton(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            disabled: viewModel.loading,
                            onPressed: () {
                              viewModel.registerWithGoogle();
                            },
                            text: 'Sign up with Google',
                          ),
                        ),
                      ],
                    ),
                  sized(h: 25),

                  TextButton(
                    onPressed: () {
                      navigationGo(LoginPage.path);
                    },
                    child: Text(
                      'Already have an account? Sign in',
                      style: appTheme.textTheme.bodySmall!.copyWith(
                        color: appTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                  sized(h: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
