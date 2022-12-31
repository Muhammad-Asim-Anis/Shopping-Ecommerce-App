import 'package:ecommerce_app/pages/cart.dart';
import 'package:ecommerce_app/pages/login.dart';
import 'package:ecommerce_app/pages/products.dart';
import 'package:ecommerce_app/pages/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueAccent,
      elevation: 0,
      child: ListView(
        children: [
           const DrawerHeader(
              
              padding: EdgeInsets.only(bottom: 1),
              
              child: UserAccountsDrawerHeader(
                accountName: Text("Name: Guest "),
                accountEmail: Text("Email: Guest "),
                margin: EdgeInsets.all(0),
                currentAccountPicture:  CircleAvatar(
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
                          const CartPage(email: '', name: '', id: '', status: false, usercontact: '',),
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
                          const ProductsPage(status: false , userid: 0,),
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
                        builder: (context) => const Login() ),
                    );
              },
              leading: const Icon(
                Icons.account_box_rounded,
                color: Colors.white,
              ),
              title: const Text(
                "Login",
                style: TextStyle(color: Colors.white),
              )),
          ListTile(
              onTap: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage())); 
              },
              leading: const Icon(
                CupertinoIcons.person_alt_circle,
                color: Colors.white,
              ),
              title: const Text(
                "Register",
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }
}