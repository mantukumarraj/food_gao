import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart' as loc;


class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationState();
}

class _LocationState extends State<LocationPage> {
  GoogleMapController? _controller;
  loc.LocationData? _currentLocation;
  loc.Location _locationService = loc.Location();
  TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _getLocation() async {
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationService.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationService.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationService.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await _locationService.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await _locationService.getLocation();
    _locationService.onLocationChanged.listen((loc.LocationData locationData) async {
      setState(() {
        _currentLocation = locationData;
      });

      if (_currentLocation != null) {
        List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
            _currentLocation!.latitude!, _currentLocation!.longitude!);
        geo.Placemark place = placemarks[0];
        setState(() {
          _locationController.text =
          "${place.locality}, ${place.administrativeArea}, ${place.country}";
        });
      }

      if (_controller != null) {
        _controller!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
            zoom: 14.0,
          ),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Location'),
        ),
        body: SafeArea(
            child: _currentLocation == null
                ? Center(child: CircularProgressIndicator())
                : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                    zoom: 14.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: TextField(
                    controller: _locationController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Current Location',
                    ),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  bottom: 20,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_controller != null && _currentLocation != null) {
                        _controller!.animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                            zoom: 14.0,
                          ),
                        ));
                      }
                    },
                    child: Text('Map'),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  bottom: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, _locationController.text);
                    },
                    child: Text('Select Location'),
                  ),
                ),
              ],
            ),
            ),
        );
    }
}