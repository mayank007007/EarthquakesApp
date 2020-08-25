import 'dart:convert';

import 'package:flutter_app_updated/flutter_maps/quakes_app/model/quakes_model_class.dart';
import 'package:http/http.dart';

class Network{
  Future<quakes_model>getQuakes()async{
    var url="https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson#";
    final response=await get(Uri.encodeFull(url));
    if(response.statusCode==200){
      print("Quakes data: ${response.body}");
      return quakes_model.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("error getting data");
    }
  }
}