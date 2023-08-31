import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
ImagePicker Picker = ImagePicker();

class imagepicker extends StatelessWidget {

  const imagepicker({Key?key}) :
        super(key: key);


  @override
  Widget build(BuildContext context){


    return Container(
      height: 100,
      width: 300,
      color: Color(0xffDDCA1C),
      margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20
      ),
      child: Column(
        children: <Widget>[
          Text(

            "Choose profile picture",
            style: TextStyle(fontSize: 20,color: Colors.white),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton.extended(onPressed: () {


              },
                label: Text('Camera'),
                icon: Icon(FontAwesomeIcons.camera)
                ,),
              FloatingActionButton.extended(onPressed: () {},
                label: Text('Gallery'),
                icon: Icon(FontAwesomeIcons.images)
                ,)

            ],)
        ],
      ),
    );
  }


}

