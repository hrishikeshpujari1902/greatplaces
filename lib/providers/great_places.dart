import 'package:flutter/material.dart';
import '../models/place.dart';
import 'dart:io';
import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(
      {String pickedTitle,
      File pickedImage,
      PlaceLocation pickedlocation}) async {
    final address = await LocationHelper.getPlaceAddress(
        latitude: pickedlocation.latitude, longitude: pickedlocation.longitude);
    final updatedLocation = PlaceLocation(
        latitude: pickedlocation.latitude,
        longitude: pickedlocation.longitude,
        address: address);
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: pickedImage,
      location: updatedLocation,
      title: pickedTitle,
    );
    _items.insert(0, newPlace);
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    notifyListeners();
  }

  Future<void> fetchPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map(
          (place) => Place(
            id: place['id'],
            image: File(place['image']),
            location: PlaceLocation(
              latitude: place['loc_lat'],
              longitude: place['loc_lng'],
              address: place['address'],
            ),
            title: place['title'],
          ),
        )
        .toList()
        .reversed
        .toList();
    notifyListeners();
  }

  Place selectById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
