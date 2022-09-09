import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:testphase/registration_screen.dart';
import 'package:testphase/user.dart';
import 'package:testphase/utils.dart';
import 'package:testphase/welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginScreen> {
  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  TextEditingController mobileNoTEC = TextEditingController();
  final List<String> loginMethod = ['Email', 'Mobile Number'];
  String? selectLoginMethod = "Select Login Method";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: HexColor("#FFFFFF"),
        child: Container(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              dropDownMenu(['Select Login Method', 'Email', 'Mobile Number']),
              const SizedBox(height: 20),
              selectLoginMethod == 'Select Login Method'
                  ? Container()
                  : selectLoginMethod == loginMethod[0]
                      ? loginTextField(
                          mController: emailTEC,
                          mObscure: false,
                          mLabelText: 'Email',
                          mIcon: Image.asset('assets/images/email.png',
                              scale: 1.7))
                      : loginTextField(
                          mLabelText: 'Mobile No',
                          mIcon: Image.asset('assets/images/mobile_no.png',
                              scale: 1.9),
                          mController: mobileNoTEC,
                          mObscure: false),
              const SizedBox(height: 20),
              loginTextField(
                  mController: passwordTEC,
                  mObscure: true,
                  mLabelText: 'Password',
                  mIcon: Image.asset('assets/images/password.png', scale: 1.9)),
              const SizedBox(height: 100),
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
                    _loginAndLoadMainScreen();
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: const StadiumBorder(),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

  void _loginAndLoadMainScreen() async {
    var email = emailTEC.text;
    var mobileNo = mobileNoTEC.text;
    var password = passwordTEC.text;

    if (selectLoginMethod == loginMethod[0]) {
      UtilItems.showProgressIndicator(context);
      if (validateFieldsEmail()) {
        loginFirebase(email, password);
      }
    } else if (selectLoginMethod == loginMethod[1]) {
      if (validatePhone()) {
        String emailFromPhone = getEmailFromPhoneNumber();
        loginFirebase(emailFromPhone, password);
      }
    }
  }

  void loginFirebase(String email, String password) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      DatabaseReference reference = FirebaseDatabase.instance
          .ref("${UserClass.USER_TABLE}/${auth.currentUser?.uid}");
      reference.onValue.listen((event) {
        if (event.snapshot.exists) {
          final snapShot = event.snapshot;
          UserClass user = UserClass.fromSnapShot(snapShot);
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()));
        } else {
          Fluttertoast.showToast(msg: 'User not found');
        }
      }).onError((error) {
        Fluttertoast.showToast(
            msg: "Error while logging in ${error.toString()}");
      });
    }).catchError((err) {
      Fluttertoast.showToast(msg: "Invalid id or password");
      Navigator.pop(context);
    });
  }

  String getEmailFromPhoneNumber() {
    return "${mobileNoTEC.text.substring(3, mobileNoTEC.text.length)}@testphase.com";
  }

  bool validatePhone() {
    if (mobileNoTEC.text.length == 13 && mobileNoTEC.text.startsWith("+92")) {
      if (passwordTEC.text.length >= 8) {
        return true;
      } else {
        Fluttertoast.showToast(
            msg: "Password Must be atleast 8 characters long");
        return false;
      }
    } else {
      Fluttertoast.showToast(msg: "Invalid Phone Number Format");
      return false;
    }
  }

  bool validateFieldsEmail() {
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (emailRegExp.hasMatch(emailTEC.text) && passwordTEC.text.length >= 8) {
      return true;
    }
    return false;
  }

  Widget loginTextField(
      {required String mLabelText,
      required Image mIcon,
      required TextEditingController mController,
      required bool mObscure}) {
    return TextField(
      controller: mController,
      obscureText: mObscure,
      decoration: InputDecoration(
        prefixIcon: mIcon,
        labelText: mLabelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(
          fontSize: 17,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget dropDownMenu(List<String> entries) {
    return DropdownButton<String>(
        value: selectLoginMethod,
        icon: const Icon(Icons.arrow_drop_down),
        items: entries.map<DropdownMenuItem<String>>((String e) {
          return DropdownMenuItem<String>(
            value: e,
            child: Text(e),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectLoginMethod = value;
          });
        });
  }
}
