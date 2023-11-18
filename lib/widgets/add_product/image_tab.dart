import 'dart:io';

import 'package:belkis_seller/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageTab extends StatefulWidget {
  const ImageTab({super.key});

  @override
  State<ImageTab> createState() => _ImageTabState();
}

class _ImageTabState extends State<ImageTab>
    with AutomaticKeepAliveClientMixin {
  final ImagePicker _picker = ImagePicker();

  Future<List<XFile>?> _pickImage() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    return images;
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: [
            TextButton(
                onPressed: () {
                  _pickImage().then((value) {
                    var list = value!.forEach((image) {
                      setState(() {
                        provider.getImageFile(image);
                      });
                    });
                  });
                },
                child: const Text('Add Product Image')),
            Center(
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: provider.imageFiles!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(30)),
                        height: 100,
                        child: InkWell(
                          onLongPress: () {
                            setState(() {
                              provider.imageFiles!.removeAt(index);
                            });
                          },
                          child: provider.imageFiles == null
                              ? const Center(
                                  child: Text('No image Selected'),
                                )
                              : Image.file(
                                  File(provider.imageFiles![index].path),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    );
                  })),
            )
          ],
        ),
      );
    });
  }
}
