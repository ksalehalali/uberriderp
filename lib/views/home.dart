import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uberriderp/controllers/app.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taxi App',
      home: Scaffold(
        key: _key,
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                  accountName: Text("khaled"),
                  accountEmail: Text("khaled@gmail.com"))
            ],
          ),
        ),
        body: Stack(
          children: [
            MapScreen(scaffoldKey: _key,),
          ],
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  MapScreen({Key? key, this.scaffoldKey}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(29.375810, 47.986349),
      tilt: 59.440717697143555,
      zoom: 15.151926040649414);

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Taxi App"),
      ),
      body: appProvider.center == null
          ? CircularProgressIndicator()
          : Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: appProvider.center!,
                    zoom: 15,
                  ),
                  onMapCreated: appProvider.onCreate,
                  myLocationEnabled: true,
                ),
                Positioned(
                    child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: 36,
                  ),
                  onPressed: () {
                    widget.scaffoldKey!.currentState!.openDrawer();
                  },
                ))
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
