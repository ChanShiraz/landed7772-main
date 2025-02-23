import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/extensions/contexExt.dart';
import 'package:layout/features/home/view/home.dart';
import 'package:layout/state/text_box/bloc/text_box_bloc.dart';

import '../costants/colors.dart';
import 'login.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late TextBoxBloc textBoxBloc;
  @override
  Widget build(BuildContext context) {
    textBoxBloc = context.read<TextBoxBloc>();
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: context.height,
            color: AppColor.primaryBlue,
            child: Column(
              children: [
                const Expanded(
                    flex: 3,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Real Estate App',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Let\'s find home for you.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ))),
                Expanded(
                  flex: 7,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 50, bottom: 50),
                          child: Text(
                            'Create account using email and password',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                        ),
                        BlocBuilder(
                          bloc: textBoxBloc,
                          builder: (context, state) {
                            if (state is NameErrorState) {
                              return MyTextField(
                                label: 'Name',
                                controller: nameController,
                                errorText: state.errorText,
                                onChange: (value) {
                                  textBoxBloc.add(NameCheckEvent(
                                      text: value,
                                      errorText: 'Please enter your name.'));
                                },
                              );
                            }
                            return MyTextField(
                              label: 'Name',
                              controller: nameController,
                              errorText: null,
                              onChange: (value) {
                                textBoxBloc.add(NameCheckEvent(
                                    text: value, errorText: null));
                              },
                            );
                          },
                        ),
                        BlocBuilder(
                          bloc: textBoxBloc,
                          builder: (context, state) {
                            if (state is SEmailErrorState) {
                              return MyTextField(
                                label: 'Email',
                                controller: emailController,
                                errorText: state.errorText,
                                onChange: (value) {
                                  textBoxBloc.add(SEmailCheckEvent(
                                      text: value,
                                      errorText: 'Please enter email'));
                                },
                              );
                            }
                            return MyTextField(
                              label: 'Email',
                              controller: emailController,
                              errorText: null,
                              onChange: (value) {
                                textBoxBloc.add(SEmailCheckEvent(
                                    text: value, errorText: null));
                              },
                            );
                          },
                        ),
                        BlocBuilder(
                          bloc: textBoxBloc,
                          builder: (context, state) {
                            if (state is SPasswordErrorState) {
                              return MyTextField(
                                label: 'Password',
                                obscure: true,
                                controller: passwordController,
                                errorText: state.errorText,
                                inputType: TextInputType.emailAddress,
                                onChange: (value) {
                                  textBoxBloc.add(SPasswordCheckEvent(
                                      text: value,
                                      errorText: 'Please enter password'));
                                },
                              );
                            }
                            return MyTextField(
                              obscure: true,
                              label: 'Password',
                              controller: passwordController,
                              onChange: (value) {
                                textBoxBloc.add(SPasswordCheckEvent(
                                    text: value, errorText: null));
                              },
                            );
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        BlocBuilder(
                          bloc: textBoxBloc,
                          builder: (context, state) {
                            if (state is SSignInErrorState) {
                              return Text(
                                state.errorText,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400),
                              );
                            }
                            return const Text('');
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: 200,
                          height: 40,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13)),
                                // backgroundColor: AppColor.primaryBlue,
                              ),
                              onPressed: () {
                                String name = nameController.text;
                                String email = emailController.text;
                                String password = passwordController.text;
                                if (name.isEmpty) {
                                  textBoxBloc.add(NameCheckEvent(
                                      text: name,
                                      errorText: 'Please enter your name'));
                                } else if (email.isEmpty) {
                                  textBoxBloc.add(SEmailCheckEvent(
                                      text: email,
                                      errorText: 'Please enter email'));
                                } else if (!email.contains('@gmail.com')) {
                                  textBoxBloc.add(SSignInCheckEvent(
                                      errorText: 'Please enter a valid email'));
                                } else if (password.isEmpty) {
                                  textBoxBloc.add(SPasswordCheckEvent(
                                      text: password,
                                      errorText: 'Please enter password'));
                                } else {
                                  createAccount(name, email, password,
                                      textBoxBloc, context);
                                }
                              },
                              child: const Text('Sign Up')),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: RichText(
                            text: TextSpan(
                                text: 'Already have an account?',
                                style: const TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  const TextSpan(text: ' '),
                                  TextSpan(
                                    text: 'Log in',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = (() {
                                        //navigate to signup screen
                                        Navigator.of(context).pop();
                                      }),
                                  ),
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void createAccount(String name, String email, String password,
      TextBoxBloc bloc, BuildContext context) async {
    try {
      showDialog(
        context: context,
        builder: (context) => MyDialouge(text: 'Creating Account'),
      );
      final credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        signIn(name, email, password, context);
        return;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        bloc.add(SSignInCheckEvent(errorText: 'Password is weak.'));
        Navigator.of(context).pop();

        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        bloc.add(SSignInCheckEvent(
            errorText: 'The account already exists for that email.'));
        Navigator.of(context).pop();

        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void signIn(
      String name, String email, String password, BuildContext context) async {
    final userCredentials = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    final user = userCredentials.user;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .set({'Name': name});

    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => HomeScreen(),
    ));
  }
}
