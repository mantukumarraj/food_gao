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
  _RestaurantRegistrationPageState createState() =>
      _RestaurantRegistrationPageState();
}

class _RestaurantRegistrationPageState
    extends State<RestaurantRegistrationPage> {
  final RegisterControllers _controller = RegisterControllers();
  final Completer<GoogleMapController> _mapcontroller =
  Completer<GoogleMapController>();

  File? _selectedImage;
  bool _isLoading = false;
  String? _selectedCategory;
  String? _selectedGender;
  final _formKey = GlobalKey<FormState>();
  bool _isDropdownExpanded = false;
  bool _isSearching = false;
  bool _isLocationSelected = false;
  String _selectedAddress = '';
  bool _isLocationValid = true;
  bool _isImageValid = true;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.971588, 84.924759),
    zoom: 14.4746,
  );

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  loc.LocationData? _currentLocation;
  TextEditingController _searchController = TextEditingController();

  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ).copyWith(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.orange), // Ensures consistent color
  );

// Define the common loading indicator
  final Widget loadingIndicator = const CircularProgressIndicator(
    color: Colors.white,
  );

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

        // Update _controller with current location
        _controller.locationlongitudeController.text = currentLatLng.longitude.toString();
        _controller.locationlatitudeController.text = currentLatLng.latitude.toString();

        setState(() {});
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

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

        // Update _controller with searched location
        _controller.locationlongitudeController.text = cityLocation.longitude.toString();
        _controller.locationlatitudeController.text = cityLocation.latitude.toString();
        List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
          cityLocation.latitude,
          cityLocation.longitude,
        );

        String address = "";
        if (placemarks.isNotEmpty) {
          geo.Placemark place = placemarks.first;
          address = "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
          _controller.locationController.text = address;
          setState(() {
            _isLocationSelected = true;
            _selectedAddress = address;
          });
        }

        _markers.add(
          Marker(
            markerId: MarkerId('cityLocation'),
            position: cityLocation,
            infoWindow: InfoWindow(
              title: query,
            ),
            onTap: () async {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                      border: Border.all(
                        color: _isImageValid ? Colors.grey : Colors.red,
                        width: 1.0,
                      ),
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
                if (!_isImageValid)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Please select a restaurant image',
                      style: TextStyle(color: Colors.red, fontSize: 12),
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

                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  items: ['Male', 'Female'].map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.people_alt_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a gender';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isDropdownExpanded = !_isDropdownExpanded;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _isLocationValid ? Colors.grey : Colors.red,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _isLocationSelected
                                    ? _selectedAddress
                                    : 'Select outlet’s location on the map',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              _isDropdownExpanded
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!_isLocationValid)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Please select a location',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),

                SizedBox(
                  height: 7,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: _isDropdownExpanded
                      ? MediaQuery.of(context).size.height * 0.5
                      : 0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Enter your restaurant’s location',
                              prefixIcon:
                              Icon(Icons.search, color: Colors.grey),
                              suffixIcon: IconButton(
                                icon:
                                Icon(Icons.my_location, color: Colors.grey),
                                onPressed: () {
                                  _getCurrentLocation();
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 20.0),
                            ),
                            onSubmitted: (query) {
                              _searchLocation(query);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
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

// Use the button style and loading indicator in your widget
                Container(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                      setState(() {
                        _isLocationValid = _isLocationSelected;
                        _isImageValid = _selectedImage != null;
                      });
                      if (_formKey.currentState!.validate() &&
                          _isLocationValid &&
                          _isImageValid) {
                        await _registerRestaurant();
                      }
                    },
                    style: buttonStyle.copyWith(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: _isLoading
                        ? loadingIndicator
                        : const Text(
                      'Restaurant Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.camera);

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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
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