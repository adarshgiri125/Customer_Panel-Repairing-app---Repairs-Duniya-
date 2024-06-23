// // ignore_for_file: file_names
// import 'package:customer_app/presentation/Buy%20Appliance%20constants/colors.dart';
// import 'package:customer_app/presentation/Buy%20Appliance%20constants/textStyle.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';
// import 'package:sizer/sizer.dart';

// class ToastService {
//   static sendAlert({
//     required BuildContext context,
//     required String message,
//     required String toastStatus,
//   }) {
//     showToastWidget(
//         Container(
//           margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
//           padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
//           decoration: BoxDecoration(
//             color: white,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               color: greyShade3,
//             ),
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 toastStatus == 'SUCCESS'
//                     ? Icons.check_circle
//                     : toastStatus == 'ERROR'
//                         ? Icons.warning_sharp
//                         : Icons.warning_rounded,
//                 color: toastStatus == 'SUCCESS'
//                     ? success
//                     : toastStatus == 'ERROR'
//                         ? error
//                         : Colors.green,
//               ),
//               const SizedBox(
//                 width: 8,
//               ),
//               SizedBox(
//                 width: 68.w,
//                 child: Text(
//                   message,
//                   textAlign: TextAlign.left,
//                   style: AppTextStyles.small12,
//                 ),
//               ),
//               const Spacer(),
//             ],
//           ),
//         ),
//         animation: StyledToastAnimation.slideFromBottom,
//         reverseAnimation: StyledToastAnimation.slideFromBottomFade,
//         context: context,
//         duration: const Duration(seconds: 2),
//         position: StyledToastPosition.bottom);
//   }
// }
