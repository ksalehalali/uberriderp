import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  Position? position;
  LatLng? _center;
  bool? _hasLocationPermission;
  bool? _isLocationEnabled;
  GoogleMapController? _mapController;

  LatLng? get center => _center;


  AppProvider.initialize(){
    _getUserLocation();
  }

  _getUserLocation() async{

    position = await Geolocator.getCurrentPosition();
    _center = LatLng(position!.latitude, position!.longitude);
    print('current loc = '+_center!.toString());
    notifyListeners();
  }

  onCreate(GoogleMapController controller){
    _mapController = controller;
    notifyListeners();
  }



}