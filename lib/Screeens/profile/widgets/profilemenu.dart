import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onPress,
        leading: Container(
          width: 30, height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Color(0xff1A1919).withOpacity(0.1)
          ),
          child: Icon(icon, color:Color(0xffDDCA1C)),
        ),
        title: Text(title,style: TextStyle(fontSize: 20,color: Color(0xffffffff))),
        trailing: Container(
          width: 30, height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Color(0xff1A1919).withOpacity(0.1)
          ),
          child: const Icon(FontAwesomeIcons.chevronCircleRight, color:Color(0xffffffff)),

        )
    );
  }
}