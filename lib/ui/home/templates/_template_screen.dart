// import 'package:flutter/material.dart';

// class Test extends StatelessWidget {
//   const Test({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Test"), toolbarHeight: 48.0),
//       body: ListView(
//         children: [
//           Image.asset(
//             "assets/test.webp",
//             width: double.infinity,
//             height: 225.0,
//             fit: BoxFit.cover,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Lorem ipsum",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13.0,
//                           ),
//                         ),
//                         SizedBox(height: 2.0),
//                         Text(
//                           "Lorem ipsum",
//                           style: TextStyle(color: Colors.grey, fontSize: 13.0),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Icon(Icons.star, color: Colors.deepOrange),
//                         Text("42"),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Column(
//                         children: [
//                           Icon(Icons.link, color: Colors.blue),
//                           SizedBox(height: 4.0),
//                           Text(
//                             "Lorem ipsum",
//                             style: TextStyle(
//                               fontSize: 10.0,
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           Icon(Icons.chat, color: Colors.blue),
//                           SizedBox(height: 4.0),
//                           Text(
//                             "Lorem ipsum",
//                             style: TextStyle(
//                               fontSize: 10.0,
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           Icon(Icons.search, color: Colors.blue),
//                           SizedBox(height: 4.0),
//                           Text(
//                             "Lorem ipsum",
//                             style: TextStyle(
//                               fontSize: 10.0,
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         "Lorem ipsum dolor sit amet",
//                         style: TextStyle(fontSize: 13.0),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
