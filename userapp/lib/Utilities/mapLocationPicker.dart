import 'dart:async';
import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

import 'package:location/location.dart' as l;
import 'package:map_picker/map_picker.dart';
import 'package:provider/provider.dart';
import 'package:userapp/Utilities/state.dart';

class MapLocationPicker extends StatefulWidget {
  const MapLocationPicker({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapLocationPickerState createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();

  static late CameraPosition _kLake;
  late l.LocationData locationData;

  getUserLocation(double latitude, double longitude) async {

      var addresses = await GeocodingPlatform.instance!.placemarkFromCoordinates(
          latitude, longitude
          );
      var first = addresses.first;
      // log("$addresses");
      if (mounted) {
      log("$first");
      String? locality = first.subAdministrativeArea != "" ? first.subAdministrativeArea : first.subLocality != "" ? first.subLocality : first.locality != "" ? first.locality : first.administrativeArea;
      Provider.of<StateManagement>(context, listen: false).setReportLocationAddress([latitude, longitude], locality!, first.thoroughfare != "" ? first.thoroughfare! : first.name!, first.administrativeArea!);
        Navigator.of(context).pop();
      }
    }

  Future currentLocation() async {
    bool serviceEnabled;
    l.PermissionStatus permissionGranted;

    l.Location location = l.Location();
    log("1");
    serviceEnabled = await location.serviceEnabled();
    log("$serviceEnabled");
    if (!serviceEnabled) {
      log("ENTERED");
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        log("HHEE");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == l.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != l.PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(locationData.latitude!, locationData.longitude!),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
    setState(() {
    });
    log("$locationData");
  }

  var textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentLocation();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          MapPicker(
            iconWidget: Icon(Icons.location_on),
            mapPickerController: mapPickerController,
            child: GoogleMap(
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: _kLake,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onCameraMoveStarted: () {
                mapPickerController.mapMoving!();
                textController.text = "checking ...";
              },
              onCameraMove: (cameraPosition) {
                _kLake = cameraPosition;
              },
              onCameraIdle: () async {
                mapPickerController.mapFinishedMoving!();
                List<Placemark> placemarks = await placemarkFromCoordinates(
                  _kLake.target.latitude,
                  _kLake.target.longitude,
                );
                textController.text =
                '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 20,
            width: MediaQuery.of(context).size.width - 50,
            height: 50,
            child: TextFormField(
              style: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.bold
              ),
              maxLines: 3,
              textAlign: TextAlign.center,
              readOnly: true,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero, border: InputBorder.none),
              controller: textController,
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: SizedBox(
              height: 50,
              child: TextButton(
                onPressed: () {
                  getUserLocation(_kLake.target.latitude, _kLake.target.longitude);
                  log(
                      "Location ${_kLake.target.latitude} ${_kLake.target.longitude}");
                },
                style: ButtonStyle(
                  backgroundColor:
                  WidgetStateProperty.all<Color>(const Color(0xFFA3080C)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    color: Color(0xFFFFFFFF),
                    fontSize: 19,
                    // height: 19/19,
                  ),
                ),
              ),
            ),
          )
        ],
       ),
      );
    }
  }