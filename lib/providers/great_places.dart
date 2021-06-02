import 'package:flutter/material.dart';
import '../models/place.dart';
import 'dart:io';
import '../helpers/db_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace({String pickedTitle, File pickedImage}) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: pickedImage,
      location: null,
      title: pickedTitle,
    );
    _items.insert(0, newPlace);
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path
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
            location: null,
            title: place['title'],
          ),
        )
        .toList()
        .reversed
        .toList();
    notifyListeners();
  }
}
