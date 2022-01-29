import 'package:chat/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    submitAuthForm(email, password, username, isLogin, image) async {
      try {
        setState(() {
          isLoading = true;
        });
        final authResult;
        if (isLogin) {
          authResult = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
        } else {
          authResult = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          final ref = FirebaseStorage.instance
              .ref()
              .child('user_image')
              .child(authResult.user.uid + '.jpg');
          await ref.putFile(image);
          final url = await ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user.uid)
              .set({
            'username': username,
            'email': email,
            'profile_url': url,
          });
        }
        setState(() {
          isLoading = false;
        });
      } on FirebaseAuthException catch (error) {
        print(error);
        setState(() {
          isLoading = false;
        });
        var message = 'An error occurred. Please check your credentials';

        if (error.message != null) {
          message = error.message!;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      } catch (err) {
        setState(() {
          isLoading = false;
        });
        print(err);
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(submitAuthForm, isLoading),
    );
  }
}
