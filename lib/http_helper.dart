import 'dart:convert';

import 'package:http/http.dart' as http;

import 'data_model.dart';

Future<DataModel> getAllLocations() async { 
  // print("getAllLocations started");
  // final response = await http.get(Uri.parse('http://10.0.2.2:5183/api/EmergencyServiceLocation'));
  final response = await http.get(Uri.parse('http://10.0.2.2:5183/api/EmergencyServiceLocation'));

  // print("getAllLocations got response");
  if (response.statusCode == 200) {
    // print(response);
    // If the server did return a 200 OK response, parse the JSON response
    // final List<DataModel> locations = json.decode(response.body);

    final locations = DataModel.fromJson(jsonDecode(response.body)[0]);
    print(locations.name);
    return locations;
  } else {
    // print('error');
    // If the server did not return a 200 OK response, throw an error.
    throw Exception('Failed to load nearby hospitals');
  }
}

Future<List<DataModel>> getEmergencyLocations(double userLatitude, double userLongitude, String locationType) async { 
  final response = await http.get(Uri.parse("http://10.0.2.2:5183/api/EmergencyServiceLocation/nearby?latitude=$userLatitude&longitude=$userLongitude&locationtype=$locationType"));

  if (response.statusCode == 200) {
    final List<dynamic> decodedJson = jsonDecode(response.body);
    List<DataModel> listDataModel = [];
    for(int i = 0; i < decodedJson.length; i++ ) {
      DataModel dataModel = DataModel.fromJson(decodedJson[i]);
      listDataModel.add(dataModel);
    }
    return listDataModel;
  } else {
    throw Exception('Failed to load nearby hospitals');
  }
}