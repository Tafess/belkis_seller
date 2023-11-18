import 'package:belkis_seller/provider/seller_provider.dart';
import 'package:belkis_seller/screens/add_product_screen.dart';
import 'package:belkis_seller/screens/home_screen.dart';
import 'package:belkis_seller/screens/login_screen.dart';
import 'package:belkis_seller/screens/product_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final _sellerData = Provider.of<SellerProvider>(context);
    Widget _menu({String? menuTitle, IconData? icon, String? route}) {
      return ListTile(
        leading: Icon(icon),
        title: Text(menuTitle!),
        onTap: () {
          Navigator.pushReplacementNamed(context, route!);
        },
      );
    }

    return Drawer(
      width: 200,
      child: Column(children: [
        Container(
          height: 160,
          color: Colors.blue.shade300,
          // ignore: prefer_const_constructors
          child: Row(
            children: [
              Row(
                children: [
                  DrawerHeader(
                    child: _sellerData.doc == null
                        ? Text('Feaching...')
                        : Row(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 100,
                                    child: CircleAvatar(
                                      child: CachedNetworkImage(
                                          imageUrl: _sellerData.doc!['logo']),
                                    ),
                                  ),
                                  Text(
                                    _sellerData.doc!['buisnessName'],
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _menu(
                menuTitle: 'HOME',
                icon: Icons.home_outlined,
                route: HomeScreen.id,
              ),
              ExpansionTile(
                leading: const Icon(Icons.weekend_outlined),
                title: const Text('Products'),
                children: [
                  _menu(
                    menuTitle: 'All products',
                    route: ProductScreen.id,
                  ),
                  _menu(
                    menuTitle: 'Add product',
                    icon: Icons.add,
                    route: AddProductScreen.id,
                  ),
                ],
              )
            ],
          ),
        ),
        Divider(color: Colors.grey),
        ListTile(
            title: Text('Sign Out'),
            trailing: Icon(Icons.exit_to_app),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            }),
      ]),
    );
  }
}
