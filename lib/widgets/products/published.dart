import 'package:belkis_seller/firebase_service.dart';
import 'package:belkis_seller/models/product_model.dart';
import 'package:belkis_seller/widgets/products/product_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterfire_ui/firestore.dart';

class PublishedProduct extends StatelessWidget {
  const PublishedProduct({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseService _services = FirebaseService();
    return FirestoreQueryBuilder<ProductModel>(
      query: productQuery(true),
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
            child: Text('No published products yet'),
          );
        }
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Total products :  ${snapshot.docs.length}'),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.docs.length,
                        itemBuilder: (context, index) {
                          ProductModel product = snapshot.docs[index].data();
                          String id = snapshot.docs[index].id;
                          var offDiscount =
                              (product.price! - product.dicount!) /
                                  product.price! *
                                  100;
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  flex: 1,
                                  onPressed: (context) {
                                    _services.products.doc(id).delete();
                                  },
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                                SlidableAction(
                                  flex: 1,
                                  onPressed: (context) {
                                    _services.products
                                        .doc(id)
                                        .update({'approved': false});
                                  },
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  icon: Icons.approval,
                                  label: 'Inactive',
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProductDetail(
                                      product: product,
                                      productId: id,
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
                                              imageUrl: product.imageUrls![0]),
                                        )),
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
                                                    product.dicount.toString()),
                                                SizedBox(width: 20),
                                                Text(
                                                  product.price.toString(),
                                                  style: TextStyle(
                                                      decoration:
                                                          product.dicount !=
                                                                  null
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : null,
                                                      color: Colors.blue),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  '${offDiscount.toInt()}%',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .green.shade700),
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
                        }),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
