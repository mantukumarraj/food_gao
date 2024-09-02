import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodgeo_partner/views/screen/home_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;

import '../../controller/restaurant_registration_controller.dart';
import '../widget/costum_textfeld.dart';
import 'package:flutter/services.dart';

class RestaurantRegistrationPage extends StatefulWidget {
  @override
  _RestaurantRegistrationPageState createState() => _RestaurantRegistrationPageState();
}

class _RestaurantRegistrationPageState extends State<RestaurantRegistrationPage> {
  final RegisterControllers _controller = RegisterControllers();
  final Completer<GoogleMapController> _mapcontroller = Completer<GoogleMapController>();


  File? _selectedImage;
  bool _isLoading = false;
  String? _selectedCategory;
  String? _selectedGender;
  final _formKey = GlobalKey<FormState>();
  bool _isDropdownExpanded = false;
  bool _isSearching = false;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.971588, 84.924759),
    zoom: 14.4746,
  );

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  loc.LocationData? _currentLocation;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeMarkersAndPolyline();
    _getCurrentLocation();
    _selectedCategory = _controller.category;
  }

  void _initializeMarkersAndPolyline() {
    // Initialize markers and polyline if needed
  }

  Future<void> _getCurrentLocation() async {
    loc.Location location = loc.Location();
    try {
      bool _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) return;
      }

      loc.PermissionStatus _permissionGranted = await location.hasPermission();
      if (_permissionGranted == loc.PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != loc.PermissionStatus.granted) return;
      }

      _currentLocation = await location.getLocation();

      if (_currentLocation != null) {
        final GoogleMapController controller = await _mapcontroller.future;
        final LatLng currentLatLng = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);

        controller.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng, 14.0));

        _markers.add(
          Marker(
            markerId: MarkerId('currentLocation'),
            position: currentLatLng,
            infoWindow: InfoWindow(
              title: 'Your Location',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );

        setState(() {});
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  // Future<void> _searchLocation(String query) async {
  //   setState(() {
  //     _isSearching = true;
  //   });
  //
  //   final GoogleMapController controller = await _mapcontroller.future;
  //   try {
  //     // Use geocoding package to get the location from address
  //     List<geo.Location> locations = await geo.locationFromAddress(query);
  //
  //     if (locations.isNotEmpty) {
  //       final LatLng cityLocation = LatLng(locations.first.latitude, locations.first.longitude);
  //
  //       // Get the latitude and longitude of the searched location
  //       double latitude = locations.first.latitude;  // Latitude
  //       double longitude = locations.first.longitude;  // Longitude
  //       _controller.locationlongitudeController.text = longitude as String;
  //
  //       // Fetch the address from the coordinates using reverse geocoding
  //       List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(latitude, longitude);
  //
  //       String address = "";
  //       if (placemarks.isNotEmpty) {
  //         geo.Placemark place = placemarks.first;
  //         address = "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
  //         print('Searched Location Address: $address');
  //         _controller.locationController.text =address;
  //
  //         // Store the address in locationController
  //         // <-- Store the address here
  //       }
  //
  //       // Move the camera to the searched location
  //       await controller.animateCamera(CameraUpdate.newLatLngZoom(cityLocation, 12.0));
  //
  //       _markers.add(
  //         Marker(
  //           markerId: MarkerId('cityLocation'),
  //           position: cityLocation,
  //           infoWindow: InfoWindow(
  //             title: query,
  //             snippet: address, // Show address in snippet
  //           ),
  //         ),
  //       );
  //
  //       // Calculate distance if current location is available
  //       if (_currentLocation != null) {
  //         double distanceInKm = Geolocator.distanceBetween(
  //           _currentLocation!.latitude!,
  //           _currentLocation!.longitude!,
  //           cityLocation.latitude,
  //           cityLocation.longitude,
  //         ) / 1000;
  //
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Distance: ${distanceInKm.toStringAsFixed(2)} km')),
  //         );
  //       }
  //       setState(() {});
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Location not found')),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error searching location: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: Unable to find the location')),
  //     );
  //   } finally {
  //     setState(() {
  //       _isSearching = false;
  //     });
  //   }
  // }
  // Future<void> _searchLocation(String query) async {
  //   setState(() {
  //     _isSearching = true;
  //   });
  //
  //   final GoogleMapController controller = await _mapcontroller.future;
  //   try {
  //     List<geo.Location> locations = await geo.locationFromAddress(query);
  //     if (locations.isNotEmpty) {
  //       final LatLng cityLocation = LatLng(locations.first.latitude, locations.first.longitude);
  //       await controller.animateCamera(CameraUpdate.newLatLngZoom(cityLocation, 12.0));
  //
  //       _markers.add(
  //         Marker(
  //           markerId: MarkerId('cityLocation'),
  //           position: cityLocation,
  //           infoWindow: InfoWindow(
  //             title: query,
  //           ),
  //         ),
  //       );
  //
  //       if (_currentLocation != null) {
  //         double distanceInKm = Geolocator.distanceBetween(
  //           _currentLocation!.latitude!,
  //           _currentLocation!.longitude!,
  //           cityLocation.latitude,
  //           cityLocation.longitude,
  //         ) / 1000;
  //
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Distance: ${distanceInKm.toStringAsFixed(2)} km')),
  //         );
  //       }
  //       setState(() {});
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Location not found')),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error searching location: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: Unable to find the location')),
  //     );
  //   } finally {
  //     setState(() {
  //       _isSearching = false;
  //     });
  //   }
  // }

  Future<void> _searchLocation(String query) async {
    setState(() {
      _isSearching = true;
    });

    final GoogleMapController controller = await _mapcontroller.future;
    try {
      List<geo.Location> locations = await geo.locationFromAddress(query);
      if (locations.isNotEmpty) {
        final LatLng cityLocation = LatLng(locations.first.latitude, locations.first.longitude);
        await controller.animateCamera(CameraUpdate.newLatLngZoom(cityLocation, 12.0));

        // Store the longitude in locationLongitudeController
        _controller.locationlongitudeController.text = cityLocation.longitude.toString();

        // Reverse geocoding to get the address before marker click
        List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
          cityLocation.latitude,
          cityLocation.longitude,
        );

        String address = "";
        if (placemarks.isNotEmpty) {
          geo.Placemark place = placemarks.first;
          address = "${place.name}, ${place.locality},${place.administrativeArea}, ${place.country}";

          // Store the address in locationController
          _controller.locationController.text = address;
        }

        _markers.add(
          Marker(
            markerId: MarkerId('cityLocation'),
            position: cityLocation,
            infoWindow: InfoWindow(
              title: query,
            ),
            onTap: () async {
              // Show a SnackBar with the address when marker is tapped
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Address: $address')),
              );
            },
          ),
        );

        if (_currentLocation != null) {
          double distanceInKm = Geolocator.distanceBetween(
            _currentLocation!.latitude!,
            _currentLocation!.longitude!,
            cityLocation.latitude,
            cityLocation.longitude,
          ) / 1000;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Distance: ${distanceInKm.toStringAsFixed(2)} km')),
          );
        }
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location not found')),
        );
      }
    } catch (e) {
      print('Error searching location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Unable to find the location')),
      );
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  final List<String> _categories = [
    'Fast Food',
    'Casual Dining',
    'Fine Dining',
    'Cafe',
    'Buffet',
    'Food Truck',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "Restaurant Registration",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text('Choose from gallery'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImageFromGallery();
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.photo_camera),
                                title: Text('Take a picture'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImageFromCamera();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                      image: _selectedImage != null
                          ? DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _selectedImage == null
                        ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Restaurant Name',
                  icon: Icons.restaurant,
                  controller: _controller.nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the restaurant name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Address',
                  icon: Icons.home,
                  controller: _controller.addressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Owner Name',
                  icon: Icons.person,
                  controller: _controller.ownerNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the owner name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Phone Number',
                  icon: Icons.phone,
                  controller: _controller.phonenoController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gender",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: const Text('Male'),
                            leading: Radio<String>(
                              value: 'Male',
                              groupValue: _selectedGender,

                              onChanged: (String? value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('Female'),
                            leading: Radio<String>(
                              value: 'Female',
                              groupValue: _selectedGender,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isDropdownExpanded = !_isDropdownExpanded;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select outlet’s location on the map',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          _isDropdownExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 7,),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: _isDropdownExpanded ? MediaQuery.of(context).size.height * 0.5 : 0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Enter your restaurant’s location',
                              prefixIcon: Icon(Icons.search, color: Colors.grey),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.my_location, color: Colors.grey),
                                onPressed: () {
                                  _getCurrentLocation();
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0), // Rounded corners
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade200, // Light grey background color
                              contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                            ),
                            onSubmitted: (query) {
                              _searchLocation(query);
                            },
                          ),
                        ),
                        SizedBox(height: 5,),
                        SizedBox(
                          height: 300,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: _kGooglePlex,
                            markers: _markers,
                            polylines: _polyline,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            onMapCreated: (GoogleMapController controller) {
                              _mapcontroller.complete(controller);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Select Restaurant Category",
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  value: _categories.contains(_selectedCategory)
                      ? _selectedCategory
                      : null,
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,

                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                      _controller.category = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 45,
                      child: MaterialButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Please select an image."),
                                ),
                              );
                              return;
                            }
                            await _registerRestaurant();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please fill all fields."),
                              ),
                            );
                          }
                        },
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'Restaurant Register ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (_isLoading)
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }

  Future<void> _registerRestaurant() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Call the registration method
      await _controller.registerUser(_selectedGender!, _selectedImage!);

      // Show success message and navigate to HomePage
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Restaurant uploaded successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to HomePage
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
      });

    } catch (e) {
      // Handle registration error (e.g., show error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to upload restaurant: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}