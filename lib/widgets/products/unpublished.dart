import 'package:belkis_seller/firebase_service.dart';
import 'package:belkis_seller/models/product_model.dart';
import 'package:belkis_seller/widgets/products/product_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:search_page/search_page.dart';

class UnPublishedProducts extends StatefulWidget {
  const UnPublishedProducts({Key? key, this.snapshot}) : super(key: key);
  final FirestoreQueryBuilderSnapshot<ProductModel>? snapshot;

  @override
  State<UnPublishedProducts> createState() => _UnPublishedProductsState();
}

class _UnPublishedProductsState extends State<UnPublishedProducts> {
  FirebaseService _services = FirebaseService();

  List<ProductModel> _productList = [];

  @override
  void initState() {
    getProductList();
    super.initState();
  }

  getProductList() {
    widget.snapshot!.docs.forEach((element) {
      ProductModel product = element.data();
      setState(() {
        _productList.add(ProductModel(
          productName: product.productName,
          approved: product.approved,
          taxValue: product.taxValue,
          reOrderLevel: product.reOrderLevel,
          price: product.price,
          dicount: product.dicount,
          taxStatus: product.taxStatus,
          category: product.category,
          mainCategory: product.mainCategory,
          subCategory: product.subCategory,
          dicription: product.dicription,
          scheduleDate: product.scheduleDate,
          manageInventory: product.manageInventory,
          sku: product.sku,
          stokOnHand: product.stokOnHand,
          chargeShipping: product.chargeShipping,
          shipingCharge: product.shipingCharge,
          brand: product.brand,
          unit: product.unit,
          imageUrls: product.imageUrls,
          size: product.size,
          seller: product.seller,
          otherDetails: product.otherDetails,
          productId: element.id,
          taxPercentage: product.taxPercentage,
        ));
      });
    });
  }

  Widget products() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.snapshot!.docs.length,
      itemBuilder: (context, index) {
        ProductModel product = widget.snapshot!.docs[index].data();
        String id = widget.snapshot!.docs[index].id;
        var offDiscount =
            (product.price! - product.dicount!) / product.price! * 100;
        return Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                flex: 1,
                onPressed: (context) {
                  // _services.products.doc(id).delete();
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
              SlidableAction(
                flex: 1,
                onPressed: (context) {
                  _services.products.doc(id).update({
                    'approved': true,
                  });
                },
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                icon: Icons.approval,
                label: 'Approve',
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ProductDetail(
                    product: product,
                    productId: id,
                  ),
                ),
              ).whenComplete(() {
                setState(() {
                  _productList.clear();
                  getProductList();
                });
              });
            },
            child: Card(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrls![0],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.productName!),
                        if (product.dicount != null)
                          Row(
                            children: [
                              Text(
                                product.dicount.toString(),
                              ),
                              Text(
                                product.price.toString(),
                                style: TextStyle(
                                  decoration: product.dicount != null
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${offDiscount.toInt()}%',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<ProductModel>(
      query: productQuery(false),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        }

        if (snapshot.docs.isEmpty) {
          return const Center(
            child: Text('No unpublished products'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onTap: () {
                      showSearch(
                        context: context,
                        delegate: SearchPage<ProductModel>(
                          items: _productList,
                          searchLabel: 'Search product',
                          suggestion: const Center(
                            child: Text(
                              'Filter product by name, category , main category or sub category',
                            ),
                          ),
                          failure: const Center(
                            child: Text('No product found :('),
                          ),
                          filter: (product) => [
                            product.productName,
                            product.category,
                            product.subCategory,
                            product.mainCategory,
                          ],
                          builder: (product) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProductDetail(
                                      product: product,
                                      productId: product.productId,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: product.imageUrls![0],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(product.productName!),
                                          if (product.dicount != null)
                                            Row(
                                              children: [
                                                Text(
                                                  product.dicount.toString(),
                                                ),
                                                Text(
                                                  product.price.toString(),
                                                  style: TextStyle(
                                                    decoration:
                                                        product.dicount != null
                                                            ? TextDecoration
                                                                .lineThrough
                                                            : null,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search products',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search_off),
                      contentPadding:
                          EdgeInsets.only(left: 10, top: 16, right: 10),
                      fillColor: Colors.white,
                      filled: true,
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey.shade200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Total unpublished products: ${snapshot.docs.length}',
                          ),
                        ),
                      ),
                      Expanded(
                          child: products()), // Call the products function here
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
