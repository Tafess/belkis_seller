import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic>? productData = {
    'approved': false,
  };

  final List<XFile>? imageFiles = [];

  getFormData({
    String? productName,
    String? dicription,
    int? price,
    int? dicount,
    DateTime? scheduleDate,
    String? taxStatus,
    String? taxValue,
    double? taxPercentage,
    String? category,
    String? mainCategory,
    String? subCategory,
    String? sku,
    bool? manageInventory,
    int? stokOnHand,
    int? reOrderLevel,
    bool? chargeShipping,
    int? shipingCharge,
    String? brand,
    List? sizeList,
    String? otherDetails,
    String? unit,
    List? imageUrls,
    Map? seller,
    
  }) {
    if (seller != null) {
      productData!['seller'] = seller;
    }
    if (productName != null) {
      productData!['productName'] = productName;
    }

    if (dicription != null) {
      productData!['dicription'] = dicription;
    }
    if (price != null) {
      productData!['price'] = price;
    }
    if (dicount != null) {
      productData!['dicount'] = dicount;
    }

    if (scheduleDate != null) {
      productData!['scheduleDate'] = scheduleDate;
    }
    if (taxStatus != null) {
      productData!['taxStatus'] = taxStatus;
    }
    if (taxValue != null) {
      productData!['taxValue'] = taxValue;
    }
    if (taxPercentage != null) {
      productData!['taxPercentage'] = taxPercentage;
    }

    if (category != null) {
      productData!['category'] = category;
    }

    if (mainCategory != null) {
      productData!['mainCategory'] = mainCategory;
    }

    if (subCategory != null) {
      productData!['subCategory'] = subCategory;
    }

    if (sku != null) {
      productData!['SKU'] = sku;
    }

    if (manageInventory != null) {
      productData!['manageInventory'] = manageInventory;
    }

    if (stokOnHand != null) {
      productData!['stokOnHand'] = stokOnHand;
    }
    if (reOrderLevel != null) {
      productData!['reOrderLevel'] = reOrderLevel;
    }

    if (shipingCharge != null) {
      productData!['shipingCharge'] = shipingCharge;
    }

    if (chargeShipping != null) {
      productData!['chargeShipping'] = chargeShipping;
    }

    if (brand != null) {
      productData!['brand'] = brand;
    }

    if (sizeList != null) {
      productData!['size'] = sizeList;
    }

    if (otherDetails != null) {
      productData!['otherDetails'] = otherDetails;
    }

    if (unit != null) {
      productData!['unit'] = unit;
    }
    if (imageUrls != null) {
      productData!['imageUrls'] = imageUrls;
    }
    notifyListeners();
  }

  getImageFile(image) {
    imageFiles!.add(image);
    notifyListeners();
  }

  clearProductData() {
    productData!.clear();
    imageFiles!.clear();
    productData!['approved'] = false;
    notifyListeners();
  }
}
