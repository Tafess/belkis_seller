import 'package:belkis_seller/screens/landing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class LoginScreen extends StatelessWidget {
  static const String id ='login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return SignInScreen(
            headerBuilder: (context, constraints, _) {
              return const Padding(
                padding: EdgeInsets.all(12),
                child: AspectRatio(
                    aspectRatio: 1,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Belkis',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Seller',
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 25),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    )),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  action == AuthAction.signIn
                      ? 'Welcome to Belkis marketplace! Please sign in to continue.'
                      : 'Welcome to Belkis marketplace! Please create an account to continue',
                  style: const TextStyle(color: Colors.blue, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              );
            },
            footerBuilder: (context, _) {
              return const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue),
                ),
              );
            },
            providerConfigs: const [
              EmailProviderConfiguration(),
              GoogleProviderConfiguration(
                  clientId: '1:359678373942:android:f38b48fbbd188cc44a6897'),
              PhoneProviderConfiguration(),
            ],
          );
          // ...
        }

        // Render your application if authenticated
        return const LandingScreen();
      },
    );
  }
}
