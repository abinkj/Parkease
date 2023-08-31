
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:zxc/Screeens/Dashboard/homepage.dart';
import 'package:zxc/Screeens/Dashboard/newhome.dart';
import 'package:zxc/Screeens/profile/profile.dart';
import 'package:validators/validators.dart';
import 'package:zxc/Screeens/profile/widgets/imagepicker.dart';
import 'package:zxc/Screeens/profile/widgets/editprofilemenu.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({
    Key? key,
    required this.oldname,
    required this.oldphone,
    required this.oldgender,
    required this.olddob,
  }) : super(key: key);

  final String oldname;
  final String oldphone;
  final String oldgender;
  final String olddob;

  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController genderController;
  late TextEditingController dobController;
  String? profileimageurl;
  ImagePicker picker = ImagePicker();
  ImageProvider<Object>? profileImage;

  Future<void> _selectProfilePicture() async {
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: Text('Gallery'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: Text('Camera'),
            ),
          ],
        );
      },
    );

    if (imageSource != null) {
      final pickedImage = await picker.pickImage(source: imageSource);
      if (pickedImage != null) {
        setState(() {
          profileImage = Image.file(File(pickedImage.path)).image;
        });

        // Upload the image to Firebase Storage
        firebase_storage.Reference storageRef =
        firebase_storage.FirebaseStorage.instance.ref().child('profile_images/${FirebaseAuth.instance.currentUser!.uid}.jpg');
        firebase_storage.UploadTask uploadTask = storageRef.putFile(File(pickedImage.path));
        firebase_storage.TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);
        String downloadURL = await storageSnapshot.ref.getDownloadURL();

        // Update the image URL in the user's document
        final userDoc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
        await userDoc.update({
          'profileImageUrl': downloadURL,
        });

        print('Profile image updated successfully');
      }
    }
  }
  Future<void> fetchdata() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        final fetchedprofileimageurl = data?['profileImageUrl'];
        if (mounted) {
          setState(() {
            profileimageurl = fetchedprofileimageurl;

          });
        }
      } else {
        print('Document does not exist');
      }
      // Do something with the email
    }
  }
  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.oldname);
    emailController = TextEditingController(text: FirebaseAuth.instance.currentUser?.email);
    phoneController = TextEditingController(text: widget.oldphone);
    genderController = TextEditingController(text: widget.oldgender);
    dobController = TextEditingController(text: widget.olddob);
    fetchdata();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    genderController.dispose();
    dobController.dispose();
    super.dispose();
  }

  Future<void> updateUserInformation(String fullName, String email, String phone, String gender, String dob) async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        final userDoc = FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid);
        await userDoc.update({
          'name': fullName,
          'email': email,
          'phone': phone,
          'gender': gender,
          'dob': dob,
        });
        print('User information updated successfully');
      } else {
        print('User not authenticated');
      }
    } catch (error) {
      print('Failed to update user information: $error');
    }
  }

  Future<void> updateUserEmail(String newEmail) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateEmail(newEmail);
        String? userId = user.uid;
        DocumentSnapshot<Map<String, dynamic>> userDocument = await FirebaseFirestore.instance
            .collection('users')
            .where('userId', isEqualTo: userId)
            .limit(1)
            .get()
            .then((querySnapshot) => querySnapshot.docs.first);

        await userDocument.reference.update({
          'email': newEmail,
        });
        print('User email updated successfully');
      }
    } catch (e) {
      print('Error updating user email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: FittedBox(fit: BoxFit.fitWidth, child: const Text('Edit Profile')),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => newhome()),
              );
            },
            icon: Icon(FontAwesomeIcons.home),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: profileImage != null
                          ? Image(image: profileImage!, fit: BoxFit.cover)
                          : Image.network(profileimageurl??''),
                    ),

              ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {_selectProfilePicture();
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0xff1A1919),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.camera,
                          color: Color(0xffDDCA1C),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              profiledit(
                title: "Full Name",
                icon: FontAwesomeIcons.userCircle,
                controller: fullNameController,
                validator: (value) {},
              ),
              const SizedBox(height: 30),
              profiledit(
                title: "Email",
                icon: FontAwesomeIcons.envelope,
                controller: emailController,
                validator: (val) => !isEmail(val) ? "Invalid Email" : null,
              ),
              const SizedBox(height: 30),
              profiledit(
                title: "Phone",
                icon: FontAwesomeIcons.phoneSquare,
                controller: phoneController,
                validator: (val) => !isNumeric(val) ? "Invalid number" : null,
              ),
              const SizedBox(height: 30),
              profiledit(
                title: "Gender",
                icon: FontAwesomeIcons.male,
                controller: genderController,
                validator: (val) => !isAlpha(val) ? "Invalid gender" : null,
              ),
              const SizedBox(height: 50),
              profiledit(
                title: "DOB",
                icon: FontAwesomeIcons.calendar,
                controller: dobController,
                validator: (val) => !isDate(val) ? "Invalid DOB" : null,
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 155,
                height: 45,
                child:ElevatedButton(
                  onPressed: () async {
                    String fullName = fullNameController.text;
                    String email = emailController.text;
                    String phone = phoneController.text;
                    String gender = genderController.text;
                    String dob = dobController.text;

                    try {
                      await updateUserInformation(fullName, email, phone, gender, dob);
                      updateUserEmail(email);
                      Navigator.pop(context); // Navigate back to previous screen
                    } catch (error) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Error updating user information.'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffDDCA1C),
                    side: BorderSide.none,
                    shape: StadiumBorder(),
                  ),
                ),




              ),
            ],
          ),
        ),
      ),
    );
  }
}

