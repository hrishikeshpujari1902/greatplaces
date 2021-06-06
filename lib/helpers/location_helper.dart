import 'package:http/http.dart' as http;
import 'dart:convert';

const MAPBOX_API_KEY =
    'pk.eyJ1IjoicHVqYXJpaHJpc2hpa2VzaCIsImEiOiJja3BpNWgwaHowY2d2MndvOWU0bGRzbXR0In0.aZaobsv_JDnH9Vi2C0Nrgw';

class LocationHelper {
  static String generateLocationPreviewImage(
      {double latitude, double longitude}) {
    return 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/pin-s+f70808($longitude,$latitude)/$longitude,$latitude,14,0/600x300?access_token=$MAPBOX_API_KEY';
  }

  static Future<String> getPlaceAddress(
      {double latitude, double longitude}) async {
    final url = Uri.parse(
        'https://api.opencagedata.com/geocode/v1/json?q=$latitude+$longitude&key=dcf0f1f03d894bd0afa4bed706d4fc72');
    final response = await http.get(url);
    final responseData = json.decode(response.body);
    final address =
        '${responseData['results'][0]['components']['neighbourhood']}, ${responseData['results'][0]['components']['city']}';
    return address;
  }
}
