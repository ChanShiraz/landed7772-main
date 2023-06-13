import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:layout/extensions/contexExt.dart';
import 'package:layout/models/banker.dart';
import 'package:layout/screens/drawer_page/util/firebase_services.dart';
import 'package:layout/screens/drawer_page/valuation%20.dart';

import '../../costants/constans.dart';

class RequestForBankerScreen extends StatelessWidget {
  RequestForBankerScreen({super.key});
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController,
      mobileNoController,
      emailController;
  String? emailAddress, preferedBank;
  @override
  Widget build(BuildContext context) {
    nameController = TextEditingController();
    mobileNoController = TextEditingController();
    emailController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Request For Banker',
            style: TextStyle(color: Colors.black),
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
                  const Text(
                      'Interested to find out your potential loan amount for a property purchase? We partner with a variety of experienced bankers well-versed in landed property financing. Fill in the form, and we\'ll reach out soon.'),
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
                  PreferedBankWidget(
                    preferedBank: (p0) {
                      preferedBank = p0;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final Banker banker = Banker(
                                name: nameController.text,
                                mobileNo: mobileNoController.text,
                                email: emailController.text,
                                preferedBank: preferedBank);
                          final FirebaseServices firebaseServices = FirebaseServices();
                          firebaseServices.uploadBankerRequest(banker);      
                            final Email email = Email(
                                subject: 'Request For Banker',
                                body:
                                    'Name : ${nameController.text} \n Mobile No : ${mobileNoController.text} \n Email : ${emailController.text} \n Prefered Bank :$preferedBank',
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

//success dialouge
class ForumsSuccessDialouge extends StatelessWidget {
  const ForumsSuccessDialouge({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Success'),
      content: const Text(
          'Thank you! Your request has been submitted. We will contact you soon.'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'))
      ],
    );
  }
}

//last renovation dropdown
class PreferedBankWidget extends StatefulWidget {
  const PreferedBankWidget({super.key, required this.preferedBank});
  final Function(String) preferedBank;
  @override
  State<PreferedBankWidget> createState() => _PreferedBankWidget();
}

class _PreferedBankWidget extends State<PreferedBankWidget> {
  String? preferedBank;
  var items = ['DBS', 'OCBC', 'UOB', 'MAYBANK', 'CITIBANK', 'STANDCHART'];
  String? initialValue = 'DBS';
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
              const Text('Prefered Bank'),
              Container(
                height: 40,
                width: context.width * 0.45,
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
                          widget.preferedBank(value);
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
