import 'package:flutter/material.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Material(
        child: Stack(children: [
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 120),
            child: const Text(
              'Welcome',
              style: TextStyle(fontSize: 30),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(36, 198, 220, 1),
                  Color.fromRGBO(81, 74, 157, 1),
                ],
              )),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    "https://as2.ftcdn.net/v2/jpg/02/68/85/17/1000_F_268851751_llVlHNXli35pgoNafjV2SqWUmvv6snHU.jpg"),
              ),
              accountEmail: null,
              accountName: Text(
                "My Profile",
                style: TextStyle(fontSize: 25),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Image.asset('assets/images/account.png', scale: 1.9),
              title: const Text(
                'Profile',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Image.asset('assets/images/logout.png', scale: 1.9),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
