import 'dart:io';

import 'package:chat_app/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  void _submitAuthForm(String _email, String _username, String _password,
      bool _isLogin, BuildContext ctx, File? image) async {
    final _auth = FirebaseAuth.instance;
    try {
      setState(() {
        _isLoading = true;
      });
      if (_isLogin) {
        final authResult = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } else {
        final authResult = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user!.uid + '.jpg');
        await ref.putFile(image!);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': _username,
          'email': _email,
          'image_url': url,
        });
      }
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (err) {
      var message = 'An error occured, please check your credentials';
      if (err.message != null) {
        message = err.message!;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: AuthForm(submitfn: _submitAuthForm, isLoading: _isLoading),
      ),
    );
  }
}
