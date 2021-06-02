import 'package:flutter/material.dart';
import '../models/place.dart';
import 'dart:io';

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
    notifyListeners();
  }
}
