import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';
import 'package:layout/extensions/contexExt.dart';
import 'package:layout/models/valuation.dart';
import 'package:layout/screens/drawer_page/util/firebase_services.dart';

import '../../costants/constans.dart';
import 'bankder.dart';

class ValuationForm extends StatefulWidget {
  ValuationForm({super.key, required this.formName, required this.description});
  String formName;
  String description;
  @override
  State<ValuationForm> createState() => _ValuationFormState();
}

class _ValuationFormState extends State<ValuationForm> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;

  late TextEditingController mobileNoController;

  late TextEditingController emailController;

  late TextEditingController addressController;

  late TextEditingController postalController;

  late TextEditingController landSizeController;

  late TextEditingController builtUpController;

  late TextEditingController renovationController;

  late TextEditingController expectedPriceController;

  String? lastRenovation;
  late List<String> filePaths;

  File? optionalImage1, optionalImage2, optionalImage3;

  void getOptionalImage1(File file1) {
    optionalImage1 = file1;
  }

  @override
  void initState() {
    nameController = TextEditingController();
    mobileNoController = TextEditingController();
    emailController = TextEditingController();
    renovationController = TextEditingController();
    addressController = TextEditingController();
    postalController = TextEditingController();
    landSizeController = TextEditingController();
    builtUpController = TextEditingController();
    expectedPriceController = TextEditingController();
    filePaths = [];
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileNoController.dispose();
    emailController.dispose();
    renovationController.dispose();
    addressController.dispose();
    postalController.dispose();
    landSizeController.dispose();
    builtUpController.dispose();
    expectedPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.formName,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Text(widget.description),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextFormField(
                    controller: nameController,
                    label: 'Name*',
                    validate: (value) {
                      if (value.isEmpty) {
                        return 'Enter your name';
                      } else {
                        return null;
                      }
                    },
                  ),
                  MyTextFormField(
                    controller: mobileNoController,
                    label: 'Mobile No*',
                    inputType: TextInputType.phone,
                    validate: (value) {
                      if (value.isEmpty) {
                        return 'Enter your number';
                      } else {
                        return null;
                      }
                    },
                  ),
                  MyTextFormField(
                    controller: emailController,
                    label: 'Email Address',
                    inputType: TextInputType.emailAddress,
                    validate: (value) {
                      if (value.isNotEmpty &&
                          !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                              .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      } else {
                        return null;
                      }
                    },
                  ),
                  MyTextFormField(
                    controller: addressController,
                    label: 'Property Address',
                  ),
                  MyTextFormField(
                    controller: postalController,
                    label: 'Postal Code',
                    inputType: TextInputType.number,
                  ),
                  LastRenovationWidget(
                    lastRenovationDuration: (p0) {
                      lastRenovation = p0;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: context.width * 0.42,
                        child: MyTextFormField(
                            controller: landSizeController,
                            inputType: TextInputType.number,
                            label: 'Land Size',
                            suffix: const Text('sqft')),
                      ),
                      SizedBox(
                        width: context.width * 0.42,
                        child: MyTextFormField(
                          controller: builtUpController,
                          suffix: const Text('sqft'),
                          inputType: TextInputType.number,
                          label: 'Built up',
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: context.width * 0.42,
                        child: MyTextFormField(
                            controller: renovationController,
                            inputType: TextInputType.number,
                            label: 'Renovation cost',
                            prefix: const Text('\$ ')),
                      ),
                      SizedBox(
                        width: context.width * 0.42,
                        child: MyTextFormField(
                          controller: expectedPriceController,
                          prefix: const Text('\$ '),
                          inputType: TextInputType.number,
                          label: 'Expected price',
                        ),
                      )
                    ],
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: OptionalImages(
                        optionalImage1: getOptionalImage1,
                        // optionalImage2: getOptionalImage2,
                        // optionalImage3: getOptionalImage3,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (optionalImage1 != null) {
                              filePaths.add(optionalImage1!.path);
                            }
                            final valuation = Valuation(
                                name: nameController.text,
                                mobileNo: mobileNoController.text,
                                email: emailController.text,
                                propertyAddress: addressController.text,
                                postalCode: postalController.text,
                                lastRenovation: lastRenovation,
                                landSize: landSizeController.text,
                                builtUp: builtUpController.text,
                                renovationCost: renovationController.text,
                                expectedPrice: expectedPriceController.text);
                            final FirebaseServices firebaseServices =
                                FirebaseServices();
                            firebaseServices.uploadValuatin(
                                widget.formName, valuation);
                            final Email email = Email(
                                subject: 'Request For ${widget.formName}',
                                body:
                                    'Name : ${nameController.text} \n Mobile No : ${mobileNoController.text} \n Email : ${emailController.text} \n Property Address : ${addressController.text} \n Postal Code : ${postalController.text} \n Last Renovation : $lastRenovation \n Land Size : ${landSizeController.text} \n Built Up : ${builtUpController.text} \n Renovation Cost : ${renovationController.text} \n Expected Price : ${expectedPriceController.text}',
                                attachmentPaths: filePaths,
                                recipients: [AppConstants.recevingEmail]);
                            try {
                              await FlutterEmailSender.send(email);
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const ForumsSuccessDialouge(),
                              );
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error.toString())));
                            }
                          }
                        },
                        child: const Text('Submit')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OptionalImages extends StatelessWidget {
  const OptionalImages({
    super.key,
    required this.optionalImage1,
  });
  final Function(File) optionalImage1;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: SizedBox(
          height: context.height * 0.13,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ImagePickerView(
                receivedFile: optionalImage1,
                heith: 0.13,
                width: 0.3,
              ),
            ],
          ),
        ));
  }
}

