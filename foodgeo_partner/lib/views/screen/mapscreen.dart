// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as loc;
// import 'package:geocoding/geocoding.dart' as geo;
// import 'package:geolocator/geolocator.dart';
//
// class MapScreenPage extends StatefulWidget {
//   const MapScreenPage({Key? key}) : super(key: key);
//
//   @override
//   _MapScreenPageState createState() => _MapScreenPageState();
// }
//
// class _MapScreenPageState extends State<MapScreenPage> {
//   final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
//   bool _isDropdownExpanded = false;
//   bool _isSearching = false;
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(25.971588, 84.924759),
//     zoom: 14.4746,
//   );
//
//   final Set<Marker> _markers = {};
//   final Set<Polyline> _polyline = {};
//   loc.LocationData? _currentLocation;
//   TextEditingController _searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeMarkersAndPolyline();
//     _getCurrentLocation();
//   }
//
//   void _initializeMarkersAndPolyline() {
//     // Initialize markers and polyline if needed
//   }
//
//   Future<void> _getCurrentLocation() async {
//     loc.Location location = loc.Location();
//     try {
//       bool _serviceEnabled = await location.serviceEnabled();
//       if (!_serviceEnabled) {
//         _serviceEnabled = await location.requestService();
//         if (!_serviceEnabled) return;
//       }
//
//       loc.PermissionStatus _permissionGranted = await location.hasPermission();
//       if (_permissionGranted == loc.PermissionStatus.denied) {
//         _permissionGranted = await location.requestPermission();
//         if (_permissionGranted != loc.PermissionStatus.granted) return;
//       }
//
//       _currentLocation = await location.getLocation();
//
//       if (_currentLocation != null) {
//         final GoogleMapController controller = await _controller.future;
//         final LatLng currentLatLng = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
//
//         controller.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng, 14.0));
//
//         _markers.add(
//           Marker(
//             markerId: MarkerId('currentLocation'),
//             position: currentLatLng,
//             infoWindow: InfoWindow(
//               title: 'Your Location',
//             ),
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//           ),
//         );
//
//         setState(() {});
//       }
//     } catch (e) {
//       print('Error getting location: $e');
//     }
//   }
//
//   Future<void> _searchLocation(String query) async {
//     setState(() {
//       _isSearching = true;
//     });
//
//     final GoogleMapController controller = await _controller.future;
//     try {
//       List<geo.Location> locations = await geo.locationFromAddress(query);
//       if (locations.isNotEmpty) {
//         final LatLng cityLocation = LatLng(locations.first.latitude, locations.first.longitude);
//         await controller.animateCamera(CameraUpdate.newLatLngZoom(cityLocation, 12.0));
//
//         _markers.add(
//           Marker(
//             markerId: MarkerId('cityLocation'),
//             position: cityLocation,
//             infoWindow: InfoWindow(
//               title: query,
//             ),
//           ),
//         );
//
//         if (_currentLocation != null) {
//           double distanceInKm = Geolocator.distanceBetween(
//             _currentLocation!.latitude!,
//             _currentLocation!.longitude!,
//             cityLocation.latitude,
//             cityLocation.longitude,
//           ) / 1000;
//
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Distance: ${distanceInKm.toStringAsFixed(2)} km')),
//           );
//         }
//         setState(() {});
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Location not found')),
//         );
//       }
//     } catch (e) {
//       print('Error searching location: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: Unable to find the location')),
//       );
//     } finally {
//       setState(() {
//         _isSearching = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: 50),
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _isDropdownExpanded = !_isDropdownExpanded;
//                   });
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.orange, width: 2.0),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   padding: EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Select outlet’s location on the map',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       Icon(
//                         _isDropdownExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               AnimatedContainer(
//                 duration: Duration(milliseconds: 300),
//                 height: _isDropdownExpanded ? MediaQuery.of(context).size.height * 0.6 : 0,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: TextField(
//                           controller: _searchController,
//                           decoration: InputDecoration(
//                             hintText: 'Enter your restaurant’s location',
//                             prefixIcon: Icon(Icons.search, color: Colors.grey),
//                             suffixIcon: IconButton(
//                               icon: Icon(Icons.my_location, color: Colors.grey),
//                               onPressed: () {
//                                 _getCurrentLocation();
//                               },
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8.0), // Rounded corners
//                               borderSide: BorderSide.none,
//                             ),
//                             filled: true,
//                             fillColor: Colors.grey.shade200, // Light grey background color
//                             contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
//                           ),
//                           onSubmitted: (query) {
//                             _searchLocation(query);
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                         height: 300,
//                         child: GoogleMap(
//                           mapType: MapType.normal,
//                           initialCameraPosition: _kGooglePlex,
//                           markers: _markers,
//                           polylines: _polyline,
//                           myLocationEnabled: true,
//                           myLocationButtonEnabled: false,
//                           onMapCreated: (GoogleMapController controller) {
//                             _controller.complete(controller);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController seconddesnationController =
  TextEditingController();
  List<Prediction> _suggestions = [];
  Timer? _debounce;
  LatLng? _pickupLatLng;
  GoogleMapController? _mapController;
  Marker? _selectedLocationMarker;
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('FoodGaoMaps'),

      ),

      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickupLatLng ??
                  LatLng(00,00),
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: _selectedLocationMarker != null
                ? {_selectedLocationMarker!}
                : {},
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: buildSearchField(seconddesnationController,
                'Enter Pickup location', _onSearchTextChanged),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Expanded(child: _addressItemView(_suggestions, context)),
          ),
        ],
      ),
    );
  }
  Widget buildSearchField(TextEditingController controller, String hintText,
      Function(String) onChanged) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Color(0xffF0F1F3),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.location_on, color: Colors.grey[700]),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.clear();
                      setState(() {
                        _suggestions.clear();
                      });
                    },
                    icon: Icon(Icons.close),
                  ),
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey[700], fontSize: 18),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressItemView(List<Prediction> prediction, BuildContext context) {
    return prediction.isNotEmpty
        ? ListView.builder(
      shrinkWrap: true,
      itemCount: prediction.length,
      itemBuilder: (context, index) {
        var address = prediction[index].description ?? 'Unknown address';
        return InkWell(
          onTap: () async {
            var location = await getLatLngFromAddress(address);
            if (location.latitude != 0.0 && location.longitude != 0.0) {
              setState(() {
                _selectedLocationMarker = Marker(
                  markerId: MarkerId('selected-location'),
                  position: LatLng(location.latitude, location.longitude),
                  infoWindow: InfoWindow(title: address),
                );
                _mapController?.animateCamera(
                  CameraUpdate.newLatLng(
                      LatLng(location.latitude, location.longitude)),
                );
                seconddesnationController.text = address;
                _suggestions.clear();
              });
              // directionController.pickup.value = address;
            }
          },
          child: ListTile(
            title: Text(address),
            trailing: Icon(Icons.favorite_border),
          ),
        );
      },
    )
        : Center(child: Text(''));
  }

  void _onSearchTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (text.isNotEmpty) {
        _fetchSuggestions(text);
      }
    });
  }

  void _fetchSuggestions(String input) async {
    final places =
    GoogleMapsPlaces(apiKey: 'AIzaSyCiJLymeCL0CTqTmcmPJ5T0lkLwA02OxWg');
    PlacesAutocompleteResponse response = await places.autocomplete(input);
    if (response.isOkay) {
      setState(() {
        _suggestions = response.predictions!;
      });
    } else {
      print('Error fetching suggestions: ${response.errorMessage}');
    }
  }

  Future<geocoding.Location> getLatLngFromAddress(String address) async {
    var location = await geocoding.locationFromAddress(address);
    return location.first;
  }

  Future<String> getAddressFromLatLong(
      {required double latitude, required double longitude}) async {
    List<geocoding.Placemark> placeMarks =
    await geocoding.placemarkFromCoordinates(latitude, longitude);
    geocoding.Placemark place = placeMarks[0];
    var address =
        '${place.locality}, ${place.administrativeArea}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.street}, ${place.name}, ${place.thoroughfare}, ${place.postalCode}';
    return address;
  }
}