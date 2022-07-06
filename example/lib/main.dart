// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_map_pin_picker/flutter_map_pin_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Completer<GoogleMapController> _controller = Completer();
  MapPickerController mapPickerController = MapPickerController();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(31.2060916, 29.9187),
    zoom: 14.4746,
  );

  Address? address;

  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MapPicker(
              // pass icon widget
              iconWidget: const Icon(
                Icons.location_pin,
                size: 50,
              ),
              //add map picker controller
              mapPickerController: mapPickerController,
              child: GoogleMap(
                zoomControlsEnabled: false,
                // hide location button
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                //  camera position
                initialCameraPosition: cameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onCameraMoveStarted: () {
                  // notify map is moving
                  mapPickerController.mapMoving ?? () {}();
                },
                onCameraMove: (cameraPosition) {
                  this.cameraPosition = cameraPosition;
                },
                onCameraIdle: () async {
                  // notify map stopped moving
                  mapPickerController.mapFinishedMoving ?? () {}();
                  //get address name from camera position
                  List<Address> addresses = await Geocoder.local
                      .findAddressesFromCoordinates(Coordinates(
                          cameraPosition.target.latitude,
                          cameraPosition.target.longitude));
                  // update the ui with the address
                  textController.text = addresses.first.addressLine ?? '';
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          color: Colors.blue,
          child: TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero, border: InputBorder.none),
            controller: textController,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          // icon: Icon(Icons.directions_boat),
        ),
      ),
    );
  }
}
