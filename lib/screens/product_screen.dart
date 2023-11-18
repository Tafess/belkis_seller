import 'package:belkis_seller/widgets/custom_drawer.dart';
import 'package:belkis_seller/widgets/products/published.dart';
import 'package:belkis_seller/widgets/products/unpublished.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  static const String id = 'product-screen';
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
              title: const Text('Product List'),
              elevation: 0,
              bottom: const TabBar(
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 6, color: Colors.red)),
                tabs: [
                  Tab(
                    child: Text('Unpublished'),
                  ),
                  Tab(
                    child: Text('published'),
                  ),
                ],
              )),
          drawer: const CustomDrawer(),
          body: const TabBarView(
            children: [
              UnPublishedProducts(),
              PublishedProduct(),
            ],
          )),
    );
  }
}
