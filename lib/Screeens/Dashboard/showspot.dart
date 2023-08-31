
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zxc/Screeens/Dashboard/newhome.dart';
import 'package:zxc/Screeens/Dashboard/payment.dart';
import 'package:zxc/Screeens/profile/profile.dart';
import 'package:zxc/Screeens/Dashboard/newhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;


class displayspot extends StatefulWidget {

  String spotid;
  String name;
  int available;
  int total;


  displayspot({Key? key,required this.spotid,required this.name,required this.total,required this.available}) : super(key: key);

  @override
  State<displayspot> createState() => _displayspotState();
}

class _displayspotState extends State<displayspot> {

  Future<String?> getImageUrl(String imageName) async {
    String? imageUrl;

    try {
      final ref = storage.FirebaseStorage.instance.ref().child('parking_images/$imageName');
      imageUrl = await ref.getDownloadURL();
    } catch (e) {
      print('Error retrieving image URL: $e');
    }

    return imageUrl;
  }
  Widget listItem() {
    return Container(
      height:  MediaQuery.of(context).size.height* .38,
      width: double.infinity ,
      padding: const EdgeInsets.all(Material.defaultSplashRadius),
      child: Column(
        children: [

          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 100,
                  color: Color(0xff595848), // Set the desired background color
                  child:
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.available.toString() ?? 'Loading',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Available',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ColoredBox(
            color: Colors.blueGrey,
            child: SizedBox(
              height: 10,
              width: 350,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Column(
              children: [
                Container(
                  width: 336,
                  height: 100,
                  color: Color(0xff595848), // Set the desired background color
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.total.toString()??'loading',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'TOTAL',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 2,
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff1A1919),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(FontAwesomeIcons.circleChevronLeft),),
        title: FittedBox(fit: BoxFit.fitWidth, child: Text(widget.name)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => newhome()));
              },
              icon: Icon(FontAwesomeIcons.home))
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(

          children: [const SizedBox(height: 10,),
            listItem(),
        ColoredBox(
            color: Colors.cyan,
            child: SizedBox(
              height: 8,
              width: double.infinity,
            ),
          ),

            Container(
              height:MediaQuery.of(context).size.height* .4 ,
              child: FutureBuilder<String?>(
                future: getImageUrl('${widget.spotid}.jpg'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error retrieving image');
                  } else if (snapshot.data != null) {
                    return Image.network(snapshot.data!);
                  } else {
                    return Text('Image not found');
                  }
                },
              ),
            ),

            SizedBox(
              child:ElevatedButton(
                  onPressed: ()  {Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Payment ()));
                  },
                  child: const Text('Book Spot',
                      style: TextStyle(
                          fontSize: 18, color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffDDCA1C),
                      side: BorderSide.none,
                      shape: StadiumBorder())),

            ),
          ],
        ),
      ),
    );
  }
}