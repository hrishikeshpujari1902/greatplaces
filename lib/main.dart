import 'package:flutter/material.dart';
import 'package:greatplaces/screens/add_place_screen.dart';
import 'package:greatplaces/screens/place_detail_screen.dart';
import 'package:greatplaces/screens/places_list_screen.dart';
import './providers/great_places.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GreatPlaces(),
        ),
      ],
      child: MaterialApp(
        title: 'Great Places',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
        ),
        home: PlacesListScreen(),
        routes: {
          AddPlaceScreen.routeName: (context) => AddPlaceScreen(),
          PlaceDetalScreen.routeName: (context) => PlaceDetalScreen(),
        },
      ),
    );
  }
}
