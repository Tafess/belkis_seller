import 'package:belkis_seller/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LinkedProductsTab extends StatefulWidget {
  const LinkedProductsTab({super.key});

  @override
  State<LinkedProductsTab> createState() => _LinkedProductsTabState();
}

class _LinkedProductsTabState extends State<LinkedProductsTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, child) {
      return ListView();
    });
  }
}
