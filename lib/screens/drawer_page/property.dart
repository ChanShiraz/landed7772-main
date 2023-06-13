import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:layout/extensions/contexExt.dart';
import 'package:layout/models/property_request.dart';
import 'package:layout/screens/drawer_page/util/firebase_services.dart';
import 'package:layout/screens/drawer_page/valuation%20.dart';

import '../nav_pages/searh_page.dart';
import '../../costants/constans.dart';
import 'bankder.dart';
class PropertyRequest extends StatefulWidget {
  const PropertyRequest({super.key});

  @override
  State<PropertyRequest> createState() => _PropertyRequestState();
}

class _PropertyRequestState extends State<PropertyRequest> {
  final formKey = GlobalKey<FormState>();

  final typesList = [
    'Inter Terrace',
    'Corner Terrace',
    'Semi-Detached',
    'Detached',
    'Strata Landed',
    'GCB'
  ];
  final propertyTypeCheck = List.generate(6, (index) => false);
  final tenureList = ['Freehold', ' 999 years', ' 99 years'];
  final tenureCheck = List.generate(3, (index) => false);

  List<String> _selectedItems = [];
  List<String> propertyTypeChecked = [];
  List<String> tenureChecked = [];
  late TextEditingController nameController;

  late TextEditingController mobileNoController;
  @override
  void initState() {
    nameController = TextEditingController();
    mobileNoController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileNoController.dispose();
    super.dispose();
  }

  void _showMultiSelect() async {
    final districtList = List.generate(29, (index) => 'D$index');

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: districtList);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Property Request',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                const Text(
                    'If you are looking for landed property, we will be happy to update you if we have any new listings that match your preference.Please provide as much information as possible so we can help to send you appropriate listings.'),
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
                DistrictSelectWidget(
                  seletedDistricts: _selectedItems,
                  voidCallback: () => _showMultiSelect(),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Property Type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CheckBoxs(types: typesList, checkValues: propertyTypeCheck),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tenure',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TenureChecks(
                    tenureChecks: tenureList, tenureChecksValue: tenureCheck),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          propertyTypeChecked = [];
                          tenureChecked = [];
                          for (var i = 0; i < propertyTypeCheck.length-1; i++) {
                            if (propertyTypeCheck[i] == true) {
                              propertyTypeChecked.add(typesList[i]);
                              //print(typesList[i]);
                            }
                          }
                          for (var i = 0; i < tenureCheck.length-1; i++) {
                            if (propertyTypeCheck[i] == true) {
                              tenureChecked.add(tenureList[i]);
                              //print(typesList[i]);
                            }
                          }
                        }
                        final PropertyRequestModel propertyRequest =
                            PropertyRequestModel(
                                name: nameController.text,
                                mobileNo: mobileNoController.text,
                                district: _selectedItems.toString(),
                                propertyType: propertyTypeChecked.toString(),
                                tenure: tenureChecked.toString());
                          final FirebaseServices firebaseServices = FirebaseServices();
                          firebaseServices.uploadPropertyRequest(propertyRequest);      
                        final Email email = Email(
                            subject: 'Request For Property',
                            body:
                                'Name : ${nameController.text} \n Mobile No : ${mobileNoController.text} \n Property Tye : $propertyTypeChecked \n Tenure : $tenureChecked \n District : $_selectedItems ',
                            recipients: [AppConstants.recevingEmail]);
                        try {
                          await FlutterEmailSender.send(email);
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (context) => const ForumsSuccessDialouge(),
                          );
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())));
                        }
                      },
                      child: const Text('Submit')),
                )
              ],
            ),
          ),
        ),
      )),
    ));
  }
}

//district select widget
class DistrictSelectWidget extends StatefulWidget {
  DistrictSelectWidget(
      {super.key, required this.voidCallback, this.seletedDistricts});
  VoidCallback voidCallback;
  List? seletedDistricts;

  @override
  State<DistrictSelectWidget> createState() => _DistrictSelectWidget();
}

class _DistrictSelectWidget extends State<DistrictSelectWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: widget.voidCallback,
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
                SizedBox(
                  width: context.width * 0.5,
                  child: widget.seletedDistricts!.isEmpty
                      ? const SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(child: Text('District')))
                      : Text(widget.seletedDistricts.toString()),
                ),
                Container(
                  height: 40,
                  width: context.width * 0.3,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text('Select'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Multi Select widget
class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select District'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

//tenure
class TenureChecks extends StatefulWidget {
  const TenureChecks(
      {Key? key, required this.tenureChecks, required this.tenureChecksValue})
      : super(key: key);
  final List<String> tenureChecks;
  final List<bool?> tenureChecksValue;

  @override
  _TenureChecks createState() => _TenureChecks();
}

class _TenureChecks extends State<TenureChecks> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 10.5,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: widget.tenureChecks.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Checkbox(
              value: widget.tenureChecksValue[index],
              onChanged: (value) {
                setState(() {
                  widget.tenureChecksValue[index] = value;
                });
              },
            ),
            Text(widget.tenureChecks[index]),
            const SizedBox(width: 10),
          ],
        );
      },
    );
  }
}
