import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:testphase/drawer_screen.dart';
import 'package:testphase/registeration_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: HexColor("#FFFFFF"),
        child: Container(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                "assets/images/upper_back.png",
              ),
              LoginTextField(
                  mLabelText: 'Email',
                  mIcon: Image.asset('assets/images/email.png', scale: 1.7)),
              LoginTextField(
                  mLabelText: 'Password',
                  mIcon: Image.asset('assets/images/password.png', scale: 1.7)),
              const SizedBox(height: 50),
              Container(
                width: 200,
                height: 50,
                decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(36, 198, 220, 1),
                        Color.fromRGBO(81, 74, 157, 1),
                      ],
                    )),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DrawerScreen()));
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: const StadiumBorder(),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Does not have an account?',
                    style: TextStyle(fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(216, 28, 87, 233),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget LoginTextField({required String mLabelText, required Image mIcon}) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: mIcon,
        labelText: mLabelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(
          fontSize: 15,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
