import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingDialog {
  static void showLoadingDialog(BuildContext context,
      {@required String msg, Function onBackPressed, double radius = 15.0}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: onBackPressed,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius))),
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(radius))),
            child: ListTile(
              leading: Container(
                  width: 30, height: 30, child: CircularProgressIndicator()),
              title: Text(
                msg,
                style: GoogleFonts.lato(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(LoadingDialog);
  }
}
