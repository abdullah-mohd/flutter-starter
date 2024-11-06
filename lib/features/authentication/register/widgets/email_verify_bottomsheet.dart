import 'package:app/core/extensions/app_consumer_state.dart';
import 'package:app/core/theme/app_text.dart';
import 'package:app/core/theme/theme.dart';
import 'package:app/features/authentication/register/register_view_model.dart';
import 'package:app/features/widgets/_app_form_widgets.dart';
import 'package:app/features/widgets/const_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

class EmailVerificationBottomSheet extends ConsumerStatefulWidget {
  const EmailVerificationBottomSheet({
    super.key,
  });
  @override
  AppConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailVerificationBottomSheetState();
}

class _EmailVerificationBottomSheetState
    extends AppConsumerState<EmailVerificationBottomSheet> {
  @override
  void initState() {
    super.initState();
    final vm = ref.read(viewModelProvider);
    vm.init();
    vm.setAppConsumerState(this);
    vm.onPasswordConfirmed();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final appTheme = ref.watch(themeProvider).current.themeData;
    final viewModel = ref.watch(viewModelProvider);

    return BottomSheet(
      constraints: BoxConstraints(
        minHeight: context.layout.height / 2,
        maxHeight: context.layout.height / 1.6,
        minWidth: context.layout.width,
      ),
      onClosing: () {
        //logInfo('closing password');
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0x806F3DD3)),
      ),
      backgroundColor: appTheme.scaffoldBackgroundColor,
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            backgroundColor: appTheme.scaffoldBackgroundColor,
            title: const AppText('Email Verification'),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sized(h: 10),
                const Flexible(
                  child: AppText(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    'Confirmation Link has been sent to your email address. Please verify.',
                    textAlign: TextAlign.left,
                  ),
                ),
                sized(h: 40),

                Center(
                  child: AppText(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    viewModel.isEmailVerified
                        ? 'Email Verified'
                        : 'Email Not Verified',
                    textAlign: TextAlign.center,
                  ),
                ),

                // Flexible(
                //   flex: 2,
                //   child: Container(
                //     margin: const EdgeInsets.symmetric(horizontal: 15),
                //     child: AppTextField(
                //       action: TextInputAction.next,
                //       value: viewModel.emailOtp,
                //       onSaved: (value) {
                //         if (value != null) {
                //           viewModel.updateEmailOtp(value);
                //         }
                //       },
                //       keyboardType: TextInputType.number,
                //       label: "Email OTP ",
                //       validator: (v) => v!.isNotEmpty && v.length == 6
                //           ? null
                //           : "Please enter your OTP",
                //       hint: "Confirm your password",
                //       onChanged: (value) {
                //         viewModel.updateEmailOtp(value);
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          AppButton(
            disabled: viewModel.isEmailVerified,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            onPressed: viewModel.onPasswordConfirmed,
            text: 'Confirmed',
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
