import 'package:chat_app/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void _submitAuthForm(
    String _email,
    String _username,
    String _password,
    bool _isLogin,
  ) async {
    final _auth = FirebaseAuth.instance;
    try {
      if (_isLogin) {
        final authResult = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } else {
        final authResult = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
      }
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your credentials';
      if (err.message != null) {
        message = err.message!;
      }
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: AuthForm(submitfn: _submitAuthForm),
      ),
    );
  }
}
