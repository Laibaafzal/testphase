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
}// maj pehle kahin dialog use kia kia humne? g kia howa ye alterdoalog kahan dikhna