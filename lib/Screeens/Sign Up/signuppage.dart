// import 'dart:js';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zxc/Screeens/login/loginpage.dart';
import 'package:zxc/logics/authlogic.dart';
import 'package:zxc/Screeens/profile/profile.dart';
import 'package:zxc/Screeens/profile/widgets/imagepicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:validators/validators.dart';
class SignUpPage extends StatelessWidget {

   // SignUpPage ({Key?key}) :
   //      super(key: key);

  CollectionReference users= FirebaseFirestore.instance.collection('users');
  late String name;
  late String email;
  late String phone;
  late String gender;
  late String dob;
  late String password;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold( backgroundColor: Color(0xff1A1919),
      appBar: AppBar(

        leading: IconButton(onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => loginpage()));
        }, icon: const Icon(FontAwesomeIcons.chevronCircleLeft)),
        centerTitle: true,
        title: FittedBox( fit: BoxFit.fitWidth,  child: Text('Sign Up') ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,

      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(Material.defaultSplashRadius),
          child: Column(
            children: [
              // const SizedBox(height: 50,),
              const SizedBox(height: 60),

              TextFormField(
                  onChanged:(value){
                    name=value;
                },
                style: TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(width: 1, color: Colors.black87)),
                    label: Text('Full Name',style: TextStyle(color: Colors.white)),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(FontAwesomeIcons.circleUser,color: Color(0xffDDCA1C),),
                    labelStyle: TextStyle(color: Color(0xffDDCA1C)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(width: 2.0,color: Color(0xffDDCA1C))
                    )

                ),

              ),//name
              const SizedBox(height: 30,),
              TextFormField(
                  onChanged:(value){
                    email=value;
                },
                style: TextStyle(color: Colors.white),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) => !isEmail(val!) ? "Invalid Email" : null,
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(width: 1, color: Colors.black87)),
                    label: Text('Email',style: TextStyle(color: Colors.white)),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(FontAwesomeIcons.envelopeCircleCheck,color: Color(0xffDDCA1C),),
                    labelStyle: TextStyle(color: Color(0xffDDCA1C)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(width: 2.0,color: Color(0xffDDCA1C))
                    )

                ),

              ),//email
              const SizedBox(height: 30,),
              TextFormField(
                  onChanged:(value){
                    phone=value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) => !isNumeric(val!) ? "Invalid Number" : null,
                style: TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(width: 1, color: Colors.black87)),
                    label: Text('Phone',style: TextStyle(color: Colors.white)),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(FontAwesomeIcons.phone,color: Color(0xffDDCA1C),),
                    labelStyle: TextStyle(color: Color(0xffDDCA1C)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(width: 2.0,color: Color(0xffDDCA1C))
                    )

                ),

              ),//phone
              const SizedBox(height: 30,),
              TextFormField(
                  onChanged:(value){
                    gender=value;
                },
                style: TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(width: 1, color: Colors.black87)),
                    label: Text('Gender',style: TextStyle(color: Colors.white)),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(FontAwesomeIcons.person,color: Color(0xffDDCA1C),),
                    labelStyle: TextStyle(color: Color(0xffDDCA1C)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(width: 2.0,color: Color(0xffDDCA1C))
                    )

                ),

              ),//gender
              const SizedBox(height: 30,),
              TextFormField(
                  onChanged:(value){
                    dob=value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) => !isDate(val!) ? "Invalid Date of Birth" : null,
                style: TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(width: 1, color: Colors.black87)),
                    label: Text('DOB',style: TextStyle(color: Colors.white)),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(FontAwesomeIcons.calendarDay,color: Color(0xffDDCA1C),),
                    labelStyle: TextStyle(color: Color(0xffDDCA1C)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(width: 2.0,color: Color(0xffDDCA1C))
                    )

                ),

              ),//dob
              const SizedBox(height: 30,),
              TextFormField(
                onChanged:(value){
                  password=value;
                },
                style: TextStyle(color: Colors.white),
                obscureText: true,
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(width: 1, color: Colors.black87)),
                    label: Text('Password',style: TextStyle(color: Colors.white)),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(FontAwesomeIcons.key,color: Color(0xffDDCA1C),),
                    labelStyle: TextStyle(color: Color(0xffDDCA1C)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(width: 2.0,color: Color(0xffDDCA1C))
                    )

                ),

              ),//password
              //signupform(title:"Full Name",icon:FontAwesomeIcons.circleUser), //each edit field is implemented as a function call
             //  const SizedBox(height: 30,),
             //
             // // signupform(title:"Email",icon:FontAwesomeIcons.envelope),
             //  const SizedBox(height: 30,),
             //  //signupform(title:"Phone",icon:FontAwesomeIcons.squarePhone),
             //  const SizedBox(height: 30,),
             //  //signupform(title:"Gender",icon:FontAwesomeIcons.person),
             //  const SizedBox(height: 50),
             //  //signupform(title:"DOB",icon:FontAwesomeIcons.person),
             //  const SizedBox(height: 50),
              //signupform(title:"Password",icon:FontAwesomeIcons.person),
              const SizedBox(height: 50),
              SizedBox(width:155,height: 45, //form submit button
                child: ElevatedButton(
                    onPressed: ( ) async {
                      // await users.add({'name':name,
                      //   'email':email,
                      //   'phone':phone,
                      //   'gender':gender,
                      //   'dob':dob,
                      //   'password':password}
                      // ).then((value) => print('user added'));
                      AuthServices.signupUser(
                          email, password,name,gender,dob, context);
                    },
                    child: const Text('Sign in',style: TextStyle(fontSize: 18,color: Colors.black)),
                    style:ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffDDCA1C), side: BorderSide.none, shape: StadiumBorder()
                    )
                ),
              ),


            ],
          ),

        ),
      ),
    );

  }
}


