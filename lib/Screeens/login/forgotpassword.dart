import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

import 'package:zxc/Screeens/login/loginpage.dart';


class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  void sendPasswordResetEmail(BuildContext context) async {
    String email = emailController.text.trim();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Reset Link Sent'),
            content: Text('Reset link sent successfully.'),
            actions: [
              TextButton(
                onPressed: () async {

                  final intent = AndroidIntent( action: 'action_view',
                    data: 'https://play.google.com/store/apps/details?'
                        'id=com.google.android.apps.facebook',
                    arguments: {'authAccount': 'arunjoseoffical@gmail.com'},);
                  intent.launch();
                },
                child: Text('Open Email App'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => loginpage()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Show an error message or handle the error appropriately
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(


            title: Text('Error'),
            content: Text('Failed to send reset link: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => loginpage()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff1A1919),
        appBar: AppBar(
          centerTitle: true,
          title: FittedBox(fit: BoxFit.fitWidth, child: Text('Forgot Password')),
          actions: [
            IconButton(
                onPressed: () {
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => FetchData()));
                },
                icon: Icon(FontAwesomeIcons.circleInfo))
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(Material.defaultSplashRadius),
              child: Column(children: [
                const SizedBox(height: 200),
                TextFormField(
                  controller: emailController,
                  onChanged: (value) {
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide:
                              BorderSide(width: 1, color: Colors.black87)),
                      label:
                          Text('Enter registered Email', style: TextStyle(color: Colors.white)),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        FontAwesomeIcons.circleUser,
                        color: Color(0xffDDCA1C),
                      ),
                      labelStyle: TextStyle(color: Color(0xffDDCA1C)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(
                              width: 2.0, color: Color(0xffDDCA1C)))),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 255, height: 45, //form submit button
                  child: ElevatedButton(
                      onPressed: ()=> sendPasswordResetEmail(context),
                      child: const Text('Reset Password',
                          style:
                          TextStyle(fontSize: 18, color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffDDCA1C),
                          side: BorderSide.none,
                          shape: StadiumBorder())),
                ),
              ])),
        ));
  }
}
