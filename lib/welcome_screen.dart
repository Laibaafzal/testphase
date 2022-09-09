import 'package:flutter/material.dart';
import 'package:testphase/user.dart';

import 'drawer.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Material(
        child: Stack(children: [
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 120),
            child: Text(
              'Welcome\n${UserClass.currentUser.fullName}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 50,
                fontFamily: "bluetea",
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/welcome.png"),
            )),
          ),
        ]),
      ),
    );
  }
}
