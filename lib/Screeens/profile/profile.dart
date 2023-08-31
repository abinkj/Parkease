import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:zxc/Screeens/Dashboard/homepage.dart';
import 'package:zxc/Screeens/Dashboard/newhome.dart';
import 'package:zxc/Screeens/profile/widgets/profilemenu.dart';
import 'package:zxc/Screeens/profile/updateprofile.dart';
import 'package:zxc/Screeens/changepassword/newpasswordpage.dart';
import 'package:zxc/Screeens/login/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
   // Assuming you pass the user ID as a parameter

  const ProfileScreen({Key? key, }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth=FirebaseAuth.instance;

  String? email;
  String? name;
  String? phone;
  String? gender;
  String? dob;
  String? profileimageurl;

  @override
  void initState() {
    super.initState();
    fetchdata();
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
        final fetchedEmail = data?['email'];
        final fetchedname = data?['name'];
        final fetchedphone = data?['phone'];
        final fetchedgender = data?['gender'];
        final fetcheddob = data?['dob'];
        final fetchedprofileimageurl = data?['profileImageUrl'];
        if (mounted) {
          setState(() {
            name = fetchedname;
            email=fetchedEmail;
            phone=fetchedphone;
            gender=fetchedgender;
            dob=fetcheddob;
            profileimageurl=fetchedprofileimageurl;
          });
        }
      } else {
        print('Document does not exist');
      }
        // Do something with the email
      }
    }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    print(email);
    return Scaffold(

      //backgroundColor: Colors.transparent,
      backgroundColor: Color(0xff1A1919),
      appBar: AppBar(

        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(FontAwesomeIcons.chevronCircleLeft)),
          centerTitle: true,
        title: FittedBox( fit: BoxFit.fitWidth,  child: Text('Profile') ),

        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => newhome()));
          }, icon:Icon(FontAwesomeIcons.home))
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,

      ),

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(Material.defaultSplashRadius),
          child: Column(
            children: [
              const SizedBox(height: 30),
              SizedBox(
                width: 120, height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    profileimageurl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback widget to display when an error occurs
                      return Image.asset(
                        'assets/images/profilesample.jpg',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(name ?? '',style: TextStyle(fontSize: 24,color: Color(0xffffffff))),
              Text(email ?? '',style: TextStyle(fontSize: 14,color: Color(0xffffffff))),
              const SizedBox(height: 20),
              SizedBox(width:200,height: 45,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileUpdate(oldname:name??'',oldphone:phone??'',oldgender:gender??'',olddob:dob??'')));
                      },
                      child: const Text('Edit Profile',style: TextStyle(fontSize: 18,color: Color(0xff000000))),
                      style:ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffDDCA1C), side: BorderSide.none, shape: StadiumBorder()
                      )
                  ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 40),
              //menu
              ProfileMenuWidget(title:"Change Password",icon: FontAwesomeIcons.key,onPress: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => PasswordChangePage()));}),
              const SizedBox(height: 3),
              ProfileMenuWidget(title:"Help",icon: FontAwesomeIcons.questionCircle,onPress: (){}),
              const SizedBox(height: 3),
              ProfileMenuWidget(title:"About",icon: FontAwesomeIcons.infoCircle,onPress: (){}),
              const SizedBox(height: 3),
              ProfileMenuWidget(title:"Terms & Conditions",icon: FontAwesomeIcons.fileContract,onPress: (){}),

              //logout
              const SizedBox(height: 50),
              SizedBox(width:155,height: 45,
                child: ElevatedButton(
                    onPressed: (){
                      auth.signOut().then((value) => {
                        Navigator.push(context, MaterialPageRoute(builder:(context)=>loginpage() ))
                      });
                    },
                    child: const Text('Log Out',style: TextStyle(fontSize: 18,color: Colors.red)),
                    style:ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffffffff), side: BorderSide.none, shape: StadiumBorder()
                    )
                ),
              ),




            ],
          ),
        ),
      ),
    );
    throw UnimplementedError();
  }

}


