// import 'package:flutter/material.dart';
// import 'package:customer_app/presentation/customer_Rating/customer_rating.dart';

// class BottomRateButton extends StatelessWidget {
//   final String technicianName;
//   final String lastService;

//   const BottomRateButton({
//     Key? key,
//     required this.technicianName,
//     required this.lastService,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Rating Button'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           style: const ButtonStyle(
//             elevation: MaterialStatePropertyAll(10),
//             shape: MaterialStatePropertyAll(LinearBorder()),
//           ),
//           child: const Text(
//             'Rating Button',
//             style: TextStyle(
//               color: Colors.black,
//             ),
//           ),
//           onPressed: () {
//             showModalBottomSheet(
//               context: context,
//               builder: (BuildContext context) {
//                 return SizedBox(
//                   height: 300,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       const CircleAvatar(
//                         radius: 45,
//                         backgroundImage: NetworkImage(
//                             'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Name : $technicianName',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             'Last Service: $lastService',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ElevatedButton(
//                             style: const ButtonStyle(
//                               elevation: MaterialStatePropertyAll(10),
//                               shape: MaterialStatePropertyAll(LinearBorder()),
//                             ),
//                             onPressed: () {
//                               // Navigate to the rating screen and pass service details
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => CustomerRatingScreen(
//                                     technicianName: technicianName,
//                                     lastService: lastService,
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: const Text(
//                               'Give Rate',
//                               style: TextStyle(
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
