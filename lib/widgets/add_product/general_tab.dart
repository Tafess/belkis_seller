import 'dart:ffi';

import 'package:belkis_seller/firebase_service.dart';
import 'package:belkis_seller/provider/product_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GeneralTab extends StatefulWidget {
  const GeneralTab({super.key});

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseService _services = FirebaseService();
  final List<String> _categories = [];
  String? selectedCategory;
  String? taxStatus;
  String? taxAmount;
  bool dicount = false;

  Widget _categoryDropdown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      hint: const Text('Select category'),
      icon: const Icon(Icons.arrow_drop_down),
      value: selectedCategory,
      onChanged: (String? newValue) {
        setState(() {
          selectedCategory = newValue;
          provider.getFormData(
            category: newValue,
          );
        });
      },
      items: _categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Select category';
        }
      },
    );
  }

  Widget _taxStatusDropdown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      hint: const Text('Select tax status'),
      icon: const Icon(Icons.arrow_drop_down),
      value: taxStatus,
      onChanged: (String? newValue) {
        setState(() {
          taxStatus = newValue;
          provider.getFormData(
            taxStatus: newValue,
          );
        });
      },
      items: ['Taxable', 'Non Taxable']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Select tax status';
        }
      },
    );
  }

  Widget _taxAmountDropdown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      hint: const Text('Select tax status'),
      icon: const Icon(Icons.arrow_drop_down),
      value: taxAmount,
      onChanged: (String? newValue) {
        setState(() {
          taxAmount = newValue!;
          provider.getFormData(
            taxPercentage: taxAmount == 'GST-10%' ? 10 : 12,
          );
        });
      },
      items:
          ['GST-10%', 'GST-12%'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      // validator: (value) {
      //   return 'Select tax status';
      // },
    );
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  getCategories() {
    _services.categories.get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          _categories.add(element['categoryName']);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _services.formField(
                label: 'Enter product name',
                inputType: TextInputType.name,
                onChanged: (value) {
                  provider.getFormData(productName: value);
                  // save to provider
                }),
            _services.formField(
                label: 'Enter product discription',
                inputType: TextInputType.multiline,
                minLine: 2,
                maxLine: 10,
                onChanged: (value) {
                  provider.getFormData(dicription: value);
                  // save to provider
                }),
            _categoryDropdown(provider),
            if (selectedCategory != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                    child: Text(provider.productData!['mainCategory'] ??
                        'Selecte main category'),
                  ),
                  InkWell(
                    child: const Icon(Icons.arrow_drop_down),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MainCategoryList(
                              selectedCategory: selectedCategory,
                              provider: provider,
                            );
                          }).whenComplete(() {
                        setState(() {});
                      });
                    },
                  )
                ],
              ),
            if (provider.productData!['mainCategory'] != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                    child: Text(provider.productData!['subCategory'] ??
                        'Selecte sub category'),
                  ),
                  InkWell(
                    child: const Icon(Icons.arrow_drop_down),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SubCategoryList(
                              selectedMainCategory:
                                  provider.productData!['mainCategory'],
                              provider: provider,
                            );
                          }).whenComplete(() {
                        setState(() {});
                      });
                    },
                  )
                ],
              ),
            const Divider(color: Colors.black),
            _services.formField(
                label: 'Enter regular price ',
                inputType: TextInputType.number,
                onChanged: (value) {
                  provider.getFormData(
                    price: int.parse(value),
                  );
                  // save to provider
                }),
            _services.formField(
                label: 'Enter discount ',
                inputType: TextInputType.number,
                onChanged: (value) {
                  if (int.parse(value) > provider.productData!['price']) {
                    _services.snackBar(
                        context, 'Discount must be less than regular price');
                    return;
                  }
                  setState(() {
                    provider.getFormData(
                      dicount: int.parse(value),
                    );
                  });
                  dicount = true;
                  // save to provider
                }),
            if (dicount == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2025))
                            .then((value) {
                          setState(() {
                            provider.getFormData(scheduleDate: value);
                          });
                        });
                      },
                      child: const Text('Schedule')),
                  if (provider.productData!['scheduleDate'] != null)
                    Text(_services
                        .formattedDate(provider.productData!['scheduleDate']))
                ],
              ),
            const SizedBox(
              height: 30,
            ),
            _taxStatusDropdown(provider),
            const SizedBox(
              height: 30,
            ),
            if (taxStatus == 'Taxable') _taxAmountDropdown(provider),
          ],
        ),
      );
    });
  }
}

class MainCategoryList extends StatelessWidget {
  final String? selectedCategory;
  final ProductProvider? provider;
  const MainCategoryList({this.selectedCategory, this.provider, super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    return Dialog(
      child: FutureBuilder<QuerySnapshot>(
          future: _service.mainCategories
              .where('category', isEqualTo: selectedCategory)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.size == 0) {
              return const Center(
                child: Text('No main Categories'),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      provider!.getFormData(
                        mainCategory: snapshot.data!.docs[index]
                            ['mainCategory'],
                      );
                      Navigator.pop(context);
                    },
                    title: Text(snapshot.data!.docs[index]['mainCategory']),
                  );
                });
          }),
    );
  }
}

class SubCategoryList extends StatelessWidget {
  final String? selectedMainCategory;
  final ProductProvider? provider;
  const SubCategoryList({this.selectedMainCategory, this.provider, super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    return Dialog(
      child: FutureBuilder<QuerySnapshot>(
          future: _service.subCategories
              .where('mainCategory', isEqualTo: selectedMainCategory)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.size == 0) {
              return const Center(
                child: Text('No sub Categories'),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      provider!.getFormData(
                        subCategory: snapshot.data!.docs[index]['subCategory'],
                      );
                      Navigator.pop(context);
                    },
                    title: Text(snapshot.data!.docs[index]['subCategory']),
                  );
                });
          }),
    );
  }
}
