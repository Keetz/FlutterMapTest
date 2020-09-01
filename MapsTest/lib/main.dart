import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final List<LatLng> someCoords = [
    LatLng(55.6761, 12.5683),
    LatLng(55.6761, 12.5783),
    LatLng(55.6761, 12.5883),
  ];

  final Set<Marker> _markers = <Marker>{};
  BitmapDescriptor _icon;

  @override
  void initState() {
    super.initState();

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'assets/images/marker.png')
        .then((BitmapDescriptor onValue) {
      _icon = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      markers: _markers,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(55.6761, 12.5683),
        zoom: 12,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);

    setState(() {
      for (LatLng coords in someCoords) {
        _markers.add(_createMarker(context, coords));
      }
    });
  }

  Marker _createMarker(BuildContext context, LatLng coords) {
    return Marker(
      markerId: MarkerId(coords.toString()),
      position: coords,
      infoWindow: InfoWindow(
        title: coords.toString(),
        snippet: coords.toString(),
      ),
      icon: _icon, // ERROR
    );
  }
}
