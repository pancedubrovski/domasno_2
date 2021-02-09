import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';


class MapClass extends StatefulWidget {
  @override
  MapClassState createState() => MapClassState();


// TODO: implement createState


}

class MapClassState extends State<MapClass> {



  MapController mapController = new MapController();
  Marker m ;
 // new LatLng(51.64,-0.09),

  // static final CameraPosition _cameraPosition = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);
   @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
    floatingActionButton:  new Align(alignment: Alignment.bottomLeft,
      child: ButtonBar(
          children: <Widget>[ new FloatingActionButton(
            onPressed: getLocation,
            backgroundColor: Colors.black,
            child: Icon(
              Icons.location_searching,
              size: 30,
              color: Colors.white,
            ),
          ),
          ]

      ),
    ),

    body: FlutterMap(
    options: new MapOptions(
    center: new LatLng(51.64,-0.09),
    zoom: 13.0,
    controller: mapController,

    ),
    layers: [
    new TileLayerOptions(
    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    subdomains: ['a', 'b', 'c']
    ),

    new MarkerLayerOptions(
    markers: [



    ],
    ),
    ],
    ),

    );
  }
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionStatus;
  LocationData _locationData;
  getLocation () async {
    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData.latitude);
    // = LatLng(_locationData.latitude,_locationData.longitude);
    m = new Marker(width: 50.0,height: 50.0,point:  LatLng(_locationData.latitude,_locationData.longitude));
    //  mapController.position.
    // mapController.move(new LatLng(_locationData.latitude, _locationData.longitude), 13.0);
  }

}
