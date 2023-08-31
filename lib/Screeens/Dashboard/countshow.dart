
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:zxc/Screeens/Dashboard/newhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class FetchData extends StatefulWidget {

  String spott_id;



  FetchData({Key? key,required this.spott_id}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  final FirebaseAuth auth=FirebaseAuth.instance;
 static const _initialcameraposition=CameraPosition(target:LatLng((36.773972), -122.431297),zoom: 1.0);
 int? spaceCounter;
 String? spotname;
 int?total;
  String? name;
 String? profileimageurl;
 late GeoPoint location;
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  String?imageurl;

  @override
  void initState() {
    super.initState();
    fetchspotdata();
    fetchdata();

  }


  Future<void> fetchspotdata() async {

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('spots')
          .doc(widget.spott_id)
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        final fetchedname = data?['name'];
        final fetchedcount= data?['spaceCounter'];
        final fetchedtotal= data?['total'];
        final fetchedlatlng= data?['coordinates'];
        if (mounted) {
          setState(() {
            spotname= fetchedname;
            spaceCounter=fetchedcount;
            total=fetchedtotal;
            location=fetchedlatlng;

          });
        }
      } else {
        print('Document does not exist');
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
        final fetchedname = data?['name'];
        final fetchedprofileimageurl = data?['profileImageUrl'];
        if (mounted) {
          setState(() {
            name = fetchedname;
            profileimageurl=fetchedprofileimageurl;
          });
        }
      } else {
        print('Document does not exist');
      }

    }
  }
  Widget listItem() {
    return Container(
      height:  MediaQuery.of(context).size.height* .5,
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
                  width: 336,
                  height: 100,
                  color: Color(0xff595848),
                   child:
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        spaceCounter?.toString() ?? 'Loading',
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
                  color: Color(0xff595848),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        total.toString()??'loading',
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
            height: 10,
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
          title: FittedBox(fit: BoxFit.fitWidth, child: Text(spotname??'loading')),
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
        body:Column(
          children: [listItem(),
            ColoredBox(
            color: Colors.cyan,
            child: SizedBox(
              height: 8,
              width: double.infinity,
            ),
          ),
            Container(
             height:  MediaQuery.of(context).size.height * .3 ,
              width: double.infinity,
                child:
                  GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(location.latitude, location.longitude),
              zoom: 15.0,
            ),
            mapType: MapType.normal,
            markers: {
              Marker(
                markerId: MarkerId(spotname!),
                position:  LatLng(location.latitude, location.longitude),
                infoWindow: InfoWindow(title: spotname),
              ),
            },
            zoomControlsEnabled: true,
            onMapCreated: (controller) {

            },
          ),
            ),

          ],
        ),
        );
  }
}

