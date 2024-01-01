import 'package:customer_app/core/app_export.dart';
import 'package:customer_app/presentation/home_page_screen/home_page_screen.dart';
import 'package:customer_app/widgets/custom_elevated_button.dart';
import 'package:customer_app/widgets/custom_pin_code_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpOneScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  OtpOneScreen(
      {Key? key, required this.verificationId, required this.phoneNumber})
      : super(key: key);

  @override
  _OtpOneScreenState createState() => _OtpOneScreenState();
}

class _OtpOneScreenState extends State<OtpOneScreen> {
  final TextEditingController otpController = TextEditingController();
  bool flag = false;
  String otp = '';

  

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
                appTheme.gray5001,
              ],
            ),
          ),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(
              left: 24.h,
              top: 61.v,
              right: 24.h,
            ),
            child: Column(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgImage69,
                  height: 172.adaptSize,
                  width: 172.adaptSize,
                ),
                SizedBox(height: 24.v),
                Text(
                  "OTP Verification",
                  style: theme.textTheme.headlineSmall,
                ),
                SizedBox(height: 10.v),
                SizedBox(
                  width: 226.h,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "We sent a verification ",
                          style: CustomTextStyles.bodyLargeInterBluegray700,
                        ),
                        TextSpan(
                          text: "code",
                          style: CustomTextStyles.bodyLargeInterBluegray700,
                        ),
                        TextSpan(
                          text: " to ",
                          style: CustomTextStyles.bodyLargeInterBluegray700,
                        ),
                        TextSpan(
                          text: widget.phoneNumber,
                          style: CustomTextStyles.titleMediumInterBluegray700,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30.v),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 51.h),
                  child: CustomPinCodeTextField(
                    context: context,
                    onChanged: (value) {
                      setState(() {
                        // Enable the button only when the PIN is 6 digits long
                        if (value.length == 6) {
                          flag = true;
                        } else {
                          flag = false;
                        }
                      });
                    },
                    controller: otpController,
                  ),
                ),
                SizedBox(height: 24.v),
                CustomElevatedButton(
                  //  dynamicBackgroundColor: buttonColor,
                  text: "Verify",
                  buttonStyle: flag == true
                      ? const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.black))
                      : const ButtonStyle(),
                  onPressed: otpController.text.length == 6
                      ? () {
                          _verifyOtp(context, otpController.text);
                        }
                      : null,
                ),
                SizedBox(height: 33.v),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn’t receive the code?",
                      style: CustomTextStyles.bodyMediumInterBluegray700,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.h),
                      child: TextButton(
                        onPressed: () {
                          _resend();
                        },
                        child: Text(
                          "Click to resend",
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 33.v),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgArrowLeft,
                      height: 20.adaptSize,
                      width: 20.adaptSize,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8.h,
                        top: 2.v,
                      ),
                      child: Text(
                        "Back to log in",
                        style: CustomTextStyles.titleSmallBluegray700,
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
    );
  }

  void _verifyOtp(BuildContext context, String enteredOtp) async {
    // Perform OTP verification
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: enteredOtp,
      );

      UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Obtain the user token
      String? userToken = await authResult.user?.getIdToken();

      if (userToken != null) {
        // Save login information
        saveLoginInfo(userToken);

        // Navigate to the home page or any other screen upon successful verification
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePageScreen()),
          (route) => false, // Removes all routes from the stack
        );
      } else {
        // Handle the case where userToken is null
        print('User token is null');
      }
    } catch (e) {
      // Handle verification failure
      print('Verification failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Incorrect OTP'),
      ));
      // You can show an error message to the user if needed
    }
  }

  void saveLoginInfo(String userToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Replace these lines with the actual token and expiration date from your server
    DateTime expirationDate = DateTime.now().add(Duration(days: 30));

    // Save token and expiration date
    await prefs.setString('user_token', userToken);
    await prefs.setString('expiration_date', expirationDate.toIso8601String());
  }

  bool isResending = false; // Track whether the code is currently being resent

  void _resend() async {
    if (isResending) {
      // Avoid multiple resend requests
      return;
    }

    setState(() {
      isResending = true;
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieve the SMS code on Android
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failed
          print('Verification Failed: ${e.message}');
          // Display an error message to the user
        },
        codeSent: (String verificationId, int? resendToken) {
          // Navigate to OTP screen with verificationId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpOneScreen(
                  verificationId: verificationId,
                  phoneNumber: widget.phoneNumber),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle code auto-retrieval timeout
          setState(() {
            isResending = false;
          });
        },
      );
    } catch (e) {
      print('Error during resending: $e');
      // Display an error message to the user
      setState(() {
        isResending = false;
      });
    }
  }
}
