import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_management/widgets/default_scaffold.dart';
import 'package:stock_management/widgets/scaffold_no_appbar.dart';

import '../repositories/auth_repository.dart';

final AuthRepository _auth = AuthRepository();

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _shopController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late bool _success = false;
  late bool _loading = false;
  late bool _passwordVisible = true;
  String _errorMessage = 'Error occured, try again';

  Future<void> _register() async {
    try {
      await _auth.signupWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message!;
      });
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldNoAppBar(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              'Register',
              style: TextStyle(
                  color: Color(0xFF122E40),
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.none,
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'User name',
                prefixIcon: Icon(Icons.person),
                hintText: 'Sandrine Mawen',
              ),
              validator: (value) {
                if (value is String) {
                  if (value.isEmpty) {
                    return 'Please enter your name';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              textInputAction: TextInputAction.none,
              controller: _shopController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'Shop',
                prefixIcon: Icon(Icons.shopping_cart),
                hintText: 'Shop name',
              ),
              validator: (value) {
                if (value is String) {
                  if (value.isEmpty) {
                    return "Please enter the shop's name";
                  }
                }
                return null;
              },
            ),
            // const SizedBox(height: 20),
            // TextFormField(
            //   keyboardType: TextInputType.streetAddress,
            //   textInputAction: TextInputAction.none,
            //   controller: _addressController,
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //     ),
            //     labelText: 'Shop address',
            //     prefixIcon: Icon(Icons.person),
            //     hintText: 'KG 111 st',
            //   ),
            //   validator: (value) {
            //     if (value is String) {
            //       if (value.isEmpty) {
            //         return 'Please enter the  address';
            //       }
            //     }
            //     return null;
            //   },
            // ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.none,
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'Email',
                prefixIcon: Icon(Icons.mail),
                hintText: 'name@example.com',
              ),
              validator: (value) {
                if (value is String) {
                  if (value.isEmpty) {
                    return 'Please enter your email';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: _passwordVisible,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    icon: _passwordVisible
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  )),
              validator: (value) {
                if (value is String) {
                  if (value.isEmpty) {
                    return 'Please enter a password';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: const Text('Register'),
                onPressed: () {
                  // It returns true if the form is valid, otherwise returns false
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a Snackbar.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.grey.shade400,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        content: const Text(
                          'Processing...',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                    _register().then((value) {
                      setState(() {
                        _success = true;
                      });
                      if (_auth.currentUser != null) {
                        Navigator.of(context).pushNamed('/');
                      } else {
                        Navigator.of(context).pushNamed('/signin');
                      }
                    }).catchError((e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.red.shade400,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          content: Text(
                            _errorMessage,
                            style: const TextStyle(
                                fontSize: 24, color: Colors.white),
                          ),
                        ),
                      );
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account? '),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed('/signin');
                    },
                    child: Text('Login'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
