import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:zxc/logics/authlogic.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zxc/Screeens/Sign Up/signuppage.dart';
import 'package:zxc/Screeens/profile/profile.dart';
import 'package:zxc/Screeens/login/forgotpassword.dart';
import 'package:validators/validators.dart';

class loginpage extends StatelessWidget {
  late String email;
  late String password;
  bool isValidEmail(String value) {
    // Custom email validation logic
    // Return true if the email is valid, false otherwise
    // You can use regular expressions or other methods to validate the email format
    // Here's an example using a regular expression
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(value);
  }
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        backgroundColor: Color(0xff1A1919),
        appBar: AppBar(
          centerTitle: true,
          title: FittedBox(fit: BoxFit.fitWidth, child: Text('Profile')),
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
                  const SizedBox(height: 100),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "WELCOME BACK,",
                      style: TextStyle(
                        fontSize: 35,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) => !isEmail(val!) ? "Invalid Email" : null,
                    style: TextStyle(color: Colors.white),

                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(width: 1, color: Colors.black87),
                      ),
                      label: Text(
                        'Email',
                        style: TextStyle(color: Colors.white),
                      ),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        FontAwesomeIcons.circleUser,
                        color: Color(0xffDDCA1C),
                      ),
                      labelStyle: TextStyle(color: Color(0xffDDCA1C)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(width: 2.0, color: Color(0xffDDCA1C)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  TextFormField(
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black87)),
                        label: Text('Password',
                            style: TextStyle(color: Colors.white)),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          FontAwesomeIcons.key,
                          color: Color(0xffDDCA1C),
                        ),
                        labelStyle: TextStyle(color: Color(0xffDDCA1C)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(
                                width: 2.0, color: Color(0xffDDCA1C)))),
                  ),
                  Container(
                    width: 500, // Specify the width of the container
                    height: 50, // Specify the height of the container
                    child: Stack(
                      children: [
                        Positioned(
                          top: 2, // Specify the y-coordinate
                          left: 190, // Specify the x-coordinate
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                              );
                            },
                            child: Text('Forgot Password?'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 255, height: 45, //form submit button
                    child: ElevatedButton(
                        onPressed: () async {
                          AuthServices.signinUser(email, password, context);
                        },
                        child: const Text('Log in',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffDDCA1C),
                            side: BorderSide.none,
                            shape: StadiumBorder())),
                  ),
                  const SizedBox(height: 140),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Don't have an account ?",
                          style: TextStyle(
                            color: Color(0xffffffff),
                          )),
                      SizedBox(
                        width: 100, height: 35, //form submit button
                        child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                            },
                            child: const Text('Sign Up',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffffffff),
                                side: BorderSide.none,
                                shape: StadiumBorder())),
                      ),
                    ],
                  ),
                ] //children
                    ))));
  }
}
