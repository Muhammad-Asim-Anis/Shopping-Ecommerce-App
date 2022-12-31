import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackReviewScreen extends StatefulWidget {
  final String email;
  final String username;
  final bool status;
  final dynamic userid;
  final int total;
  final String usercontact;
  final List<QueryDocumentSnapshot<Object?>> cartlist;
  const FeedbackReviewScreen(
      {super.key,
      required this.email,
      required this.username,
      required this.status,
      this.userid,
      required this.total,
      required this.usercontact,
      required this.cartlist});

  @override
  State<FeedbackReviewScreen> createState() => _FeedbackReviewScreenState();
}

class _FeedbackReviewScreenState extends State<FeedbackReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text("Feedback Reveiw Form"),
        elevation: 0,
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
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.cartlist.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 20,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  minLeadingWidth: 20,
                  onTap: () {
                  
                  },
                  leading: Image(
                    image: NetworkImage(widget.cartlist[index]["image"]),
                    width: 20,
                    height: 20,
                  ),
                  title: Text(widget.cartlist[index]['Product Name']),
                  subtitle:
                      Text("Quentity: ${widget.cartlist[index]['Quentity']}"),
                ),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Total: \$${widget.total}",
            style: GoogleFonts.poppins(
              fontSize: 28,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Text("Rate This Service", style: GoogleFonts.poppins(fontSize: 18)),
          const SizedBox(
            height: 20,
          ),
          RatingBar.builder(
            initialRating: 1,
            minRating: 1,
            direction: Axis.horizontal,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (double value) {},
          ),
           const SizedBox(
            height: 20,
          ),
          Text("Thanks For Purchasing from us", style: GoogleFonts.poppins(fontSize: 22)),
          const SizedBox(
            height: 50,
          ),
          Container(
        margin: const EdgeInsets.all(5),
              width: 131,
              height: 37,
             
              child: ElevatedButton(
                  onPressed: () {
                    if(widget.status == false)
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            email: widget.email,
                            name: widget.username,
                            status: widget.status,
                            userid: 0,
                            usercontact: widget.usercontact,
                          ),
                        ));
              
                    }
                    if(widget.status == true)
                    {
                          Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            email: widget.email,
                            name: widget.username,
                            status: widget.status,
                            userid: widget.userid,
                            usercontact: widget.usercontact,
                          ),
                        ));
                    }
                   
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent ),
                  child: const Text("Exit")),
            )
        ],
      )),
    );
  }
}
