import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testphase/user.dart';

import 'drawer.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditProfile();
  }
}

class EditProfile extends State<EditProfileScreen> {
  TextEditingController nameTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController mobileNoTEC = TextEditingController();
  TextEditingController oldPassTEC = TextEditingController();
  TextEditingController newPassTEC = TextEditingController();
  TextEditingController confirmPassTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var loggedInUser = UserClass.currentUser;
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(title: const Text('Edit profile')),
      body: SingleChildScrollView(
        child: Material(
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                myTextField(
                    mObscure: false,
                    mController: nameTEC,
                    mLabelText: "Full Name",
                    oldText: loggedInUser.fullName,
                    editable: true,
                    mIcon:
                        Image.asset('assets/images/account.png', scale: 1.7)),
                const SizedBox(height: 20),
                myTextField(
                    mObscure: false,
                    mController: emailTEC,
                    mLabelText: "Email",
                    oldText: loggedInUser.email,
                    editable: false,
                    mIcon: Image.asset('assets/images/email.png', scale: 1.7)),
                const SizedBox(height: 20),
                myTextField(
                    mObscure: false,
                    mController: mobileNoTEC,
                    mLabelText: "Mobile Number",
                    oldText: loggedInUser.phoneNo,
                    editable: false,
                    mIcon:
                        Image.asset('assets/images/mobile_no.png', scale: 1.7)),
                const SizedBox(height: 20),
                myTextField(
                    mObscure: true,
                    mController: oldPassTEC,
                    mLabelText: "Old Password",
                    editable: true,
                    mIcon:
                        Image.asset('assets/images/password.png', scale: 1.7)),
                const SizedBox(height: 20),
                myTextField(
                    mObscure: true,
                    mController: newPassTEC,
                    mLabelText: "New Password",
                    editable: true,
                    mIcon:
                        Image.asset('assets/images/password.png', scale: 1.7)),
                const SizedBox(height: 20),
                myTextField(
                    mObscure: true,
                    mController: confirmPassTEC,
                    mLabelText: "Confirm Password",
                    editable: true,
                    mIcon:
                        Image.asset('assets/images/password.png', scale: 1.7)),
                const SizedBox(height: 50),
                Container(
                  width: 250,
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
                      validateFieldAndSaveUser();
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const StadiumBorder(),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateFieldAndSaveUser() {
    var fullName = nameTEC.text;
    var oldPass = oldPassTEC.text;
    var newPass = newPassTEC.text;
    var confirmPass = confirmPassTEC.text;

    if (fullName.isNotEmpty && oldPass.isEmpty) {
      DatabaseReference ref = FirebaseDatabase.instance
          .ref("${UserClass.USER_TABLE}/${UserClass.currentUser.id}");
      ref.child(UserClass.FULL_NAME).set(fullName);
      FirebaseAuth auth = FirebaseAuth.instance;
      auth.currentUser?.updateDisplayName(fullName);
      Navigator.pop(context);
      return;
    }
    if (fullName.isEmpty) {
      Fluttertoast.showToast(msg: 'please Enter Name');
      return;
    }

    if (oldPass == UserClass.currentUser.password) {
      if (newPass.length >= 8) {
        if (newPass == confirmPass) {
          DatabaseReference ref = FirebaseDatabase.instance
              .ref("${UserClass.USER_TABLE}/${UserClass.currentUser.id}");
          ref.child(UserClass.FULL_NAME).set(fullName);
          ref.child(UserClass.PASSWORD).set(newPass);
          FirebaseAuth auth = FirebaseAuth.instance;
          auth.currentUser?.updatePassword(newPass);
          Navigator.pop(context);

          return;
        } else {
          Fluttertoast.showToast(msg: 'Password is not match');
        }
      } else {
        Fluttertoast.showToast(msg: "Password must be 8 character long");
      }
    } else {
      Fluttertoast.showToast(msg: 'Old password is incorrect');
    }
  }

  Widget myTextField(
      {required String mLabelText,
      required Image mIcon,
      String? oldText,
      required bool editable,
      required bool mObscure,
      required TextEditingController mController}) {
    mController.text = oldText ?? "";
    return TextField(
      obscureText: mObscure,
      controller: mController,
      enabled: editable,
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
