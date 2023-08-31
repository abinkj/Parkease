import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zxc/Screeens/Dashboard/spotfindloc.dart';
import 'package:zxc/Screeens/profile/profile.dart';
import 'package:zxc/Screeens/Dashboard/spotmapdisplay.dart';
class newhome extends StatefulWidget {
  @override
  _newhomeState createState() => _newhomeState();
}

class _newhomeState extends State<newhome> {
  Position? _userLocation;
 bool chng=false;

  List<String> locations = [];
  String? selectedLocation;
  String currentLocation = 'Loading...';
  String? name;
  String? profileimageurl;
  List<String> _nearbySpotIds = [];
  List<String> spotids = [];
  bool spotnotnear=false;
  late Future<List<Map<String, dynamic>>> _fetchDataFuture = Future.value([]);

  List distances=[];
  List<DocumentSnapshot> _nearbySpots = [];
  @override
  void initState() {
    super.initState();
    _getUserLocation().then((position) {
      setState(() {
        _userLocation = position;
      });
      _getNearbySpots(position, 2.0).then((spots) {
        setState(() {
          _nearbySpots = spots;

        });
        _fetchDataFuture = fetchDocuments(_nearbySpotIds);
      }).catchError((error) {
        print('Error: $error');
        // Handle the error
      });
    }).catchError((error) {
      print('Error: $error');
      // Handle the error
    });
    getCurrentLocation();
    fetchdata();
    fetchlocs();


  }

  void getCurrentLocation() async {
    try {
      Position position = await _getUserLocation();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      Placemark placemark = placemarks.first;
      setState(() {
        currentLocation = '${placemark.locality}, ${placemark.administrativeArea},${placemark.isoCountryCode}';
      });
      print(currentLocation);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchlocs() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    print('the after fecthlocs location is **************************************$selectedLocation');
    if (firebaseUser != null) {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('locations')
          .get();


      Stream<QuerySnapshot> productRef = FirebaseFirestore.instance
          .collection("locations")
          .snapshots();
      productRef.forEach((field) {
        field.docs.asMap().forEach((index, data) {
          locations.add(field.docs[index]["name"]);
          print(field.docs[index]["name"]);
        });
      });


    }


  }

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

    return await Geolocator.getCurrentPosition();
  }

