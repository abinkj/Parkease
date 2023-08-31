import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zxc/Screeens/profile/profile.dart';
class signupform extends StatelessWidget {
  signupform({

    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);
  final String title;
  final IconData icon;
  // static String data='';
  @override
  Widget build(BuildContext context) {
    return Form(child: Column(
      children: [
        TextFormField(
        //   onChanged:(value){
        //     data=value;
        // },
          style: TextStyle(color: Colors.white),
          decoration:  InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(width: 1, color: Colors.black87)),
              label: Text(title,style: TextStyle(color: Colors.white)),
              border: OutlineInputBorder(),
              prefixIcon: Icon(icon,color: Color(0xffDDCA1C),),
              labelStyle: TextStyle(color: Color(0xffDDCA1C)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(width: 2.0,color: Color(0xffDDCA1C))
              )

          ),

        ),


      ],

    )
    );
  }
}