//image picker widget
class ImagePickerView extends StatefulWidget {
  ImagePickerView(
      {super.key,
      this.heith = 0.16,
      this.width = 0.4,
      required this.receivedFile});
  double heith;
  double width;
  final Function(File) receivedFile;

  @override
  State<ImagePickerView> createState() => _ImagePickerViewState();
}

class _ImagePickerViewState extends State<ImagePickerView> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () async {
          final ImagePicker picker = ImagePicker();
          final XFile? image =
              await picker.pickImage(source: ImageSource.gallery);
          try {
            setState(() {
              File file = File(image!.path);
              imageFile = file;
              widget.receivedFile(file);
            });
          } catch (e) {
            print(e);
          }
        },
        child: Container(
          height: context.height * widget.heith,
          width: context.width * widget.width,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          child: imageFile == null
              ? const Icon(Icons.add_a_photo_outlined)
              : Image.file(imageFile!),
        ),
      ),
    );
  }
}

//last renovation dropdown
class LastRenovationWidget extends StatefulWidget {
  const LastRenovationWidget({super.key, required this.lastRenovationDuration});
  final Function(String) lastRenovationDuration;
  @override
  State<LastRenovationWidget> createState() => _LastRenovationWidgetState();
}

class _LastRenovationWidgetState extends State<LastRenovationWidget> {
  String? lastRenovation;
  var items = [
    'Original',
    'Less than 5 years',
    '5 to 10 years',
    'More than 10 years'
  ];
  String? initialValue = 'Original';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        alignment: Alignment.center,
        height: 55,
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Last Renovation'),
              Container(
                height: 40,
                width: context.width * 0.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownButton(
                      isExpanded: true,
                      underline: const SizedBox(),
                      value: initialValue,
                      items: items
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          initialValue = value!;
                          widget.lastRenovationDuration(value);
                        });
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//text field
class MyTextFormField extends StatelessWidget {
  MyTextFormField(
      {super.key,
      required this.label,
      this.validate,
      this.controller,
      this.inputType,
      this.suffix,
      this.prefix,
      this.textInputFormatter});
  final String label;
  TextEditingController? controller;
  TextInputType? inputType;
  Text? suffix;
  Text? prefix;
  List<TextInputFormatter>? textInputFormatter;
  String? Function(String)? validate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: TextFormField(
        validator: validate != null ? (value) => validate!(value!) : null,
        controller: controller,
        keyboardType: inputType,
        inputFormatters: textInputFormatter,
        decoration: InputDecoration(
            fillColor: Colors.grey[200],
            filled: true,
            prefix: prefix,
            suffix: suffix,
            label: Text(label),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),
    );
  }
}
