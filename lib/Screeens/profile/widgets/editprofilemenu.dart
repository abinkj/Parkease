// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:park_ease/Screeens/profile/profile.dart';
// class profiledit extends StatelessWidget {
//   const profiledit({
//
//     Key? key,
//     required this.title,
//     required this.icon,
//   }) : super(key: key);
//   final String title;
//   final IconData icon;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(child: Column(
//       children: [
//         TextFormField(style: TextStyle(color: Colors.white),
//           decoration:  InputDecoration(
//               enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(100),
//                   borderSide: BorderSide(width: 1, color: Colors.black87)),
//               label: Text(title,style: TextStyle(color: Colors.white)),
//               border: OutlineInputBorder(),
//               prefixIcon: Icon(icon,color: Color(0xffDDCA1C),),
//               labelStyle: TextStyle(color: Color(0xffDDCA1C)),
//               focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(100),
//                   borderSide: BorderSide(width: 2.0,color: Color(0xffDDCA1C))
//               )
//
//           ),
//
//         ),
//
//
//       ],
//
//     )
//     );
//   }
// }
import 'package:flutter/material.dart';


class profiledit extends StatelessWidget {
  const profiledit({
    Key? key,
    required this.title,
    required this.icon,
    required this.controller,
    required this.validator

  }) : super(key: key);

  final String title;
  final IconData icon;
  final TextEditingController controller;
  final FormFieldValidator validator;


  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            validator: validator,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(width: 1, color: Colors.black87),
              ),
              label: Text(title, style: TextStyle(color: Colors.white)),
              border: OutlineInputBorder(),
              prefixIcon: Icon(icon, color: Color(0xffDDCA1C)),
              labelStyle: TextStyle(color: Color(0xffDDCA1C)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(width: 2.0, color: Color(0xffDDCA1C)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

