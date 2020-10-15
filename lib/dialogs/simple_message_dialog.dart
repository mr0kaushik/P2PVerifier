import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum DialogType { VERIFIED, UNKNOWN, NONE }

class MsgDialog {
  static Future<bool> showMsgDialog(
      {@required BuildContext context,
      String title,
      String msg,
      String positiveText = "Ok",
      VoidCallback onPositivePressed,
      bool dismissible = true}) {
    Widget positiveButton = FlatButton(
      child: Text(positiveText ?? ''),
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      onPressed: () {
        Navigator.of(context).pop(true);
        if (onPositivePressed != null) {
          onPositivePressed();
        }
      },
    );

    return showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: title == null
            ? null
            : Text(
                title ?? '',
                style: GoogleFonts.lato(
                    fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
        content: Text(
          msg ?? '',
          style: GoogleFonts.nunitoSans(fontSize: 14.0),
        ),
        actions: <Widget>[positiveButton],
      ),
    );
  }
}

class ResultDialog {
  static Future<bool> showMsgDialog(
      {@required BuildContext context,
      String title,
      String msg,
      String positiveText = "Ok",
      String negativeText = "Cancel",
      VoidCallback onPositivePressed,
      VoidCallback onNegativePressed,
      double width = 100,
      DialogType dialogType = DialogType.NONE,
      bool dismissible = true}) {
    final Widget image = Image.asset(
      dialogType == DialogType.VERIFIED
          ? "assets/images/verified.png"
          : "assets/images/crossed.png",
      width: width,
      height: width,
    );

    final Widget positiveButton = FlatButton(
      child: Text(positiveText ?? ''),
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      onPressed: () {
        Navigator.of(context).pop(true);
        if (onPositivePressed != null) {
          onPositivePressed();
        }
      },
    );

    return showDialog(
        context: context,
        barrierDismissible: dismissible,
        builder: (context) {
          return Dialog(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: image,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 4.0, right: 4.0),
                      child: Text(
                        title ?? '',
                        style: GoogleFonts.lato(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (msg != null)
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 4.0, right: 4.0),
                        child: Text(
                          msg ?? '',
                          style: GoogleFonts.nunitoSans(
                              fontSize: 14.0, color: Colors.grey),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: positiveButton,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
