import 'dart:io';

import 'package:chat/widgets/picker/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function onSubmit;
  final isLoading;
  AuthForm(this.onSubmit, this.isLoading);
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  var _email = '';
  var _password = '';
  var _username = '';
  File? _pickedImage;

  _pickedImageFn(File image) {
    _pickedImage = image;
  }

  _trySubmit() {
    final isvalid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (_pickedImage == null && !isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isvalid!) {
      _formKey.currentState?.save();
      widget.onSubmit(_email, _password, _username, isLogin, _pickedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (!isLogin) UserImagePicker(_pickedImageFn),
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                    ),
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Username must be at least 4 characters long.';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "User Name",
                      ),
                      onSaved: (value) {
                        _username = value!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                    onSaved: (value) {
                      _password = value!;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      child: Text(!isLogin ? "Signup" : "Login"),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(!isLogin
                          ? "I already have an account"
                          : "Create account"),
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
