import 'package:belkis_seller/provider/seller_provider.dart';
import 'package:belkis_seller/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _sellerData = Provider.of<SellerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: _sellerData.getSellerData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else {
            return Center(
              child: Text(_sellerData.doc != null ? 'Dashboard' : ''),
            );
          }
        },
      ),
    );
  }
}
