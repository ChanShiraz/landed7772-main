import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:layout/models/builder.dart';
import 'package:layout/screens/drawer_page/util/firebase_services.dart';
import 'package:layout/screens/drawer_page/valuation%20.dart';

import '../../costants/constans.dart';
import 'bankder.dart';

class RequestForBuilderScreen extends StatelessWidget {
  RequestForBuilderScreen(
      {super.key, required this.formType, required this.description});
  String formType;
  String description;
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController,
      mobileNoController,
      emailController,
      propertyController,
      postalController;
  @override
  Widget build(BuildContext context) {
    nameController = TextEditingController();
    mobileNoController = TextEditingController();
    emailController = TextEditingController();
    propertyController = TextEditingController();
    postalController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Request For $formType',
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
                  Text(description),
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
                    controller: propertyController,
                    label: 'Property Address',
                  ),
                  MyTextFormField(
                    controller: postalController,
                    label: 'Postal Code',
                    inputType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            BuilderModel builderModel = BuilderModel(
                                name: nameController.text,
                                mobileNo: mobileNoController.text,
                                email: emailController.text,
                                propertyAddress: propertyController.text,
                                postalCode: postalController.text);
                            final FirebaseServices firebaseServices = FirebaseServices();
                            firebaseServices.uploadBuilder(formType, builderModel);    
                            final Email email = Email(
                                subject: 'Request For $formType',
                                body:
                                    'Name : ${nameController.text} \n Mobile No : ${mobileNoController.text} \n Email : ${emailController.text} \n Property Address ${propertyController.text} \n Postal Code ${postalController.text}',
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
