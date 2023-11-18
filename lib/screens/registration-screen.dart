import 'dart:io';

import 'package:belkis_seller/firebase_service.dart';
import 'package:belkis_seller/screens/landing_screen.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseService _services = FirebaseService();
  final _businessName = TextEditingController();
  final _contactNumber = TextEditingController();
  final _emailAddress = TextEditingController();
  final _gstNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _pincode = TextEditingController();
  final _landmark = TextEditingController();

  String? countryValue;
  String? stateValue;
  String? cityValue;
  String? address;
  // final _address = TextEditingController();
  // final _city = TextEditingController();
  // String? _region;
  // String? _country;
  String? _taxStatus;
  String? bName;

  String? _shopImageUrl;
  String? _logoUrl;
  XFile? _logo;

  XFile? _shopImage;

  final ImagePicker _picker = ImagePicker();

  Widget _formField({
    TextEditingController? controller,
    String? label,
    TextInputType? type,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixText: controller == _contactNumber ? '+251' : '',
      ),
      onChanged: ((value) {
        if (controller == _businessName) {
          setState(() {
            bName = value;
          });
        }
      }),
    );
  }

  Future<XFile?> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  _snackBar(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).clearSnackBars();
        },
      ),
    ));
  }

  saveToDatabase() {
    if (_shopImage == null) {
      _snackBar('Plessa add Shop image');
      return;
    }
    if (_logo == null) {
      _snackBar('Plessa add logo image');
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (countryValue == null || stateValue == null || cityValue == null) {
        _snackBar('Select adress fields completely');
        return;
      }
      EasyLoading.show(status: 'Please Wait...');
      _services
          .uploadImage(
              _shopImage, 'sellers/${_services.user!.uid}/shopImage.jpg')
          .then((String? url) {
        if (url != null) {
          setState(() {
            _shopImageUrl = url;
          });
        }
      }).then((value) {
        _services
            .uploadImage(_logo, 'sellers/${_services.user!.uid}/logo.jpg')
            .then((url) {
          setState(() {
            _logoUrl = url;
          });
        }).then((value) {
          _services.addSeller(data: {
            'shopImage': _shopImageUrl,
            'logo': _logoUrl,
            'buisnessName': _businessName.text,
            'mobile': '+251 ${_contactNumber.text}',
            'email': _emailAddress.text,
            'taxRegistered': _taxStatus,
            'tinNumber': _gstNumber.text.isEmpty ? null : _gstNumber.text,
            'pincode': _pincode.text,
            'landmark': _landmark.text,
            'country': countryValue,
            'region': stateValue,
            'city': cityValue,
            'approved': false,
            'uid': _services.user!.uid,
            'time': DateTime.now(),
          }).then((value) {
            EasyLoading.dismiss();

            _snackBar('Successfully Registerd');
            bool alreadyNavigated = true;

            return Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const LandingScreen()));
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 220,
              child: Stack(
                children: [
                  _shopImage == null
                      ? Container(
                          height: 240,
                          color: Colors.blue.shade400,
                          child: TextButton(
                            onPressed: () {
                              _pickImage().then((value) {
                                setState(() {
                                  _shopImage = value;
                                });
                              });
                            },
                            child: const Center(
                              child: Text(
                                'Tap to add shop Image',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            _pickImage().then((value) {
                              try {
                                setState(() {
                                  _shopImage = value;
                                });
                              } catch (e) {
                                print('Error loading image: $e');
                              }
                            });
                          },
                          child: Container(
                            height: 240,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              image: _shopImage == null
                                  ? null
                                  : DecorationImage(
                                      opacity: 130,
                                      image: FileImage(File(_shopImage!.path)),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 80,
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.logout_sharp),
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                          },
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              _pickImage().then((value) {
                                setState(() {
                                  _logo = value;
                                });
                              });
                            },
                            child: Card(
                                color: Colors.white,
                                elevation: 4,
                                child: _logo == null
                                    ? const SizedBox(
                                        height: 60,
                                        width: 60,
                                        child: Center(
                                          child: Text(
                                            '+',
                                            style: TextStyle(fontSize: 25),
                                          ),
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: Image.file(File(_logo!.path)),
                                        ),
                                      )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            bName == null ? '' : bName!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _formField(
                      controller: _businessName,
                      label: 'Business name',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a business name';
                        }
                        return null;
                      },
                    ),
                    _formField(
                      controller: _contactNumber,
                      label: 'Contact number',
                      type: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter phone number';
                        }
                        return null;
                      },
                    ),
                    _formField(
                      controller: _emailAddress,
                      label: 'E-mail',
                      type: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Email';
                        }
                        bool isValid = EmailValidator.validate(value);
                        if (!isValid) {
                          return 'Invalid Email';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        const Text('Tax Registered:'),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            validator: (value) {
                              if (_taxStatus == 'Yes' &&
                                  (value == null || value.isEmpty)) {
                                return 'Please select a tax status';
                              }
                              return null;
                            },
                            value: _taxStatus,
                            hint: const Text('Select'),
                            items: <String>['Yes', 'No'].map(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _taxStatus = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (_taxStatus == 'Yes')
                      _formField(
                        controller: _gstNumber,
                        label: 'GST Number',
                        type: TextInputType.text,
                        validator: (value) {
                          if (_taxStatus == 'Yes' &&
                              (value == null || value.isEmpty)) {
                            return 'Enter GST number';
                          }
                          return null;
                        },
                      ),
                    _formField(
                      controller: _pincode,
                      label: 'Pincode',
                      type: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a pincode';
                        }
                        return null;
                      },
                    ),

                    _formField(
                      controller: _landmark,
                      label: 'Landmark',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a landmark';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CSCPicker(
                      ///Enable disable state dropdown [OPTIONAL PARAMETER]
                      showStates: true,

                      /// Enable disable city drop down [OPTIONAL PARAMETER]
                      showCities: true,

                      ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                      flagState: CountryFlag.DISABLE,

                      ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                      dropdownDecoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1)),

                      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                      disabledDropdownDecoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey.shade300,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1)),

                      ///placeholders for dropdown search field
                      countrySearchPlaceholder: "Country",
                      stateSearchPlaceholder: "State",
                      citySearchPlaceholder: "City",

                      ///labels for dropdown
                      countryDropdownLabel: "*Country",
                      stateDropdownLabel: "*Region",
                      cityDropdownLabel: "*City",

                      ///Default Country
                      defaultCountry: CscCountry.Ethiopia,

                      ///Disable country dropdown (Note: use it with default country)
                      //disableCountry: true,

                      ///Country Filter [OPTIONAL PARAMETER]
                      // countryFilter: const [
                      //   CscCountry.Ethiopia
                      //   // CscCountry.India,
                      //   // CscCountry.United_States,
                      //   // CscCountry.Canada
                      // ],

                      ///selected item style [OPTIONAL PARAMETER]
                      selectedItemStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),

                      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                      dropdownHeadingStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),

                      ///DropdownDialog Item style [OPTIONAL PARAMETER]
                      dropdownItemStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),

                      ///Dialog box radius [OPTIONAL PARAMETER]
                      dropdownDialogRadius: 10.0,

                      ///Search bar radius [OPTIONAL PARAMETER]
                      searchBarRadius: 10.0,

                      ///triggers once country selected in dropdown
                      onCountryChanged: (value) {
                        setState(() {
                          ///store value in country variable
                          countryValue = value;
                        });
                      },

                      ///triggers once state selected in dropdown
                      onStateChanged: (value) {
                        setState(() {
                          ///store value in state variable
                          stateValue = value;
                        });
                      },

                      ///triggers once city selected in dropdown
                      onCityChanged: (value) {
                        setState(() {
                          ///store value in city variable
                          cityValue = value;
                        });
                      },
                    ),

                    // ///print newly selected country state and city in Text Widget
                    // TextButton(
                    //     onPressed: () {
                    //       setState(() {
                    //         address = "$cityValue, $stateValue, $countryValue";
                    //       });
                    //     },
                    //     child: const Text("Print Data")),

                    //   // Region Dropdown
                    //   Row(
                    //     children: [
                    //       const Text('Region:'),
                    //       Expanded(
                    //         child: DropdownButtonFormField<String>(
                    //           validator: (value) {
                    //             if (value == null || value.isEmpty) {
                    //               return 'Please select a region';
                    //             }
                    //             return null;
                    //           },
                    //           value: _region,
                    //           hint: const Text('Select'),
                    //           items: <String>['Region A', 'Region B'].map(
                    //             (String value) {
                    //               return DropdownMenuItem<String>(
                    //                 value: value,
                    //                 child: Text(value),
                    //               );
                    //             },
                    //           ).toList(),
                    //           onChanged: (String? value) {
                    //             setState(() {
                    //               _region = value;
                    //             });
                    //           },
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: saveToDatabase,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue.shade400),
                    // No need to set width here
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
