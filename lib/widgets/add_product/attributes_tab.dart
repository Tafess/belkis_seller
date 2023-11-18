import 'package:belkis_seller/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttributteTab extends StatefulWidget {
  const AttributteTab({super.key});

  @override
  State<AttributteTab> createState() => _AttributteTabState();
}

class _AttributteTabState extends State<AttributteTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final List<String> _sizeList = [];
  final _sizeText = TextEditingController();
  bool? _saved = false;
  bool? _entered = false;
  String? selectedUnit;

  final List<String> _unitList = [
    'gram',
    'kg',
    'liter',
    'millilitr',
  ];
  Widget _formField(
      {String? label,
      TextInputType? inputType,
      Function(String)? onChanged,
      int? minLine,
      int? maxLine}) {
    return TextFormField(
        keyboardType: inputType,
        decoration: InputDecoration(
          label: Text(label!),
        ),
        onChanged: onChanged,
        minLines: minLine,
        maxLines: maxLine);
  }

  Widget _unitDropdown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      hint: const Text('Select select unit'),
      icon: const Icon(Icons.arrow_drop_down),
      value: selectedUnit,
      onChanged: (String? newValue) {
        setState(() {
          selectedUnit = newValue;
          provider.getFormData(
            unit: newValue,
          );
        });
      },
      items: _unitList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Select unit';
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: [
            _formField(
                label: 'Brand',
                inputType: TextInputType.text,
                onChanged: (value) {
                  provider.getFormData(brand: value);
                }),
            _unitDropdown(provider),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: _sizeText,
                  decoration: const InputDecoration(
                    label: Text('Size'),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _entered = true;
                      });
                    }
                  },
                )),
                if (_entered == true)
                  ElevatedButton(
                    child: const Text('Add'),
                    onPressed: () {
                      setState(() {
                        _sizeList.add(_sizeText.text);
                        _sizeText.clear();
                        _entered = false;
                        _saved = false;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _sizeList.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onLongPress: () {
                          setState(() {
                            _sizeList.removeAt(index);
                            provider.getFormData(sizeList: _sizeList);
                          });
                        },
                        child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue.shade300,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                _sizeList[index],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )),
                            )),
                      ),
                    );
                  })),
            ),
            if (_sizeList.isNotEmpty) Text('* long press to delete'),
            if (_saved == false)
              ElevatedButton(
                child: const Text(
                  'press to Save',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  setState(() {
                    provider.getFormData(sizeList: _sizeList);
                  });
                  _saved = true;
                },
              ),
            _formField(
                label: 'Add other details',
                maxLine: 2,
                onChanged: (value) {
                  provider.getFormData(
                    otherDetails: value,
                  );
                })
          ],
        ),
      );
    });
    ;
  }
}
