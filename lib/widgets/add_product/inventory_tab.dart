import 'package:belkis_seller/firebase_service.dart';
import 'package:belkis_seller/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventaryTab extends StatefulWidget {
  const InventaryTab({super.key});

  @override
  State<InventaryTab> createState() => _InventaryTabState();
}

class _InventaryTabState extends State<InventaryTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseService _services = FirebaseService();
  bool? _manageInventary = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, _) {
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: [
            _services.formField(
                label: 'SKU',
                inputType: TextInputType.text,
                onChanged: (value) {
                  provider.getFormData(sku: value);
                }),
            CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Manage inventory ?'),
                value: _manageInventary,
                onChanged: (value) {
                  setState(() {
                    _manageInventary = value;
                    provider.getFormData(manageInventory: value);
                  });
                }),
            if (_manageInventary == true)
              Column(
                children: [
                  _services.formField(
                      label: 'stock on hand',
                      inputType: TextInputType.number,
                      onChanged: (value) {
                        provider.getFormData(
                          stokOnHand: int.parse(value),
                        );
                      }),
                  _services.formField(
                      label: 'Reorder level',
                      inputType: TextInputType.number,
                      onChanged: (value) {
                        provider.getFormData(
                          reOrderLevel: int.parse(value),
                        );
                      }),
                ],
              )
          ],
        ),
      );
    });
  }
}
