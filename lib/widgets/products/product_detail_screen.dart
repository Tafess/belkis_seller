import 'package:belkis_seller/firebase_service.dart';
import 'package:belkis_seller/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProductDetail extends StatefulWidget {
  final ProductModel? product;
  final String? productId;
  const ProductDetail({super.key, this.product, this.productId});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final FirebaseService _services = FirebaseService();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _productName = TextEditingController();
  final _brand = TextEditingController();
  final _price = TextEditingController();
  final _discount = TextEditingController();
  final _description = TextEditingController();
  final _stockOnHand = TextEditingController();
  final _reorderLevel = TextEditingController();
  final _shipingCharge = TextEditingController();
  final _otherDetails = TextEditingController();
  final _sizeText = TextEditingController();

  DateTime? scheduledDate;

  String? taxStatus;
  String? taxAmount;
  bool _editable = true;
  bool? manageInventory;
  bool? chargeShipping;
  List? _sizelist = [];
  bool? _addlist = false;

  Widget _taxStatusDropdown() {
    return DropdownButtonFormField<String>(
      hint: const Text('Select tax status'),
      icon: const Icon(Icons.arrow_drop_down),
      value: taxStatus,
      onChanged: (String? newValue) {
        setState(() {
          taxStatus = newValue;
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

  Widget _taxAmountDropdown() {
    return DropdownButtonFormField<String>(
      hint: const Text('Select tax status'),
      icon: const Icon(Icons.arrow_drop_down),
      value: taxAmount,
      onChanged: (String? newValue) {
        setState(() {
          taxAmount = newValue!;
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

  Widget _textField(
      {TextEditingController? controller,
      String? label,
      TextInputType? inputType,
      int? maxLine,
      int? minLine,
      String? Function(String?)? validator}) {
    return TextFormField(
        maxLines: maxLine,
        minLines: minLine,
        keyboardType: inputType,
        controller: controller,
        validator: validator ??
            (value) {
              if (value!.isEmpty) {
                return 'Enter a $label';
              }
            });
  }

  updateProduct() {
    EasyLoading.show();

    _services.products.doc(widget.productId).update({
      'productName': _productName.text,
      'dicription': _description.text,
      'price': int.parse(_price.text),
      'dicount': int.parse(_discount.text),
      'scheduleDate': scheduledDate!,
      'taxStatus': taxStatus,
      'taxValue': taxAmount == 'GST-10' ? 10 : 12,
      'manageInventor': manageInventory,
      'stokOnHand': int.parse(_stockOnHand.text),
      'reOrderLevel': int.parse(_reorderLevel.text),
      'chargeShipping': chargeShipping,
      'shipingCharge': int.parse(_shipingCharge.text),
      'brand': _brand.text,
      'size': _sizeText,
      'otherDetails': _otherDetails.text,
    }).then((value) {
      setState(() {
        _editable = true;
        _addlist = false;
      });
      EasyLoading.dismiss();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _productName.text = widget.product!.productName!;
      _brand.text = widget.product!.brand!;
      _price.text = widget.product!.price!.toString();
      _discount.text = widget.product!.dicount!.toString();
      taxStatus = widget.product!.taxStatus;
      taxAmount = widget.product!.taxValue == 10 ? 'GST-10%' : 'GST-12%';
      _stockOnHand.text = widget.product!.stokOnHand!.toString();
      _reorderLevel.text = widget.product!.reOrderLevel!.toString();
      _shipingCharge.text = widget.product!.shipingCharge!.toString();
      _otherDetails.text = widget.product!.otherDetails!;

      if (widget.product!.scheduleDate != null) {
        scheduledDate = DateTime.fromMicrosecondsSinceEpoch(
            widget.product!.scheduleDate!.microsecondsSinceEpoch);
      }
      manageInventory = widget.product!.manageInventory;
      chargeShipping = widget.product!.chargeShipping;
      if (widget.product!.size != null) {
        _sizelist = widget.product!.size!;
      }

      _brand.text = widget.product!.brand!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.product!.productName!),
          elevation: 0,
          actions: [
            _editable == true
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _editable = false;
                      });
                    },
                    icon: const Icon(Icons.edit_outlined))
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          updateProduct();
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              AbsorbPointer(
                absorbing: _editable,
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: widget.product!.imageUrls!.map((e) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CachedNetworkImage(imageUrl: e),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Brand: '),
                        Expanded(
                          child: _textField(
                            label: 'Brand',
                            inputType: TextInputType.text,
                            controller: _brand,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _textField(
                      label: 'Product name',
                      inputType: TextInputType.text,
                      controller: _productName,
                    ),
                    const SizedBox(height: 10),
                    _textField(
                        label: 'Discription',
                        inputType: TextInputType.text,
                        controller: _description),
                    const SizedBox(height: 10),
                    _textField(
                        label: 'Other details',
                        inputType: TextInputType.text,
                        controller: _otherDetails),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text('Unit :'),
                          Text(widget.product!.unit!),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      if (widget.product!.dicount != null)
                                        const Text('Price'),
                                      Expanded(
                                        child: _textField(
                                            label: 'Discount',
                                            inputType: TextInputType.number,
                                            controller: _discount,
                                            validator: (value) {
                                              if (int.parse(value!) >
                                                  int.parse(_price.text)) {
                                                return 'Enter less price value than price';
                                              }
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Text('Price'),
                                      Expanded(
                                        child: _textField(
                                            label: 'Price',
                                            inputType: TextInputType.number,
                                            controller: _price,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Enter price';
                                              }
                                              if (int.parse(value) <
                                                  int.parse(_discount.text)) {
                                                return 'Enter greater price value than discount';
                                              }
                                            }),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (scheduledDate != null)
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Discount until'),
                                      Text(_services
                                          .formattedDate(scheduledDate)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  if (_editable == false)
                                    ElevatedButton(
                                        onPressed: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: scheduledDate!,
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(3000))
                                              .then((value) {
                                            setState(() {
                                              scheduledDate = value;
                                            });
                                          });
                                        },
                                        child: const Text('Change date')),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Size Lists : ${_sizelist!.isEmpty ? 0 : ""}'),
                                if (_editable == false)
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _addlist = true;
                                        });
                                      },
                                      child: const Text('Add List'))
                              ],
                            ),
                            if (_addlist!)
                              Form(
                                key: _formKey1,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter a value';
                                        }
                                      },
                                      controller: _sizeText,
                                      decoration: const InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white),
                                    )),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (_formKey1.currentState!
                                              .validate()) {
                                            _sizelist!.add(_sizeText.text);
                                            setState(() {
                                              _sizeText.clear();
                                            });
                                          }
                                        },
                                        child: const Text('Add'))
                                  ],
                                ),
                              ),
                            SizedBox(height: 10),
                            if (_sizelist!.isNotEmpty)
                              SizedBox(
                                height: 40,
                                child: ListView.builder(
                                    itemCount: _sizelist!.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onLongPress: () {
                                            setState(() {
                                              _sizelist!.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Colors.blue),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: Text(
                                                        _sizelist![index])),
                                              )),
                                        ),
                                      );
                                    }),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(child: _taxStatusDropdown()),
                        if (taxStatus == 'Taxable')
                          Expanded(child: _taxAmountDropdown()),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text('Category'),
                          const SizedBox(width: 10),
                          Text(widget.product!.category!),
                        ],
                      ),
                    ),
                    if (widget.product!.mainCategory != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text('Main Category'),
                            const SizedBox(width: 10),
                            Text(widget.product!.mainCategory!),
                          ],
                        ),
                      ),
                    if (widget.product!.subCategory != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text('Sub Category'),
                            const SizedBox(width: 10),
                            Text(widget.product!.subCategory!),
                          ],
                        ),
                      ),
                    Container(
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Manage Inventary ?'),
                                value: manageInventory,
                                onChanged: (value) {
                                  setState(() {
                                    manageInventory = value;
                                    if (value == false) {
                                      _stockOnHand.clear();
                                      _reorderLevel.clear();
                                    }
                                  });
                                }),
                            if (manageInventory == true)
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Text('SOH'),
                                        Expanded(
                                          child: _textField(
                                            label: 'Stock on hand',
                                            inputType: TextInputType.number,
                                            controller: _stockOnHand,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Text('Price'),
                                        Expanded(
                                          child: _textField(
                                            label: 'reorder level',
                                            inputType: TextInputType.number,
                                            controller: _reorderLevel,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Charge Shipping ?'),
                                value: chargeShipping,
                                onChanged: (value) {
                                  setState(() {
                                    chargeShipping = value;
                                    if (value == false) {
                                      _shipingCharge.clear();
                                    }
                                  });
                                }),
                            if (chargeShipping == true)
                              Row(
                                children: [
                                  const Text('Shipping Charge'),
                                  Expanded(
                                      child: _textField(
                                    label: 'Shipping charge',
                                    inputType: TextInputType.number,
                                    controller: _shipingCharge,
                                  ))
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text('SKU'),
                          if (widget.product!.sku != null)
                            Text(widget.product!.sku!),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
