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
  Future<BitmapDescriptor> _icon;

  @override
  void initState() {
    super.initState();

    _icon = BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/images/marker.png');

    // When the _icon and the _controller are resolved... then update the markers
    Future.wait([_icon, _controller.future]).then((values) {
      // Unused, but we can use them for whatever we need...
      // (These are returned in the same order as the futures to `wait`)
      BitmapDescriptor icon = values[0];
      GoogleMapController controller = values[1];

      _onMapAndBitmapInitialized();
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
  }

  // This will run when both _icon and _controller have resolved...
  // (It can be made sync by passing the icon from the call, so we don't have to
  // await _icon inside)
  void _onMapAndBitmapInitialized() async {
    final icon = await _icon;
    setState(() {
      for (LatLng coords in someCoords) {
        _markers.add(_createMarker(context, coords, icon));
      }
    });
  }

  Marker _createMarker(BuildContext context, LatLng coords, BitmapDescriptor icon) {
    return Marker(
      markerId: MarkerId(coords.toString()),
      position: coords,
      infoWindow: InfoWindow(
        title: coords.toString(),
        snippet: coords.toString(),
      ),
      icon: icon,
    );
  }
}
