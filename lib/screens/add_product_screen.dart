import 'package:belkis_seller/firebase_service.dart';
import 'package:belkis_seller/provider/product_provider.dart';
import 'package:belkis_seller/provider/seller_provider.dart';
import 'package:belkis_seller/widgets/add_product/attributes_tab.dart';
import 'package:belkis_seller/widgets/add_product/general_tab.dart';
import 'package:belkis_seller/widgets/add_product/image_tab.dart';
import 'package:belkis_seller/widgets/add_product/inventory_tab.dart';
import 'package:belkis_seller/widgets/add_product/linked_products_tab.dart';
import 'package:belkis_seller/widgets/add_product/shipping_tab.dart';
import 'package:belkis_seller/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  static const String id = 'add-product-screen';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context);
    final _seller = Provider.of<SellerProvider>(context);
    final _formKey = GlobalKey<FormState>();
    final FirebaseService _services = FirebaseService();
    return Form(
      key: _formKey,
      child: DefaultTabController(
        length: 6,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add products'),
            bottom: const TabBar(
              isScrollable: true,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 5, color: Colors.white)),
              tabs: [
                Tab(
                  child: Text(
                    'General',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'Inventary',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'Shiping',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'Attributes',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'Linked products',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'images',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          drawer: const CustomDrawer(),
          body: const TabBarView(children: [
            GeneralTab(),
            InventaryTab(),
            ShippingTab(),
            AttributteTab(),
            LinkedProductsTab(),
            ImageTab(),
          ]),
          persistentFooterButtons: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (_provider.imageFiles!.isEmpty) {
                      _services.snackBar(context, 'Please add product image');
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      EasyLoading.show(status: 'Please wait...');
                      _provider.getFormData(seller: {
                        'name': _seller.seller!.buisnessName,
                        'uid': _services.user!.uid,
                      });
                      _services
                          .uploadFiles(
                              images: _provider.imageFiles,
                              ref:
                                  'products/${_seller.seller!.buisnessName}/${_provider.productData!['productName']}',
                              provider: _provider)
                          .then((value) {
                        if (value.isNotEmpty) {
                          _services.saveToDatabase(
                            data: _provider.productData,
                            context: context,
                          );
                        }
                      }).then((value) {
                        EasyLoading.dismiss();
                        setState(() {
                          _provider.clearProductData();
                        });
                      });
                    }
                  },
                  child: const Text('Save product')),
            ),
          ],
        ),
      ),
    );
  }
}
