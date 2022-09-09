import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:testphase/login_screen.dart';
import 'package:testphase/user.dart';
import 'package:testphase/utils.dart';
import 'package:testphase/welcome_screen.dart';
import 'package:uuid/uuid.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RegistrationState();
  }
}

class RegistrationState extends State<RegisterScreen> {
  TextEditingController nameTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController mobileNoTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  TextEditingController confirmPasswordTEC = TextEditingController();
  final List<String> _verificationMethods = ['Email', 'Mobile Number'];
  String? _selectedVerificationMethod = "Select Verification Method";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Material(
          color: HexColor("#FFFFFF"),
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dropMenu(
                    ['Select Verification Method', "Email", "Mobile Number"]),
                const SizedBox(height: 20),
                _selectedVerificationMethod == "Select Verification Method"
                    ? Container()
                    : _selectedVerificationMethod == _verificationMethods[0]
                        ? registrationTextField(
                            mController: emailTEC,
                            mObscure: false,
                            mLabelText: "Email",
                            mIcon: Image.asset('assets/images/email.png',
                                scale: 1.9))
                        : registrationTextField(
                            mController: mobileNoTEC,
                            mObscure: false,
                            mLabelText: "Mobile Number",
                            mIcon: Image.asset('assets/images/mobile_no.png',
                                scale: 1.9)),
                const SizedBox(height: 20),
                registrationTextField(
                    mController: nameTEC,
                    mObscure: false,
                    mLabelText: "Full Name",
                    mIcon:
                        Image.asset('assets/images/account.png', scale: 1.9)),
                const SizedBox(height: 20),
                registrationTextField(
                    mController: passwordTEC,
                    mObscure: true,
                    mLabelText: "password",
                    mIcon:
                        Image.asset('assets/images/password.png', scale: 1.9)),
                const SizedBox(height: 20),
                registrationTextField(
                    mController: confirmPasswordTEC,
                    mObscure: true,
                    mLabelText: "Confirm Password",
                    mIcon:
                        Image.asset('assets/images/password.png', scale: 1.9)),
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
                      registerUser();
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const StadiumBorder(),
                    child: const Text(
                      'REGISTER',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(216, 28, 87, 233)),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void registerUser() {
    UserClass? user = validateFieldsAndGetUser();

    FirebaseAuth auth = FirebaseAuth.instance;

    if (user != null) {
      if (_selectedVerificationMethod == _verificationMethods[1]) {
        UtilItems.showProgressIndicator(context);
        auth.verifyPhoneNumber(
            phoneNumber: user.phoneNo,
            verificationCompleted: (AuthCredential credential) {},
            verificationFailed: (FirebaseAuthException exc) {},
            codeSent: (verificationID, token) => showCodeInputDialog(
                context, user, auth,
                verificationID: verificationID),
            codeAutoRetrievalTimeout: (String _) {});
      } else if (_selectedVerificationMethod == _verificationMethods[0]) {
        UtilItems.showProgressIndicator(context);
        auth
            .createUserWithEmailAndPassword(
                email: user.email, password: user.password)
            .then((value) {
          user.id = getUserIDFromAuth(auth);
          Navigator.pop(context);
          addUserToDataBase(user);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()));
        }).catchError((error) {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Signup Error ${error.toString()}");
        });
      }
    }
  }

  String getUserIDFromAuth(FirebaseAuth auth) {
    String? userId = auth.currentUser?.uid;
    if (userId == null) {
      return " ";
    } else {
      return userId;
    }
  }

  void showCodeInputDialog(
      BuildContext context, UserClass? user, FirebaseAuth auth,
      {required String verificationID}) {
    showDialog(
        context: context,
        builder: (context) {
          return codeDialog(verificationID, verificationComplete: () {
            user?.id = getUserIDFromAuth(auth);
            String? phoneNumber =
                user?.phoneNo.substring(3, user.phoneNo.length);
            user?.email = "$phoneNumber@testphase.com";
            if (user != null) {
              auth
                  .createUserWithEmailAndPassword(
                      email: user.email, password: user.password)
                  .then((value) {
                user.id = getUserIDFromAuth(auth);
                addUserToDataBase(user);
              });
            }

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()));
          });
        });
  }

  void addUserToDataBase(UserClass? user) {
    DatabaseReference database = FirebaseDatabase.instance
        .ref()
        .child(UserClass.USER_TABLE)
        .child(user?.id ?? " ");

    database.set(<String, String?>{
      UserClass.FULL_NAME: user?.fullName,
      UserClass.EMAIL: user?.email,
      UserClass.PHONE_NUMBER: user?.phoneNo,
      UserClass.PASSWORD: user?.password
    });
  }

  Widget codeDialog(String verificationID, {verificationComplete}) {
    TextEditingController codeController = TextEditingController();
    return AlertDialog(
      title: const Text("Enter SMS Code"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: codeController),
          MaterialButton(
              child: const Text("Confirm"),
              onPressed: () {
                String smsCode = codeController.text.trim();
                if (smsCode.isEmpty) {
                  Fluttertoast.showToast(msg: 'Please enter code');
                } else {
                  UtilItems.showProgressIndicator(context);
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationID, smsCode: smsCode);
                  FirebaseAuth.instance
                      .signInWithCredential(credential)
                      .then((result) {
                    Fluttertoast.showToast(msg: "Number Verified");
                    verificationComplete();
                    Navigator.pop(context);
                  }).catchError((error) {
                    Navigator.pop(context);
                  });
                }
              }),
        ],
      ),
    );
  }

  UserClass? validateFieldsAndGetUser() {
    var name = nameTEC.text;
    var email = emailTEC.text;
    var mobileNo = mobileNoTEC.text;
    var password = passwordTEC.text;
    var confirmPassword = confirmPasswordTEC.text;
    if (_selectedVerificationMethod == _verificationMethods[0]) {
      if (email.isEmpty && !isEmailValid(email)) {
        Fluttertoast.showToast(msg: "Enter Valid Email");
        return null;
      }
    } else if (_selectedVerificationMethod == _verificationMethods[1]) {
      if (!isPhoneValid(mobileNo)) {
        Fluttertoast.showToast(msg: "Enter Valid Phone Number In +92 format");
        return null;
      }
    } else {
      Fluttertoast.showToast(msg: "Please Select Verification Method");
    }

    if (name.isEmpty) {
      Fluttertoast.showToast(msg: 'Enter Name');
      return null;
    }
    if (password.isEmpty) {
      Fluttertoast.showToast(msg: "Please Enter Password");
    }
    if (password.length < 8) {
      Fluttertoast.showToast(msg: 'Maximum 8 character');
      return null;
    }
    if (confirmPassword.isEmpty) {
      Fluttertoast.showToast(msg: "Re-Enter your Password");
    }
    if (password != confirmPassword) {
      Fluttertoast.showToast(msg: 'Password is not match');
      return null;
    }
    String userId = const Uuid().v4();
    return UserClass(
        id: userId,
        fullName: name,
        email: email,
        phoneNo: mobileNo,
        password: password);
  }

  bool isEmailValid(String email) {
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (emailRegExp.hasMatch(email)) {
      return true;
    }
    return false;
  }

  bool isPhoneValid(String phoneNumber) {
    if (phoneNumber.length == 13 && phoneNumber.startsWith("+")) {
      return true;
    }
    return false;
  }

  Widget registrationTextField(
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
          fontSize: 15,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget dropMenu(List<String> entries) {
    return DropdownButton<String>(
        value: _selectedVerificationMethod,
        icon: const Icon(Icons.arrow_drop_down),
        onChanged: (value) {
          setState(() {
            _selectedVerificationMethod = value;
          });
        },
        items: entries.map<DropdownMenuItem<String>>((String e) {
          return DropdownMenuItem<String>(
            value: e,
            child: Text(e),
          );
        }).toList());
  }
}
