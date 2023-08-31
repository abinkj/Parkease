import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';


class PasswordChangePage extends StatefulWidget {
  @override
  _PasswordChangePageState createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isOTPSent = false;
  bool isOtpValid=false;
  late String newpassword;
  late String confirmpassword;
  late String email;
  late String otp;
  late EmailAuth emailAuth;
  final TextEditingController _otpController = TextEditingController();




  void sendLink() async {
    // Check if newpassword and confirmpassword are equal
    if (newpassword == confirmpassword) {
      try {
        // Send OTP to the registered email address

        await _auth.sendPasswordResetEmail(email: FirebaseAuth.instance.currentUser?.email ?? '',);
        setState(() {
          isOtpValid = true;
        });
        // Show a snackbar or toast message indicating that OTP is sent
        //
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("OTP sent to ${FirebaseAuth.instance.currentUser?.email ?? ''} "),
        //   ),
        // );
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('Reset Link Sent'),
              content: Text('The reset link has been sent to your email.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    isOTPSent=true;
                    Navigator.pop(dialogContext);
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Show a snackbar or toast message indicating the error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send OTP: $e'),
          ),
        );
      }
    } else {
      // Show a snackbar or toast message indicating that the passwords don't match
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match.'),
        ),
      );
    }
  }

  void updatePassword(otp,newpassword) async {
    try {
      // Verify the OTP entered by the user
      await _auth.confirmPasswordReset(newPassword:newpassword, code: otp);

      // Get the current user
      User? user = _auth.currentUser;

      if (user != null) {
        // Update the user's password
        await user.updatePassword(newpassword);

        // Show a snackbar or toast message indicating that the password is updated
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password updated successfully.'),
          ),
        );
      } else {
        // Handle the case when the user is not authenticated
        // Show a snackbar or toast message indicating the error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not authenticated.'),
          ),
        );
      }
    } catch (e) {
      // Show a snackbar or toast message indicating the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update password: $e'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize the package
    emailAuth = new EmailAuth(
      sessionName: "Sample session",
    );

    /// Configuring the remote server

  }
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: Color(0xff1A1919),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(FontAwesomeIcons.chevronCircleLeft),
        ),
        centerTitle: true,
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text('Change Password'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 150),
              const SizedBox(height: 40),
              const SizedBox(height: 30),
              TextFormField(
                onChanged: (value) {
                  newpassword = value;
                },
                style: TextStyle(color: Colors.white),
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(width: 1, color: Colors.black87),
                  ),
                  labelText: 'New Password',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    FontAwesomeIcons.circleUser,
                    color: Color(0xffDDCA1C),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(width: 2.0, color: Color(0xffDDCA1C)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                onChanged: (value) {
                  confirmpassword = value;
                },
                style: TextStyle(color: Colors.white),
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(width: 1, color: Colors.black87),
                  ),
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    FontAwesomeIcons.key,
                    color: Color(0xffDDCA1C),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(width: 2.0, color: Color(0xffDDCA1C)),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 255,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    sendLink();
                    if(isOTPSent) {
                      Navigator.pop(context);
                    }

                  },
                  child: const Text(
                    'Send Paasword Rest Link',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffDDCA1C),
                    side: BorderSide.none,
                    shape: StadiumBorder(),
                  ),
                ),
              ),
              // const SizedBox(height: 30),
              // TextFormField(
              //   controller: _otpController,
              //   enabled: isOTPSent,
              //   onChanged: (value) {
              //
              //       otp = value;
              //
              //   },
              //   style: TextStyle(color: Colors.white),
              //   decoration: InputDecoration(
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(100),
              //       borderSide: BorderSide(width: 1, color: Colors.black87),
              //     ),
              //     labelText: 'Enter OTP',
              //     labelStyle: TextStyle(color: Colors.white),
              //     border: OutlineInputBorder(),
              //     prefixIcon: Icon(
              //       FontAwesomeIcons.lock,
              //       color: Color(0xffDDCA1C),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(100),
              //       borderSide: BorderSide(width: 2.0, color: Color(0xffDDCA1C)),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 50),
              // SizedBox(
              //   width: 255,
              //   height: 45,
              //   child: ElevatedButton(
              //     onPressed:isOTPSent
              //         ? () {
              //
              //         updatePassword(otp, newpassword);
              //     }:null,
              //     child: const Text(
              //       'Update Password',
              //       style: TextStyle(fontSize: 18, color: Colors.black),
              //     ),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Color(0xffDDCA1C),
              //       side: BorderSide.none,
              //       shape: StadiumBorder(),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 140),
            ],
          ),
        ),
      ),
    );
  }
}
