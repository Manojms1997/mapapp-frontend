import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'data_model.dart';
import 'http_helper.dart';

enum EmergencyServices { hospital, police, fire }

class EmergencyLocations extends StatefulWidget {
  const EmergencyLocations({Key? key}) : super(key: key);

  @override
  _EmergencyLocationsState createState() => _EmergencyLocationsState();
}

class _EmergencyLocationsState extends State<EmergencyLocations> {
  EmergencyServices emergencyServicesView = EmergencyServices.hospital;
  final Set<Marker> _markers = Set<Marker>();
  GoogleMapController? _mapController;
  late Position userPosition;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _movecameraLocation();
    _addMarker(emergencyServicesView);
  }

  void _movecameraLocation() async {
    userPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _mapController!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(userPosition.latitude, userPosition.longitude),
        zoom: 12.0,
      ),
    ));

    setState(() {});
  }

  Future<void> _addMarker(EmergencyServices newSelection) async {
    // print(describeEnum(newSelection.elementAt(0)));
    List<DataModel> emergencyServicesLocations = await getEmergencyLocations(userPosition.latitude, userPosition.longitude, describeEnum(newSelection).toString());
    print(emergencyServicesLocations.length);
    _markers.clear();
    for (int i = 0; i < emergencyServicesLocations.length; i++) {
      DataModel emergencyServicesLocation = emergencyServicesLocations[i];
      LatLng location = LatLng(emergencyServicesLocation.latitude!,emergencyServicesLocation.longitude!);
      MarkerId markerId = MarkerId('marker_$i');
      Marker marker = Marker(
        markerId: markerId,
        position: location,
        infoWindow: InfoWindow(title: emergencyServicesLocation.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
      _markers.add(marker);
    }
    setState(() {});
  }

  void onSelectionChange(Set<EmergencyServices> newSelection) {
    // get location data and set the markers:
    // getAllLocations();
    // getEmergencyLocations(33.41676332270433, -111.92354496076686, 'hospital');
    setState(() {
      emergencyServicesView = newSelection.first;
    });
    _addMarker(newSelection.elementAt(0));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SegmentedButton<EmergencyServices>(
              segments: const <ButtonSegment<EmergencyServices>>[
                ButtonSegment<EmergencyServices>(
                    value: EmergencyServices.hospital,
                    label: Text('Hospitals'),
                    icon: Icon(Icons.medical_information)),
                ButtonSegment<EmergencyServices>(
                    value: EmergencyServices.police,
                    label: Text('Police Station'),
                    icon: Icon(Icons.local_police_outlined)),
                ButtonSegment<EmergencyServices>(
                    value: EmergencyServices.fire,
                    label: Text('Fire Station'),
                    icon: Icon(Icons.local_fire_department)),
              ],
              selected: <EmergencyServices>{emergencyServicesView},
              onSelectionChanged: onSelectionChange,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 500,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(0.0, 0.0),
                  zoom: 14.0,
                ),
                markers: _markers,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
