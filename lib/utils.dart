import 'package:flutter/material.dart';

class UtilItems{
  static void showProgressIndicator(BuildContext context){

     AlertDialog progressDialog = AlertDialog(
       content: Column(
         mainAxisSize: MainAxisSize.min,
         children: const [
           Text("Please Wait.."),
           CircularProgressIndicator(),

         ],
       ),
     );
     showDialog(context: context, builder:(context)=>progressDialog);

  }
}
