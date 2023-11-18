import 'package:belkis_seller/firebase_service.dart';
import 'package:belkis_seller/models/seller_model.dart';
import 'package:belkis_seller/screens/home_screen.dart';
import 'package:belkis_seller/screens/login_screen.dart';
import 'package:belkis_seller/screens/registration-screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final FirebaseService _services = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing Screen'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: _services.sellers.doc(_services.user!.uid).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.data!.exists) {
              return const RegistrationScreen();
            }
            Seller seller =
                Seller.fromJson(snapshot.data!.data() as Map<String, dynamic>);
            if (seller.approved == true) {
              return const HomeScreen();
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: seller.logo!,
                          placeholder: (context, url) => Container(
                            height: 100,
                            width: 100,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      seller.buisnessName!,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Your request is send to belkis admin \n\n Admin will contact you soon',
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        )),
                        onPressed: () {
                          FirebaseAuth.instance.signOut().then((value) {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LoginScreen(),
                            ));
                          });
                        },
                        child: const Text(
                          'Sign out',
                          style: TextStyle(fontSize: 20),
                        ))
                  ],
                ),
              ),
            );
          }),
    );
  }
}
