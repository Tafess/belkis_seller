import 'package:belkis_seller/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  ProductModel(
      {this.approved,
      this.productName,
      this.dicription,
      this.price,
      this.dicount,
      this.scheduleDate,
      this.taxStatus,
      this.taxValue,
      this.taxPercentage,
      this.category,
      this.mainCategory,
      this.subCategory,
      this.manageInventory,
      this.sku,
      this.stokOnHand,
      this.reOrderLevel,
      this.chargeShipping,
      this.shipingCharge,
      this.brand,
      this.size,
      this.otherDetails,
      this.unit,
      this.imageUrls,
      this.seller,
      this.productId});

  ProductModel.fromJson(Map<String, Object?> json)
      : this(
          approved: json['approved'] == null ? null : json['approved']! as bool,
          productName: json['productName'] == null
              ? null
              : json['productName']! as String,
          dicription:
              json['dicription'] == null ? null : json['dicription']! as String,
          price: json['price'] == null ? null : json['price']! as int,
          dicount: json['dicount'] == null ? null : json['dicount']! as int,
          scheduleDate: json['scheduleDate'] == null
              ? null
              : json['scheduleDate']! as Timestamp,
          taxStatus:
              json['taxStatus'] == null ? null : json['taxStatus']! as String,
          taxValue:
              json['taxValue'] == null ? null : json['taxValue']! as String,
          taxPercentage: json['taxPercentage']! as double,
          category: json['category']! as String,
          mainCategory: json['mainCategory'] == null
              ? null
              : json['mainCategory']! as String,
          subCategory: json['subCategory'] == null
              ? null
              : json['subCategory']! as String,
          manageInventory: json['manageInventory'] == null
              ? null
              : json['manageInventory']! as bool,
          sku: json['sku'] == null ? null : json['sku']! as String,
          stokOnHand:
              json['stokOnHand'] == null ? null : json['stokOnHand']! as int,
          reOrderLevel: json['reOrderLevel'] == null
              ? null
              : json['reOrderLevel']! as int,
          chargeShipping: json['chargeShipping'] == null
              ? null
              : json['chargeShipping']! as bool,
          shipingCharge: json['shipingCharge'] == null
              ? null
              : json['shipingCharge']! as int,
          brand: json['brand'] == null ? null : json['brand']! as String,
          size: json['size'] == null ? null : json['size']! as List,
          otherDetails: json['otherDetails'] == null
              ? null
              : json['otherDetails']! as String,
          unit: json['unit'] == null ? null : json['unit']! as String,
          imageUrls:
              json['imageUrls'] == null ? null : json['imageUrls']! as List,
          seller: json['seller'] == null ? null : json['seller']! as Map,
        );
  final bool? approved;
  final String? productName;
  final String? dicription;
  final int? price;
  final int? dicount;
  final Timestamp? scheduleDate;
  final String? taxStatus;
  final String? taxValue;
  final double? taxPercentage;
  final String? category;
  final String? mainCategory;
  final String? subCategory;
  final bool? manageInventory;
  final String? sku;
  final int? stokOnHand;
  final int? reOrderLevel;
  final bool? chargeShipping;
  final int? shipingCharge;
  final String? brand;
  final List? size;
  final String? otherDetails;
  final String? unit;
  final List? imageUrls;
  final Map? seller;
  final String? productId;

  Map<String, Object?> toJson() {
    return {
      'approved': approved,
      'productName': productName,
      'dicription': dicription,
      'price': price,
      'dicount': dicount,
      'scheduleDate': scheduleDate,
      'taxStatus': taxStatus,
      'taxValue': taxValue,
      'taxPercentage': taxPercentage,
      'category': category,
      'mainCategory': mainCategory,
      'subCategory': subCategory,
      'sku': sku,
      'manageInventor': manageInventory,
      'stokOnHand': stokOnHand,
      'reOrderLevel': reOrderLevel,
      'chargeShipping': chargeShipping,
      'shipingCharge': shipingCharge,
      'brand': brand,
      'size': size,
      'otherDetails': otherDetails,
      'unit': unit,
      'imageUrls': imageUrls,
      'selle': seller
    };
  }
}

FirebaseService _services = FirebaseService();
productQuery(approved) {
  return FirebaseFirestore.instance
      .collection('products')
      .where('approved', isEqualTo: approved)
      .where('seller.uid', isEqualTo: _services.user!.uid)
      .orderBy('productName')
      .withConverter<ProductModel>(
        fromFirestore: (snapshot, _) => ProductModel.fromJson(snapshot.data()!),
        toFirestore: (product, _) => product.toJson(),
      );
}
