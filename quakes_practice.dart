import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_updated/flutter_maps/quakes_app/model/quakes_model_class.dart';
import 'package:flutter_app_updated/flutter_maps/quakes_app/network/network.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class QuakesPractice extends StatefulWidget {
  @override
  _QuakesPracticeState createState() => _QuakesPracticeState();
}

class _QuakesPracticeState extends State<QuakesPractice> {
  Future<quakes_model> _quakesdata;
  Completer<GoogleMapController> _controllerp=Completer();
  List<Marker> _markerList=<Marker>[];
  double zoom=5;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _quakesdata=Network().getQuakes();
    _quakesdata.then((value){
      print("${value.features}");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(context),
          _zoomMinus()
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        findQuakes();
      },
          label: Text("Yo"),
    ),
    );
  }

Widget  _buildMap(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
    child: GoogleMap(mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller){
        _controllerp.complete(controller);
      },
    initialCameraPosition: CameraPosition(target: LatLng(36.108333,-117.860833)),
    markers: Set<Marker>.of(_markerList),));

}
  
  void findQuakes() {
    setState(() {
      _markerList.clear();
      _handlleResponse();
    });
  }

  void _handlleResponse() {
    setState(() {
      _quakesdata.then((quakes) => {
        quakes.features.forEach((quales)=> {
          _markerList.add(Marker(
            markerId: MarkerId(quales.id),
            infoWindow: InfoWindow(title: quales.properties.mag.toString()),
            position: LatLng(quales.geometry.coordinates[1],
                quales.geometry.coordinates[0]),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta)
          ,onTap: (){

          }
          ))
        })
      });
    });
  }

Widget  _zoomMinus() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(icon: Icon(FontAwesomeIcons.searchMinus), onPressed: (){
        zoom--;
        _zoomMinusValue(zoom);
      }),
    );
}

  Future<void> _zoomMinusValue(double zoom) async{
    final GoogleMapController _controller=await _controllerp.future;
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(36.108333,-117.860833),
      zoom: zoom)
    ));

  }
}