  Future<List<DocumentSnapshot>> _getNearbySpots(Position userLocation, double radiusInKm) async {
    final CollectionReference spotsRef = FirebaseFirestore.instance.collection('spots');

    final GeoPoint center = GeoPoint(userLocation.latitude, userLocation.longitude);

    final double radius = radiusInKm * 1000; // Convert radius from km to meters

    QuerySnapshot querySnapshot = await spotsRef
        .where('coordinates', isGreaterThan: GeoPoint(center.latitude - (radius / 111319), center.longitude - (radius / (111319 * cos(center.latitude)))))
        .where('coordinates', isLessThan: GeoPoint(center.latitude + (radius / 111319), center.longitude + (radius / (111319 * cos(center.latitude)))))
        .get();
    if (querySnapshot == null || querySnapshot.docs.isEmpty) {
     spotnotnear=true;
      querySnapshot = await spotsRef
          .orderBy('coordinates', descending: false)
          .limit(1)
          .get();
    }

    final List<String> nearbySpotIds = querySnapshot.docs.map((spot) => spot.id).toList();
    print('###############%%^^&*))(*^%#!!###############$nearbySpotIds');
    print(querySnapshot.docs);
    _nearbySpotIds = nearbySpotIds ;
    print(nearbySpotIds);

    final List<DocumentSnapshot> nearbySpots = querySnapshot.docs;
    distances=[];
    for (DocumentSnapshot spot in nearbySpots) {
      final spotCoordinates = spot['coordinates'] as GeoPoint;
      final double distance = calculateDistance(
        userLocation.latitude,
        userLocation.longitude,
        spotCoordinates.latitude,
        spotCoordinates.longitude,
      );
      final roundedDistance = distance.toStringAsFixed(2);
      print('Distance to ${spot['name']}: $distance meters');
      // distances.add(
      //     {
      //       'spotid':spot.id,
      //       'distance': roundedDistance
      //     }
      // );
      final spotlocname= await getLocationNameFromGeoPoint(spotCoordinates);
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!$spotlocname');
      distances.add(
          {
            'spotid':spot.id,
            'distance': roundedDistance,
            'spotloc':spotlocname
          }
      );

    }


    return querySnapshot.docs;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    double p = 0.017453292519943295;
    double a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

   getLocationNameFromGeoPoint(GeoPoint geoPoint) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        geoPoint.latitude,
        geoPoint.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String locationName = '${placemark.locality}, ${placemark.country}';
        print('###################################################################$locationName');
        return locationName;
      }
    } catch (e) {
      print('Error fetching location name: $e');
    }

    return '';
  }


  Future<List<Map<String, dynamic>>> fetchDocuments(List<String> documentIds) async {

    List<Map<String, dynamic>> nearbySpotsData = [];
    final firebaseUser = FirebaseAuth.instance.currentUser;
    //final ref = FirebaseDatabase.instance.ref();
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$documentIds!!!!!!!!!!!!!!!!!!!!!!!');
    for (String documentId in documentIds) {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('spots')
          .doc(documentId)
          .get();
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        final fetchedspotname = data?['name'];
        final fetchedspottotal = data?['total'];
        final fetchedspotspace = data?['spaceCounter'];

        distances.forEach((item) {
          if(item['spotid']==documentId) {
            nearbySpotsData.add({
              'name': fetchedspotname,
              'spaceCounter': fetchedspotspace,
              'totalspace':fetchedspottotal,
              'distance':item['distance'],
              'spotlocname':item['spotloc'],
              'spotid':item['spotid']

            });
          }
        });
      } else {
        print('Document does not exist');
      }

    }
    return nearbySpotsData;
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
        final fetchedprofimageurl=data?['profileImageUrl'];
        if (mounted) {
          setState(() {
            name = fetchedname;
            profileimageurl=fetchedprofimageurl;

          });
        }
        print(profileimageurl);
        print(name);
      } else {
        print('Document does not exist');
      }

    }
  }

  Future<String?>   fetchDocumentId(String collectionPath, String fieldName, dynamic searchValue) async {
    if (searchValue == null) {
      return null; // Return null if search value is null
    }

    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(collectionPath)
        .where(fieldName, isEqualTo: searchValue)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final DocumentSnapshot document = snapshot.docs.first;
      print(document.id);
      return document.id;
    }

    return null; // Document with the given field value not found
  }


  @override
  Widget build(BuildContext context) {
    return
       Scaffold(
         resizeToAvoidBottomInset: false,
         backgroundColor: Colors.white,
        appBar: AppBar(
            automaticallyImplyLeading: false,
          bottomOpacity: 0.0,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Column(
            children: [
              Row(
                children: [
                  Icon(FontAwesomeIcons.locationDot,color: Colors.red,),
                  SizedBox(width: 10),
                  Text('Location',style: TextStyle(color: Colors.grey),),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 5,),
              Row(
                children: [
                  const SizedBox(width: 33),
                  Text(currentLocation,style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black87),),
                ],
              )
            ],
          ),
          actions:[ IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            icon: Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                width: 100,
                height: 70,
                child:ClipRRect(

                  borderRadius: BorderRadius.circular(90),
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
                ),),
            ),
          ),]
        ),
        body:Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(height: 40,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration( image: DecorationImage(
                              image: AssetImage("assets/images/parkbody1.jpg"), fit: BoxFit.cover,)),
                          child:
                          Column(

                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Hello, $name               ',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Find  Your        \nParking  Space          ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 35,
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
                  )
                ],
              ),
              SizedBox(height: 5,),
              Container(
                  padding: const EdgeInsets.all(5),

                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white10),
                  child: ListTile(
                      onTap: (){    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: DropdownButton<String>(
                              value: selectedLocation,
                              onChanged: (String? newValue) async {
                                setState(() {
                                  selectedLocation = newValue;
                                  //fetchDocumentId('locations', 'name', selectedLocation);

                                   //  print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&$locid');
                                 // _fetchDataFuture = fetchDocuments(_nearbySpotIds);

                                });

                                String? locid = await fetchDocumentId('locations', 'name', selectedLocation);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NearbySpotsScreen (locid:locid??'' )));

                              },
                              items: locations.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      );

                      },
                      // leading: Container(
                      //   width: 30, height: 30,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(100),
                      //       color: Color(0xffDDCA1C).withOpacity(0.1)
                      //   ),
                      //   child: Icon(FontAwesomeIcons.locationDot, color:Colors.red),
                      // ),
                      title: Text(

                          selectedLocation??'Choose another Location',style: TextStyle(fontSize: 20,color: Colors.grey)),
                      trailing:Icon(FontAwesomeIcons.circleChevronDown, color:Colors.grey),


                  ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                height: 50,

                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white10),


                  child: ListTile(
                    title: Text(
                        'Nearby Spots',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold)),
                  ),),


              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchDataFuture,
                builder: (context, snapshot) {

                  if(spotnotnear){
                    return Column(
                      children: [
                        SizedBox(height: 50,),
                        Center(child: Text('No parking spots are available near You')),
                      ],
                    );
                  }
                  else if (snapshot.connectionState == ConnectionState.waiting) {
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
                                   ' Fetching spots near you',
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
                          final distance=spotData['distance'];
                          final spotloc=spotData['spotlocname'];
                          final spotid=spotData['spotid'];
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
                                      image: AssetImage("assets/images/img_1.png"), fit: BoxFit.cover,),
                                  ),),
                                 Container(
                                   width: 246,
                                   padding: EdgeInsets.all(0),
                                   child:  ListTile(

                                         onTap:() async {print('@@@@@@@@@@@@@@@@!!!!!!!!!!!!!!$name $spotid');
                                         Navigator.of(context).push(MaterialPageRoute(
                                             builder: (context) => LocationPage (spotid:spotid, distance:distance,)));
                                         // String? spotid = await fetchspotDocumentId('spots', 'name',name);
                                         // print('@@@@@@@@@@@@@@@@!!!!!!!!!!!!!!$spotid');
                                         // Navigator.of(context).push(MaterialPageRoute(builder: (context) => displayspot(spotid:spotid??'',name:name,total:total,available:spaceCounter )));

                                         },
                                         title: Text(name,style: TextStyle(fontSize: 20,color: Colors.black54)),
                                         subtitle: Text('$spotloc \nAvailable Space $spaceCounter \n$distance KM',style: TextStyle(color: Colors.grey)),
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

            ],
          ),
        )


    );
  }
}


