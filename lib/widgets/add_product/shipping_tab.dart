import 'package:belkis_seller/firebase_service.dart';
import 'package:belkis_seller/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShippingTab extends StatefulWidget {
  const ShippingTab({super.key});

  @override
  State<ShippingTab> createState() => _ShippingTabState();
}

class _ShippingTabState extends State<ShippingTab> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;


  final FirebaseService _services = FirebaseService();
  bool? _chargeShipping = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: [
            CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Charge shipping'),
                value: _chargeShipping,
                onChanged: (value) {
                  setState(() {
                    _chargeShipping = value;
                    provider.getFormData(chargeShipping: value);
                  });
                }),
            if (_chargeShipping == true)
              _services.formField(
                  label: 'shipping charge',
                  inputType: TextInputType.number,
                  onChanged: (value) {
                    provider.getFormData(shipingCharge: int.parse(value));
                  })
          ],
        ),
      );
    });
  }
}
