import 'package:flutter/material.dart';
import 'package:flutter_app_updated/flutter_maps/quakes_app/model/quakes_model_class.dart';
import 'package:flutter_app_updated/flutter_maps/quakes_app/network/network.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class QuakesApp extends StatefulWidget {
  @override
  _QuakesAppState createState() => _QuakesAppState();
}

class _QuakesAppState extends State<QuakesApp> {
  Future<quakes_model> _data;
  //ompleter is a way to produce a future object and to complete them at a later
  //
  //time with either a value or an error.
  Completer<GoogleMapController> _controller=Completer();
  List<Marker> _markerList=<Marker>[];
  double _zoomVal=5.0;
  @override
  void initState() {
    // TODO: implement initState
    _data=Network().getQuakes();
    _data.then((value){
      print("${value.features[0].geometry.coordinates}");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildGoogleMap(context)
      ,_zoomMinus(),
          _zoomPlus()],
      ),
      floatingActionButton: FloatingActionButton.extended(label: Text("Find quakes"),
        onPressed: (){
          findQuakes();
        },
      ),
    );
  }

 Widget _buildGoogleMap(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GoogleMap(
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
        },
        initialCameraPosition: CameraPosition(target: LatLng(36.108333,-117.860833),
            zoom: 3),
        markers: Set<Marker>.of(_markerList),
      ),
    );
 }
Widget _zoomMinus(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(icon: Icon(Icons.zoom_out),
            onPressed: (){
          _zoomVal--;
          _minus(_zoomVal);
            }),
      ),
    );
}
  Widget _zoomPlus(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(icon: Icon(Icons.zoom_in),
            onPressed: (){
              _zoomVal++;
              _Plus(_zoomVal);
            }),
      ),
    );
  }

  void findQuakes() {
    setState(() {
      _markerList.clear();
      _handleResponse();
    });
  }
  void _handleResponse() {
setState(() {
  _data.then((quakes){
    quakes.features.forEach((quake)=> {
      _markerList.add(Marker(
markerId: MarkerId(quake.id),
    infoWindow: InfoWindow(title: quake.properties.mag.toString(),
    snippet: quake.properties.title),
    position: LatLng(quake.geometry.coordinates[1],quake.geometry.coordinates[0]),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
        onTap: (){

        }
      ))
    });
  });
});
  }

  Future<void> _minus(double zoomVal)async {
    final GoogleMapController controller=await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target:LatLng(40.71,-74.0059),
      zoom: _zoomVal)
    ));

  }
  Future<void> _Plus(double zoomVal)async {
    final GoogleMapController controller=await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target:LatLng(40.71,-74.0059),
            zoom: _zoomVal)
    ));
  }
}
