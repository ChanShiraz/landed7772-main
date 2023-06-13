import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/extensions/contexExt.dart';
import 'package:layout/screens/drawer_page/valuation%20.dart';
import 'package:layout/screens/sign_up.dart';
import 'package:layout/state/text_box/bloc/text_box_bloc.dart';

import '../costants/colors.dart';
import 'home.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
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
                Expanded(
                    flex: 3,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Image(
                            image: AssetImage('assets/images/logo.png'),
                            height: 100),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Welcome back!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ))),
                Expanded(
                  flex: 6,
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
                            'Login using email and password',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                        ),
                        BlocBuilder(
                          bloc: textBoxBloc,
                          builder: (context, state) {
                            if (state is EmailErrorState) {
                              return MyTextField(
                                label: 'Email',
                                controller: emailController,
                                errorText: state.errorText,
                                onChange: (value) {
                                  textBoxBloc.add(EmailCheckEvent(
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
                                textBoxBloc.add(EmailCheckEvent(
                                    text: value, errorText: null));
                              },
                            );
                          },
                        ),
                        BlocBuilder(
                          bloc: textBoxBloc,
                          builder: (context, state) {
                            if (state is PasswordErrorState) {
                              return MyTextField(
                                obscure: true,
                                label: 'Password',
                                controller: passwordController,
                                errorText: state.errorText,
                                inputType: TextInputType.emailAddress,
                                onChange: (value) {
                                  textBoxBloc.add(PasswordCheckEvent(
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
                                textBoxBloc.add(PasswordCheckEvent(
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
                            if (state is SignInErrorState) {
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
                        Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 20),
                            child: InkWell(
                              onTap: () async {
                                showResetDialoge(context);
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline),
                              ),
                            )),
                        SizedBox(
                          width: 200,
                          height: 40,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13)),
                                backgroundColor: AppColor.primaryBlue,
                              ),
                              onPressed: () {
                                //   showDialog(
                                //     context: context,
                                //     builder: (context) => const MyDialouge(),
                                //   );

                                String email = emailController.text;
                                String password = passwordController.text;
                                if (email.isEmpty) {
                                  textBoxBloc.add(EmailCheckEvent(
                                      text: email,
                                      errorText: 'Please enter email'));
                                } else if (!email.contains('@gmail.com')) {
                                  textBoxBloc.add(SignInCheckEvent(
                                      errorText: 'Please enter a valid email'));
                                } else if (password.isEmpty) {
                                  textBoxBloc.add(PasswordCheckEvent(
                                      text: password,
                                      errorText: 'Please enter password'));
                                } else {
                                  signIn(email, password, textBoxBloc, context);
                                }
                              },
                              child: const Text('Login')),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: RichText(
                            text: TextSpan(
                                text: 'Don\'t have an account?',
                                style: const TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  const TextSpan(text: ' '),
                                  TextSpan(
                                    text: 'Sign up',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = (() {
                                        //navigate to signup screen
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => SignUpScreen(),
                                        ));
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

  void showResetDialoge(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => ResetDialouge(),
    );
  }

  //reset dialouge
  void signIn(String email, String password, TextBoxBloc bloc,
      BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (context) => MyDialouge(
                text: 'Signing in',
              ));
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.of(context).pop();
        return null;
      });

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        bloc.add(SignInCheckEvent(errorText: 'Account not found!'));
        Navigator.of(context).pop();
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        bloc.add(SignInCheckEvent(errorText: 'Password is wrong.'));
        Navigator.of(context).pop();
        print('Wrong password provided for that user.');
      }
    }
  }
}

class MyDialouge extends StatelessWidget {
  MyDialouge({super.key, required this.text});
  String text;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Center(child: Text(text)),
      content: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 100),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

//reset dialouge
class ResetDialouge extends StatelessWidget {
  ResetDialouge({super.key});
  final formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  @override
  Widget build(BuildContext context) {
    emailController = TextEditingController();
    return AlertDialog(
      title: const Text('Reset Password'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email'),
            const SizedBox(
              height: 5,
            ),
            Form(
              key: formKey,
              child: MyTextFormField(
                controller: emailController,
                label: 'Email',
                inputType: TextInputType.emailAddress,
                validate: (value) {
                  if (value.isNotEmpty &&
                      !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                          .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  } else if (value.isEmpty) {
                    return 'Please enter email first';
                  } else {
                    return null;
                  }
                },
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Password reset email has been sent!')));
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: emailController.text)
                    .then((value) {});
              }
            },
            child: const Text('Send'))
      ],
    );
  }
}

//my text field widget
class MyTextField extends StatelessWidget {
  MyTextField(
      {super.key,
      required this.label,
      this.controller,
      this.inputType,
      this.errorText,
      this.obscure = false,
      this.suffix,
      this.onChange,
      this.prefix,
      this.horizontalPadding = 20,
      this.textInputFormatter});
  bool obscure;
  double horizontalPadding;

  final String label;
  TextEditingController? controller;
  TextInputType? inputType;
  Text? suffix;
  Text? prefix;
  List<TextInputFormatter>? textInputFormatter;
  String? errorText;
  void Function(String)? onChange;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
      child: TextField(
        onChanged: (value) {
          onChange!(value);
        },
        controller: controller,
        keyboardType: inputType,
        obscureText: obscure,
        inputFormatters: textInputFormatter,
        decoration: InputDecoration(
            errorText: errorText,
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
