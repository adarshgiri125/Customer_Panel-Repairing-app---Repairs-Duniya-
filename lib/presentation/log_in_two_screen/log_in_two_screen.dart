import 'package:customer_app/core/app_export.dart';
import 'package:customer_app/presentation/otp_one_screen/otp_one_screen.dart';
import 'package:customer_app/widgets/custom_checkbox_button.dart';
import 'package:customer_app/widgets/custom_elevated_button.dart';
import 'package:customer_app/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInOneScreen extends StatefulWidget {
  LogInOneScreen({Key? key}) : super(key: key);

  @override
  _LogInOneScreenState createState() => _LogInOneScreenState();
}

class _LogInOneScreenState extends State<LogInOneScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  bool rememberForDays = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.5, 0),
              end: Alignment(0.5, 1),
              colors: [
                theme.colorScheme.onError,
                appTheme.gray50,
              ],
            ),
          ),
          child: Form(
            key: _formKey,
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(
                left: 23.h,
                top: 72.v,
                right: 23.h,
              ),
              child: Column(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgEllipse12,
                    height: 65.adaptSize,
                    width: 65.adaptSize,
                    radius: BorderRadius.circular(
                      32.h,
                    ),
                  ),
                  SizedBox(height: 27.v),
                  Text(
                    "Log in to your account",
                    style: theme.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 10.v),
                  Text(
                    "Welcome back! Please enter your details.",
                    style: CustomTextStyles.bodyLargeBluegray700,
                  ),
                  SizedBox(height: 33.v),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 3.h),
                      child: Text(
                        "Phone number",
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                  ),
                  SizedBox(height: 7.v),
                  CustomTextFormField(
                    controller: phoneNumberController,
                    hintText: "Enter your phone number",
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.phone,
                  ),
                  SizedBox(height: 24.v),
                  _buildRememberForDays(context),
                  SizedBox(height: 24.v),
                  CustomElevatedButton(
                    text: "Log in",
                    onPressed: () {
                      _verifyPhoneNumber();
                    },
                  ),
                  SizedBox(height: 33.v),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 1.v),
                        child: Text(
                          "Don’t have an account?",
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.h),
                        child: Text(
                          "Sign up",
                          style: CustomTextStyles.titleSmallPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.v),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRememberForDays(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 3.h),
        child: CustomCheckboxButton(
          alignment: Alignment.centerLeft,
          text: "Remember for 30 days",
          value: rememberForDays,
          padding: EdgeInsets.symmetric(vertical: 1.v),
          onChange: (value) {
            setState(() {
              rememberForDays = value;
            });
          },
        ),
      ),
    );
  }

  // verification of phone number (Authentication)

  void _verifyPhoneNumber() async {
    String phoneNumber = '+91' + phoneNumberController.text.trim();

    // Perform phone number validation if needed
    if (phoneNumber.length != 13) {
      // Show an error message or handle the invalid phone number
      print('Invalid phone number. Please enter a 10-digit number.');

      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invalid phone number'),
      ),
    );
      return;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieve the SMS code on Android
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle verification failed
        print('Verification Failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        // Navigate to OTP screen with verificationId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpOneScreen(verificationId: verificationId,phoneNumber: phoneNumber),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle code auto-retrieval timeout
      },
    );
  }
}
