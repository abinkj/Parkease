import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zxc/Screeens/Dashboard/showspot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart';
import 'dart:typed_data';



class LocationPage extends StatefulWidget {
  String spotid;
  String distance;
  LocationPage({Key? key,required this.spotid,required this.distance}) : super(key: key);
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  GoogleMapController? mapController;
  int? spaceCounter;
  String? spotname;
  int?total;
  late GeoPoint location;
  String?spotLocationName;
  late final BitmapDescriptor markerIcon;

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
  @override
  void initState()  {
    super.initState();
    fetchspotdata();
     _createCustomMarker() ;


  }
  Future<void> fetchspotdata() async {

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('spots')
          .doc(widget.spotid)
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
    getLocationInfo(location);

  }
  Future<BitmapDescriptor> _createCustomMarker() async {
    final ByteData markerIconByteData = await rootBundle.load('assets/images/parking-place.png');
    final Uint8List markerIconBytes = markerIconByteData.buffer.asUint8List();
    markerIcon=BitmapDescriptor.fromBytes(markerIconBytes);
    return BitmapDescriptor.fromBytes(markerIconBytes);
  }

  void getLocationInfo(GeoPoint coordinates) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          coordinates.latitude, coordinates.longitude);
      Placemark placemark = placemarks.first;
      setState(() {
        spotLocationName =
        '${placemark.locality}, ${placemark.administrativeArea}, ${placemark.isoCountryCode}';
      });
      print(spotLocationName);
    } catch (e) {
      print('Error: $e');
    }
  }

  void navigateToLocation(double latitude, double longitude) async {
    final currentPosition = await Geolocator.getCurrentPosition();
    final destination = Coords(latitude, longitude);

    final url =
        'https://www.google.com/maps/dir/?api=1&origin=${currentPosition.latitude},${currentPosition.longitude}&destination=${destination.latitude},${destination.longitude}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(spotname??'Loading...'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('spots') // Replace with your Firestore collection name
            .doc(widget.spotid) // Replace with the document ID containing the coordinates
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            final coordinates = snapshot.data!.get('coordinates') as GeoPoint;
            final initialCameraPosition = CameraPosition(
              target: LatLng(coordinates.latitude, coordinates.longitude),
              zoom: 15.5,
            );
            return Stack(
              children: [
                GoogleMap(

                  initialCameraPosition: initialCameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId('locationMarker'),
                      icon: markerIcon,
                      infoWindow: InfoWindow(
                        title: spotname as String,
                      ),
                      position: LatLng(coordinates.latitude, coordinates.longitude),
                    ),
                  },
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0,
                  right: 0,
                  height: 250.0, // Specify the desired height
                  child: Container(

                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color:Colors.grey.withOpacity(0.95) ),

                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                            spotname??'Loading....',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold,color: Colors.black),
                      ),
                            Text(
                              spotLocationName??'Loading....',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.normal,color: Colors.white54),
                            ),
                          ],
                        ),

                        Center(
                          child: Text(
                            '${widget.distance} KM' ??'Loading....',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.white70),
                          ),
                        ),
                        Text(
                          'Space Available: $spaceCounter'??'Loading....',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 32.0,fontWeight: FontWeight.bold,color: Colors.teal[800]),
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(width:155,height: 45,

                              child: ElevatedButton(

                                  onPressed: (){
                                    navigateToLocation(coordinates.latitude, coordinates.longitude);
                                  },
                                  child: const Text('Directions',style: TextStyle(fontSize: 18,color: Colors.red)),
                                  style:ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white, side: BorderSide.none, shape: StadiumBorder()
                                  )
                              ),
                            ),
                            SizedBox(width:155,height: 45,

                              child: ElevatedButton(

                                  onPressed: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => displayspot(spotid:widget.spotid??'',name:spotname??'',total:total??0,available:spaceCounter??0 )));
                                  },
                                  child: const Text('Show Spot',style: TextStyle(fontSize: 18,color: Colors.red)),

                                  style:ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white, side: BorderSide.none, shape: StadiumBorder()
                                  )
                              ),
                            ),
                            SizedBox(height: 10,)
                          ],
                        ),



                     ]
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
