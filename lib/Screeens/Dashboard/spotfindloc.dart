import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zxc/Screeens/Dashboard/newhome.dart';
import 'package:zxc/Screeens/Dashboard/showspot.dart';
class NearbySpotsScreen extends StatefulWidget {
  String locid;
  NearbySpotsScreen({Key? key,required this.locid}) : super(key: key);
  @override
  _NearbySpotsScreenState createState() => _NearbySpotsScreenState();
}

class _NearbySpotsScreenState extends State<NearbySpotsScreen> {
  Position? _userLocation;
  GeoPoint? inital;
  List<String> spotids = [];
  late GoogleMapController _mapController;
 // late Future<List<Map<String, dynamic>>> _fetchDataFuture;
  List<DocumentSnapshot> _nearbySpots = [];
  Set<Marker> _markers = {};
  late String totalspace;
  bool spotsnotnear=false;
  List distances=[];
  late Future<List<Map<String, dynamic>>> _fetchDataFuture2 = Future.value([]);




  @override
  void initState() {
    super.initState();

    _getUserLocation();


        _fetchDataFuture2 = fetchspotDocuments();

   // _loadMarkers();

    // _fetchDataFuture = fetchDocuments(spotids);

  }


  // Future<List<Map<String, dynamic>>> fetchDocuments(List<String> documentIds) async {
  //
  //   List<Map<String, dynamic>> nearbySpotsData = [];
  //   final firebaseUser = FirebaseAuth.instance.currentUser;
  //   //final ref = FirebaseDatabase.instance.ref();
  //    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$documentIds!!!!!!!!!!!!!!!!!!!!!!!');
  //   for (String documentId in documentIds) {
  //     final documentSnapshot = await FirebaseFirestore.instance
  //         .collection('spots')
  //         .doc(documentId)
  //         .get();
  //     if (documentSnapshot.exists) {
  //       final data = documentSnapshot.data();
  //       final fetchedspotname = data?['name'];
  //       final fetchedspottotal = data?['total'];
  //       final fetchedspotspace = data?['spaceCounter'];
  //       nearbySpotsData.add({
  //       'name': fetchedspotname,
  //       'spaceCounter': fetchedspotspace,
  //       'totalspace':fetchedspottotal,
  //
  //     }); }else {
  //       print('Document does not exist');
  //     }
  //
  //   }
  //   return nearbySpotsData;
  // }



  Future<BitmapDescriptor> _createCustomMarker() async {
    final ByteData markerIconByteData = await rootBundle.load('assets/images/parking-place.png');
    final Uint8List markerIconBytes = markerIconByteData.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(markerIconBytes);
  }
  //
  //
  Future<Position> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

  //  _userLocation=Geolocator.getCurrentPosition() as Position?;

