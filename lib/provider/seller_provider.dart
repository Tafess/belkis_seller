import 'package:belkis_seller/firebase_service.dart';
import 'package:belkis_seller/models/seller_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SellerProvider with ChangeNotifier {
  final FirebaseService _services = FirebaseService();
  DocumentSnapshot? doc;
  Seller? seller;

  getSellerData() {
    _services.sellers.doc(_services.user!.uid).get().then(
      (document) {
        if (document.exists) {
          doc = document;
          seller = Seller.fromJson(document.data() as Map<String, dynamic>);
        } else {
          
          print('Seller document does not exist.');
          
        }
        notifyListeners();
      },
    ).catchError((error) {
      print('Error fetching seller data: $error');
     
    });
  }

  // getSellerData() {
  //   _services.sellers.doc(_services.user!.uid).get().then((document) {
  //     doc = document;
  //     seller=Seller.fromJson(document.data()as Map<String,dynamic>);
  //     notifyListeners();
  //   });
  // }
}
