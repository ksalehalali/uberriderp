import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uberriderp/controllers/app.dart';
import 'package:uberriderp/views/home.dart';

import 'helpers/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  LocationPermission permission = await Geolocator.checkPermission();
  bool _isLocationEnabled = await Geolocator.isLocationServiceEnabled();

  bool _hasLocationPermission = prefs.getBool(HAS_PERMISSION) ?? false;
  //_isLocationEnabled = prefs.getBool(LOCATION_ENABLED) ?? false;

  if (!_isLocationEnabled) {
    await Geolocator.openLocationSettings();
  } else {
    if (!_hasLocationPermission) {
      if (permission != LocationPermission.always) {
        LocationPermission requestPermission =
            await Geolocator.requestPermission();

        if (requestPermission == LocationPermission.always) {
          await prefs.setBool(HAS_PERMISSION, true);
        } else {
          //do something when the permission is not always

        }
      }
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppProvider.initialize())
      ],
      child: Home(),
    ),
  );
}

