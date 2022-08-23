import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.blueAccent,
      statusBarColor: Colors.blueAccent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyMainScreen(),
    );
  }
}

class MyMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: const Color.fromARGB(255, 0, 21, 37),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                  onPressed: () {},
                  color: Colors.amberAccent,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 60),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    side: BorderSide(color: Colors.white)
                  ),// lag gae maj wo bs virtual device main buri c lag rahi hahaha
                  child: const Text(
                    "LogIn",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: "OoohBaby"),
                  )),
              const SizedBox(height: 20),
              MaterialButton(
                  onPressed: () {},
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 46),
                  color: Colors.amberAccent,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: const Text(
                    "Register",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: "OoohBaby"),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
