import 'package:flutter/material.dart';
import 'package:greatplaces/helpers/location_helper.dart';
import 'package:provider/provider.dart';
import '../providers/great_places.dart';

class PlaceDetalScreen extends StatelessWidget {
  static const routeName = 'place-detail';
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final selectedPlace =
        Provider.of<GreatPlaces>(context, listen: false).selectById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                child: Image.file(
                  selectedPlace.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 10),
              Text(
                selectedPlace.location.address,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              SizedBox(height: 10),
              Container(
                height: 170,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    LocationHelper.generateLocationPreviewImage(
                        longitude: selectedPlace.location.longitude,
                        latitude: selectedPlace.location.latitude),
                  ),
                  placeholder: AssetImage('assets/images/map_loading.jpg'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
