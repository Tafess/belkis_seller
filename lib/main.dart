import 'dart:async';

import 'package:belkis_seller/firebase_options.dart';
import 'package:belkis_seller/provider/product_provider.dart';
import 'package:belkis_seller/screens/add_product_screen.dart';
import 'package:belkis_seller/screens/home_screen.dart';
import 'package:belkis_seller/screens/login_screen.dart';
import 'package:belkis_seller/screens/product_screen.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:belkis_seller/provider/seller_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      providers: [
        Provider<SellerProvider>(create: (_) => SellerProvider()),
        Provider<ProductProvider>(create: (_) => ProductProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Belkis Sellers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Regular',
      ),
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
        ProductScreen.id: (context) => const ProductScreen(),
        AddProductScreen.id: (context) => const AddProductScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String id = 'splash_screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final store = GetStorage();

  @override
  void initState() {
    super.initState();
    // Use a flag to check if navigation has already occurred
    bool alreadyNavigated = false;

    // Delay for 2 seconds
    Timer(const Duration(seconds: 2), () {
      // Check if navigation has not already occurred
      if (!alreadyNavigated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Center(
          child: Text(
            '.. .......',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
        ),
      ),
      backgroundColor: Colors.blue.shade400,
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Welcome ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          Text('',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),

      //Center(child: Image.asset('assets/images/welcome.png')),
    );
  }
}

// class StartupAnimation extends StatefulWidget {
//   @override
//   _StartupAnimationState createState() => _StartupAnimationState();
// }

// class _StartupAnimationState extends State<StartupAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: FadeTransition(
//         opacity: _controller,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Welcome to My App',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             DefaultTextStyle(
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//               child: AnimatedTextKit(
//                 animatedTexts: [
//                   TyperAnimatedText('Engage your users with animations.'),
//                   TyperAnimatedText('Create stunning UI with Flutter.'),
//                   TyperAnimatedText('Welcome to My App'),
//                 ],
//                 isRepeatingAnimation: false,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