    return await Geolocator.getCurrentPosition();
  }

  //
  // Future<List<DocumentSnapshot>> _getNearbySpots(Position userLocation, double radiusInKm) async {
  //   final CollectionReference spotsRef = FirebaseFirestore.instance.collection('spots');
  //
  //   final GeoPoint center = GeoPoint(userLocation.latitude, userLocation.longitude);
  //
  //   final double radius = radiusInKm * 1000; // Convert radius from km to meters
  //
  //   QuerySnapshot querySnapshot = await spotsRef
  //       .where('coordinates', isGreaterThan: GeoPoint(center.latitude - (radius / 111319), center.longitude - (radius / (111319 * cos(center.latitude)))))
  //       .where('coordinates', isLessThan: GeoPoint(center.latitude + (radius / 111319), center.longitude + (radius / (111319 * cos(center.latitude)))))
  //       .get();
  //   if (querySnapshot == null || querySnapshot.docs.isEmpty) {
  //     spotsnotnear=true;
  //     querySnapshot = await spotsRef
  //         .orderBy('coordinates', descending: false)
  //         .limit(2)
  //         .get();
  //   }
  //
  //   final List<String> nearbySpotIds = querySnapshot.docs.map((spot) => spot.id).toList();
  //   print('###############%%^^&*))(*^%#!!###############$nearbySpotIds');
  //   print(querySnapshot.docs);
  //   _nearbySpotIds = nearbySpotIds ;
  //   print(nearbySpotIds);
  //
  //   final List<DocumentSnapshot> nearbySpots = querySnapshot.docs;
  //   distances=[];
  //   for (DocumentSnapshot spot in nearbySpots) {
  //     final spotCoordinates = spot['coordinates'] as GeoPoint;
  //     final double distance = calculateDistance(
  //       userLocation.latitude,
  //       userLocation.longitude,
  //       spotCoordinates.latitude,
  //       spotCoordinates.longitude,
  //     );
  //     final roundedDistance = distance.toStringAsFixed(2);
  //     print('Distance to ${spot['name']}: $distance meters');
  //     distances.add(
  //       {
  //         'spotid':spot.id,
  //         'distance': roundedDistance
  //       }
  //     );
  //   }
  //
  //
  //   return querySnapshot.docs;
  // }
  //
  // double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  //   double p = 0.017453292519943295;
  //   double a = 0.5 -
  //       cos((lat2 - lat1) * p) / 2 +
  //       cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  //   return 12742 * asin(sqrt(a));
  // }

  Future<void> _loadMarkers() async {
   _userLocation=await _getUserLocation();
    print(_userLocation);
    final BitmapDescriptor markerIcon = await _createCustomMarker();

    final Set<Marker> markers = _nearbySpots.map((spot) {
      final spotData = spot.data() as Map<String, dynamic>;
      print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%$spotData');
      final spotCoordinates = spotData['coordinates'] as GeoPoint;


      return Marker(
        markerId: MarkerId(spot.id),
        position: LatLng(spotCoordinates.latitude, spotCoordinates.longitude),
        icon: markerIcon,
        infoWindow: InfoWindow(
          title: spotData['name'] as String,
        ),
      );
    }).toSet();

    setState(() {
      _markers = markers;
    });
  }
  //
  //
  Future<String?> fetchspotDocumentId(String collectionPath, String fieldName, dynamic searchValue) async {
    if (searchValue == null) {
      return null; // Return null if search value is null
    }

    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(collectionPath)
        .where(fieldName, isEqualTo: searchValue)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final DocumentSnapshot document = snapshot.docs.first;

      return document.id;
    }

    return null; // Document with the given field value not found
  }

  //
  // Future<List<String>> fetchspots(String documentId) async {
  //     List<String> ids=[];
  //
  //   // print('the fecthspot location is **************************************$selectedLocation');
  //
  //   // print(selectedLocation);
  //   // print(documentId);
  //   // if (documentId != null) {
  //   //   // Document ID found
  //   //   loc_id=documentId;
  //   //   print(loc_id);
  //   //
  //   //   print('Document ID: $documentId');
  //   // } else {
  //   //   // Document not found
  //   //   print('Document not found.');
  //   // }
  //
  //   Stream<QuerySnapshot> productRef = FirebaseFirestore.instance
  //       .collection("spots").where('locid', isEqualTo: documentId)
  //       .snapshots();
  //   productRef.forEach((field) {
  //     field.docs.asMap().forEach((index, data) {
  //       ids.add(field.docs[index]["name"]);
  //       print(field.docs[index]["name"]);
  //     });
  //   });
  //   return ids;
  //
  //
  // }

  Future<List<Map<String, dynamic>>> fetchspotDocuments() async {
    List<Map<String, dynamic>> nearbySpotsData = [];
    final collectionRef = FirebaseFirestore.instance.collection('spots');

    try {
      final querySnapshot =
      await collectionRef.where('locid', isEqualTo: widget.locid).get();
       _nearbySpots=querySnapshot.docs ;

      _loadMarkers();
       print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^$_nearbySpots');
      // Iterate over the documents
      for (var doc in querySnapshot.docs) {
        // Access the document data
        final documentData = doc.data();
        print(documentData);
        final fetchedspotname = doc['name'];
        final fetchedspottotal = doc['total'];
        print(fetchedspotname);
        inital=doc['coordinates'] as GeoPoint;
        final fetchedspotspace =doc['spaceCounter'];
        nearbySpotsData.add({
          'name': fetchedspotname,
          'spaceCounter': fetchedspotspace,
          'totalspace':fetchedspottotal,

        });
        // final fieldValue = doc['fieldValue'];
        // final anotherField = doc['anotherField'];
      }
    } catch (e) {
      print('Error fetching documents: $e');
    }
    print('****************************************************$nearbySpotsData');
    return nearbySpotsData;
  }


  @override
  Widget build(BuildContext context) {
    if (_userLocation == null) {
      print('spots from showspot ###################################################################${widget.locid}');
      return Center(child: CircularProgressIndicator()); // Display loading indicator while getting user location
    }
    // else
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>newhome ()));
        }, icon: Icon(FontAwesomeIcons.circleChevronLeft,color: Colors.black54,),),
        title: Text('Nearby Spots'),
        backgroundColor: Colors.white,

      ),
      body:
      Container(
        color: Colors.white,
        child: Column(
          children: [
          Container(
            height: 400,
            child: GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target:  LatLng(inital?.latitude??2,inital?.longitude??2),
                // LatLng(_userLocation?.latitude??2.9, _userLocation?.longitude??2),
                zoom: 14.0,
              ),
              markers: _markers,
            ),
          ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchDataFuture2,
              builder: (context, snapshot) {


                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child:  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              child:
                              new CircularProgressIndicator(

                                color: Colors.blue,
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                top: 40,
                                child: Text(
                                  ' Fetching spots ',
                                  textAlign:
                                  TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading data'));
                } else if (snapshot.hasData) {
                  List<Map<String, dynamic>>? nearbySpotsData = snapshot.data;
                  print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${snapshot.data}');
                  print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${nearbySpotsData}');
                  return Expanded(

                    child: ListView.builder(
                      itemCount: nearbySpotsData?.length,

                      itemBuilder: (context, index) {
                        print(index);
                        final spotData = nearbySpotsData![index];
                        final name = spotData['name'];
                        final spaceCounter = spotData['spaceCounter'] ;
                        final total=spotData['totalspace'] ;
                        //final distance=spotData['distance'];
                       // final spotloc=spotData['spotlocname'];
                        print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$spotData####');

                        return Container(
                          height: 150,
                          padding: const EdgeInsets.all(10),

                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),color: Colors.white70),
                          child: Card(

                            child: Row(
                              children: [
                                Container(
                                  height:100,
                                  width:90,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),image: DecorationImage(
                                    image: AssetImage("assets/  /img_1.png"), fit: BoxFit.cover,),
                                  ),),
                                Container(
                                  width: 246,
                                  padding: EdgeInsets.all(0),
                                  child:  ListTile(

                                      onTap:() async {print('@@@@@@@@@@@@@@@@!!!!!!!!!!!!!!$name');
                                        String? spotid = await fetchspotDocumentId('spots', 'name',name);
                                        print('@@@@@@@@@@@@@@@@!!!!!!!!!!!!!!$spotid');
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => displayspot(spotid:spotid??'',name:name,total:total,available:spaceCounter )));

                                      },
                                      title: Text(name,style: TextStyle(fontSize: 20,color: Colors.black54)),
                                      subtitle: Text('Available Space $spaceCounter \n KM',style: TextStyle(color: Colors.grey)),
                                      trailing: Container(
                                        width: 30, height: 30,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Color(0xff1A1919).withOpacity(0.1)
                                        ),
                                        child: const Icon(FontAwesomeIcons.chevronCircleRight, color:Color(0xffffffff)),

                                      )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                      },

                    ),


                  );
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ),

            // if(spotsnotnear)
            //   Text('Parking Spots available are very far from you')
            // else
            //   Text('Spots available near to you')
          ],
        ),
      ),

    );
  }
}
