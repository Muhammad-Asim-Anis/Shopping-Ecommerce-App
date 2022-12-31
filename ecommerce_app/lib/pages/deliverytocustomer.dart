import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/pages/feedbackreview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliverytoCustomerProcessScreen extends StatefulWidget {
  final String email;
  final String username;
  final bool status;
  final dynamic userid;
  final int total;
  final String usercontact;
  final List<QueryDocumentSnapshot<Object?>> cartlist;
  final double latitude;
  final double longtitude;
  final Uint8List markericon;
  const DeliverytoCustomerProcessScreen({super.key, required this.email, required this.username, required this.status, this.userid, required this.total, required this.usercontact, required this.cartlist, required this.latitude, required this.longtitude, required this.markericon});

  @override
  State<DeliverytoCustomerProcessScreen> createState() =>
      _DeliverytoCustomerProcessScreenState();
}

class _DeliverytoCustomerProcessScreenState
    extends State<DeliverytoCustomerProcessScreen> {
    final Completer<GoogleMapController> _controller = Completer();
    
      @override
  void initState() {
    
    super.initState();
   
  }


  
  @override
  Widget build(BuildContext context) {
    
    
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          title: const Text("Delivery Process"),
           leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.blueAccent,
          ),
        ), 
        ),
        body: GoogleMap(

          initialCameraPosition: const CameraPosition(
              target: LatLng(24.91638690588, 67.05699002225725),
              zoom: 14.4746),
          mapType: MapType.normal,
          
          onMapCreated: (controller) {
           _controller.complete(controller);
           
            
          },
          markers: <Marker> {
             
            Marker(
              markerId:const MarkerId("1"),
              position: LatLng(widget.latitude, widget.longtitude),
              infoWindow: const InfoWindow(title: "User Location")
              ),
              const Marker(
              markerId: MarkerId("2"),
              position: LatLng(24.902397373647943, 67.07289494395282),
              infoWindow: InfoWindow(title: "Warehouse Location"),
              
              ),
               Marker(
              markerId: const MarkerId("3"),
              icon: (widget.markericon.isNotEmpty)?  BitmapDescriptor.fromBytes(widget.markericon) : BitmapDescriptor.defaultMarker,
              position: const LatLng(24.902397373647943, 67.08289494395282),
              infoWindow: const InfoWindow(title: "Truck Location"),
              
              ),
              },
              polylines:  <Polyline>{
              const Polyline(
                polylineId: PolylineId("1"),
                color: Colors.blueAccent,
                width: 5,
                points: [LatLng(24.91638690588, 67.05699002225725),LatLng(24.902397373647943, 67.08289494395282),LatLng(24.902397373647943, 67.07289494395282)]
               )
              },
         
        ),
       
        bottomNavigationBar: DraggableScrollableSheet(
        initialChildSize: .2,
minChildSize: .1,
maxChildSize: .6,
expand: false,

        builder: (BuildContext context, ScrollController scrollController) { 
        return SingleChildScrollView(controller: scrollController,
          child: Container(
            
            height: 200,
            color: Colors.blueAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                 const Center(child: Text('Product will be  reach to you in 1 days', textAlign: TextAlign.center, style: TextStyle(
        color: Color.fromRGBO(0, 0, 0, 1),
        
        fontSize: 16,
        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
        fontWeight: FontWeight.bold,
        height: 1
      ),)),
      const SizedBox(
        height: 20,
      ),
      Container(
        margin: const EdgeInsets.all(5),
              width: 131,
              height: 37,
             
              child: ElevatedButton(
                  onPressed: () {
                   Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedbackReviewScreen(
                            email: widget.email,
                            username: widget.username,
                            total: widget.total,
                            cartlist: widget.cartlist,
                            status: widget.status,
                            userid: widget.userid,
                            usercontact: widget.usercontact,
                          ),
                        ));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(1, 0, 62, 111) ),
                  child: const Text("Proceed")),
            )
              ],
            ),
          ),
        );
        },),
        );

  }
}
