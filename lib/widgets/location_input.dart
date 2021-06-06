import 'package:flutter/material.dart';
import 'package:greatplaces/helpers/location_helper.dart';
import 'package:greatplaces/models/place.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationInput extends StatefulWidget {
  final Function getPlaceLoaction;
  LocationInput(this.getPlaceLoaction);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput>
    with SingleTickerProviderStateMixin {
  bool _searchLoaction = false;
  String _previewImageUrl;
  final searchTextController = TextEditingController();
  void toggleSearchLocation() {
    setState(() {
      searchTextController.text = '';
      _searchLoaction = !_searchLoaction;
    });
  }

  Future<void> onSubmitSearch(String text) async {
    if (text.isEmpty) {
      return;
    }
    final url = Uri.parse(
        'https://api.opencagedata.com/geocode/v1/json?q=$text&key=dcf0f1f03d894bd0afa4bed706d4fc72');
    final response = await http.get(url);
    final responseData = json.decode(response.body);
    final longitude = responseData['results'][0]['geometry']['lng'];
    final latitude = responseData['results'][0]['geometry']['lat'];
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: latitude, longitude: longitude);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
    final placeLocation =
        PlaceLocation(latitude: latitude, longitude: longitude, address: text);
    widget.getPlaceLoaction(placeLocation);
  }

  Future<void> _getCurrentLocation() async {
    final locationData = await Location().getLocation();
    if (locationData == null) {
      return;
    }
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: locationData.latitude, longitude: locationData.longitude);
    setState(() {
      _searchLoaction = false;
      _previewImageUrl = staticMapImageUrl;
    });

    final placelocation = PlaceLocation(
      latitude: locationData.latitude,
      longitude: locationData.longitude,
    );
    widget.getPlaceLoaction(placelocation);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Colors.grey,
          )),
          child: _previewImageUrl == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          constraints: BoxConstraints(
              minHeight: _searchLoaction ? 60 : 0,
              maxHeight: _searchLoaction ? 120 : 0),
          curve: Curves.easeIn,
          child: TextField(
            controller: searchTextController,
            textInputAction: TextInputAction.done,
            enabled: _searchLoaction,
            decoration: InputDecoration(labelText: 'Search..'),
            onSubmitted: (value) {
              onSubmitSearch(value);
            },
            cursorColor: Theme.of(context).primaryColor,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ignore: deprecated_member_use
            FlatButton.icon(
              onPressed: _getCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text('Current Loaction'),
              textColor: Theme.of(context).primaryColor,
            ),
            // ignore: deprecated_member_use
            FlatButton.icon(
              onPressed: toggleSearchLocation,
              icon: Icon(Icons.map),
              label: Text('Search'),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        )
      ],
    );
  }
}
