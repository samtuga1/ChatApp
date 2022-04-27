import 'dart:io';
import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm({Key? key, required this.submitfn, required this.isLoading})
      : super(key: key);
  bool isLoading;
  final void Function(String _userEmail, String _userName, String _userPassword,
      bool _isLogin, BuildContext ctx, File? image)? submitfn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _isLogin = false;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userImageFile;

  void pickedImage(File? pickedImage) {
    _userImageFile = pickedImage;
  }

  final _formKey = GlobalKey<FormState>();
  void _trySubmit() {
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitfn!(_userEmail.trim(), _userName.trim(),
          _userPassword.trim(), _isLogin, context, _userImageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (!_isLogin)
                UserImagePicker(
                  pickImage: pickedImage,
                ),
              TextFormField(
                  key: const ValueKey('email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(label: Text('Email'))),
              if (!_isLogin)
                TextFormField(
                  key: const ValueKey('username'),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 4) {
                      return 'Please enter at least 4 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userName = value!;
                  },
                  decoration: const InputDecoration(label: Text('Username')),
                ),
              TextFormField(
                key: const ValueKey('password'),
                validator: (value) {
                  if (value!.isEmpty || value.length < 7) {
                    return 'Please enter at least 7 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _userPassword = value!;
                },
                decoration: const InputDecoration(label: Text('Password')),
                obscureText: true,
              ),
              const SizedBox(
                height: 10,
              ),
              if (widget.isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (!widget.isLoading)
                RaisedButton(
                  onPressed: _trySubmit,
                  child: Text(_isLogin ? 'Login' : 'Signup'),
                ),
              if (!widget.isLoading)
                FlatButton(
                  child: Text(
                    _isLogin
                        ? 'Create an account'
                        : 'I already have an account',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                )
            ]),
          ),
        ),
      ),
    );
  }
}
