import 'package:flutter/material.dart';
import 'package:flutter_hit_locator/models/place.dart';
import 'package:flutter_hit_locator/screens/search.dart';
import 'package:flutter_hit_locator/services/geolocator_service.dart';
import 'package:flutter_hit_locator/services/places_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final locatorService = GeoLocatorService();
  final placesService = PlacesService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Future<Position>>(
          create: (context) => locatorService.getLocation(),
        ),
        Provider<Future<BitmapDescriptor>>(
          create: (context) {
            ImageConfiguration configuration =
                createLocalImageConfiguration(context);
            return BitmapDescriptor.fromAssetImage(
                configuration, 'assets/images/parking-icon.png');
          },
        ),
        ProxyProvider2<Position, BitmapDescriptor, Future<List<Place>>>(
          update: (context, position, icon, places) {
            if ((position != null)) {
              return placesService.getPlaces(
                  position.latitude, position.longitude, icon);
            } else {
              return placesService.getPlaces(
                  position.latitude, position.longitude, icon); //TODO: custom
            }
          },
        )
      ],
      child: MaterialApp(
        title: 'Parking App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Search(),
      ),
    );
  }
}
