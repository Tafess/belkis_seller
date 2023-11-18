import 'dart:io';

import 'package:belkis_seller/provider/product_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class FirebaseService {
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference sellers =
      FirebaseFirestore.instance.collection('sellers');

  final CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  final CollectionReference mainCategories =
      FirebaseFirestore.instance.collection('mainCategories');

  final CollectionReference subCategories =
      FirebaseFirestore.instance.collection('subCategories');

  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadImage(XFile? file, String? reference) async {
    File _file = File(file!.path);
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(reference);

    await ref.putFile(_file);

    String dounloadURL = await ref.getDownloadURL();
    return dounloadURL;
  }

  Future<List> uploadFiles(
      {List<XFile>? images, String? ref, ProductProvider? provider}) async {
    var imageUrls = await Future.wait(
      images!.map(
        (_image) => uploadFile(
          image: File(_image.path),
          reference: ref,
        ),
      ),
    );
    provider!.getFormData(imageUrls: imageUrls);
    return imageUrls;
  }

  Future uploadFile({File? image, String? reference}) async {
    firebase_storage.Reference storageReference = storage
        .ref()
        .child('$reference/${DateTime.now().microsecondsSinceEpoch}');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(image!);
    await uploadTask;
    return storageReference.getDownloadURL();
  }

  Future<void> addSeller({Map<String, dynamic>? data}) {
    // Call the user's CollectionReference to add a new user
    return sellers
        .doc(user!.uid)
        .set(data)
        .then((value) => print('user added: '))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> saveToDatabase(
      {BuildContext? context,
      CollectionReference? collection,
      Map<String, dynamic>? data}) {
    // Call the user's CollectionReference to add a new user
    return products
        .add(data)
        .then((value) => snackBar(context, "Product saved to firestore"))
        .catchError((error) => snackBar(context, "Failed to add user: $error"));
  }

  String formattedDate(date) {
    var outputFormat = DateFormat('dd/MM/yyyy hh:mm aa');
    var outputDate = outputFormat.format(date);
    return outputDate;
  }

  String formatedNumber(number) {
    var format = NumberFormat('#,##,###');
    String formattedNumber = format.format(number);
    return formattedNumber;
  }

  Widget formField(
      {String? label,
      TextInputType? inputType,
      Function(String)? onChanged,
      int? minLine,
      int? maxLine}) {
    return TextFormField(
        keyboardType: inputType,
        decoration: InputDecoration(
          label: Text(label!),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return label;
          }
        },
        onChanged: onChanged,
        minLines: minLine,
        maxLines: maxLine);
  }

  snackBar(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).clearSnackBars();
        },
      ),
    ));
  }
}
