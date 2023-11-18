// import 'package:belkis/screens/main_screen.dart';
// import 'package:dots_indicator/dots_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get_storage/get_storage.dart';

// class OnBoardingScreen extends StatefulWidget {
//   const OnBoardingScreen({super.key});

//   static const String id = 'onboard_screen';

//   @override
//   State<OnBoardingScreen> createState() => _OnBoardingScreenState();
// }

// class _OnBoardingScreenState extends State<OnBoardingScreen> {
//   int scrollerPosition = 0;
//   final store=GetStorage();

//   onButtonPressed(context) {
//     // before going to home screen app will save to device that ,this user already
//     // seen the dashboard screen next time this screen should not open for that 
//     //we wiil use packege called getStorage 
//     store.write('onBoarding', true);
//     return Navigator.pushReplacementNamed(context, MainScreen.id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // stop landscape mode
//     SystemChrome.setPreferredOrientations(
//         [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//     return Scaffold(
//       backgroundColor: Colors.blue.shade300,
//       body: Stack(children: [
//         PageView(
//           onPageChanged: (val) {
//             setState(() {
//               scrollerPosition = val;
//             });
//           },
//           scrollDirection: Axis.horizontal,
//           children: [
//             OnBoardPage(
//               boardColumn: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Center(
//                     child: Text(
//                       'Welcome to \n Belkis Marketplace ',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: 30),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Text(
//                     '+10 million products \n +100 Categories\n +20 Brands',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         fontSize: 20),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   SizedBox(
//                       height: 300,
//                       width: 300,
//                       child: Image.asset('assets/images/vegcart.jpg')),
//                 ],
//               ),
//             ),
//             OnBoardPage(
//               boardColumn: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Center(
//                     child: Text(
//                       '7 - 14 Days Return ',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: 30),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Text(
//                     'Satisfaction Guaranted',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         fontSize: 20),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   SizedBox(
//                       height: 300,
//                       width: 300,
//                       child: Image.asset('assets/images/vegcart.jpg')),
//                 ],
//               ),
//             ),
//             OnBoardPage(
//               boardColumn: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Center(
//                     child: Text(
//                       'Experiance Smart \nShoping ',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: 30),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   SizedBox(
//                       height: 300,
//                       width: 300,
//                       child: Image.asset('assets/images/cosmo2.jpg')),
//                 ],
//               ),
//             ),
//             OnBoardPage(
//               boardColumn: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Center(
//                     child: Text(
//                       'Safe & secure\n payment ',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: 30),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   SizedBox(
//                       height: 300,
//                       width: 300,
//                       child: Image.asset('assets/images/Cosmetics.jpg')),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               DotsIndicator(
//                 dotsCount: 4,
//                 position:
//                     scrollerPosition, // Divide by the total number of pages
//                 decorator: DotsDecorator(
//                   activeColor: Colors.white,
//                   color: Colors.black87,
//                 ),
//               ),
//               scrollerPosition == 3
//                   ? Padding(
//                       padding: const EdgeInsets.only(left: 20.0, right: 20),
//                       child: ElevatedButton(
//                         style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Colors.white),
//                         ),
//                         child: Text(
//                           'Start shoping',
//                           style: TextStyle(color: Colors.black, fontSize: 20),
//                         ),
//                         onPressed: () {
//                           onButtonPressed(context);
//                         },
//                       ),
//                     )
//                   : TextButton(
//                       onPressed: () {
//                         onButtonPressed(context);
//                       },
//                       child: Text(
//                         'Skip to the App >',
//                         style: TextStyle(
//                             fontSize: 25,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//               SizedBox(height: 30),
//             ],
//           ),
//         )
//       ]),
//     );
//   }
// }

// class OnBoardPage extends StatelessWidget {
//   final Column? boardColumn;
//   OnBoardPage({Key? key, this.boardColumn}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Center(
//           child: Container(
//             height: 600,
//             color: Colors.blue.shade300,
//             child: boardColumn,
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.zero,
//           child: Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               height: 120,
//               decoration: BoxDecoration(
//                   color: Colors.orange.shade700,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(100),
//                       topRight: Radius.circular(100))),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
