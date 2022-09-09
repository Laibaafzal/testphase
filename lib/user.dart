import 'package:firebase_database/firebase_database.dart';

class UserClass {
  static final USER_TABLE = 'Users';
  static final FULL_NAME = 'FullName';
  static final EMAIL = 'Email';
  static final PHONE_NUMBER = 'PhoneNo';
  static final PASSWORD = "Password";

  late String id;
  late String fullName;
  late String email;
  late String phoneNo;
  late String password;
  static final UserClass currentUser = UserClass._internal();

  factory UserClass(
      {required String id,
      required String fullName,
      required String email,
      required String phoneNo,
      required String password}) {
    currentUser.id = id;
    currentUser.fullName = fullName;
    currentUser.email = email;
    currentUser.phoneNo = phoneNo;
    currentUser.password = password;
    return currentUser;
  }

  static UserClass fromSnapShot(DataSnapshot snapshot) {
    String fullName = snapshot.child(FULL_NAME).value.toString();
    String id = snapshot.key.toString();
    String email = snapshot.child(EMAIL).value.toString();
    String phoneNo = snapshot.child(PHONE_NUMBER).value.toString();
    String password = snapshot.child(PASSWORD).value.toString();
    currentUser.id = id;
    currentUser.email = email;
    currentUser.fullName = fullName;
    currentUser.phoneNo = phoneNo;
    currentUser.password = password;
    return currentUser;
  }

  UserClass._internal();
}
