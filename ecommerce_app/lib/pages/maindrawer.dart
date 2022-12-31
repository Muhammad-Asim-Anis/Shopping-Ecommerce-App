
import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/pages/cart.dart';
import 'package:ecommerce_app/pages/changepassword.dart';
import 'package:ecommerce_app/pages/products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  final String email;
  final String name;
  final int userid;
  final String usercontact;
  final bool status;
  const MainDrawer({super.key, required this.email, required this.name, required this.userid, required this.usercontact, required this.status});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueAccent,
      elevation: 0,
      child: ListView(
        children: [
            DrawerHeader(
              
              padding: const EdgeInsets.only(bottom: 1),
              
              child: UserAccountsDrawerHeader(
                accountName: Text("Name: ${widget.name} "),
                accountEmail: Text("Email: ${widget.email} "),
                margin: const EdgeInsets.all(0),
                currentAccountPicture: const  CircleAvatar(
                  maxRadius: 30,
                  child: Icon(Icons.person, size: 50),
                ),
              )),
                          
          const ListTile(
              leading: Icon(
                CupertinoIcons.home,
                color: Colors.white,
              ),
              title: Text(
                "Home",
                style: TextStyle(color: Colors.white),
              )),
          ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CartPage(email: widget.email, name: widget.name, id: widget.userid, status: true, usercontact: widget.usercontact,),
                    ));
              },
              leading: const Icon(
                CupertinoIcons.cart,
                color: Colors.white,
              ),
              title: const Text(
                "Cart",
                style: TextStyle(color: Colors.white),
              )),
          ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductsPage(status: widget.status, userid: widget.userid,),
                    ));
              },
              leading: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
              ),
              title: const Text(
                "Products",
                style: TextStyle(color: Colors.white),
              )),
            ListTile(
              onTap: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChangePasswordPage(email: widget.email, userid: widget.userid,),
                    ));
              },
              leading: const Icon(
                Icons.change_circle_outlined,
                color: Colors.white,
              ),
              title: const Text(
                "Change Password",
                style: TextStyle(color: Colors.white),
              )),
          ListTile(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomePage(
                            email: '', name: '', status: false, usercontact: '', userid: 0,)),
                    ModalRoute.withName("/"));
              },
              leading: const Icon(
                CupertinoIcons.arrow_left_circle,
                color: Colors.white,
              ),
              title: const Text(
                "Sign Out",
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }
}