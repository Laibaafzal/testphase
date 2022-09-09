import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testphase/user.dart';

import 'editprofile_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(36, 198, 220, 1),
                Color.fromRGBO(81, 74, 157, 1),
              ],
            )),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage("assets/images/profile_avatar.png"),
            ),
            accountEmail: null,
            accountName: Text(
              UserClass.currentUser.fullName,
              style: const TextStyle(fontSize: 35, fontFamily: 'bluetea'),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfileScreen()));
            },
            leading: Image.asset('assets/images/account.png', scale: 1.9),
            title: const Text(
              'Profile',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ListTile(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            leading: Image.asset('assets/images/logout.png', scale: 1.9),
            title: const Text(
              'Logout',
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
