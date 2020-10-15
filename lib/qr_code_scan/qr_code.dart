import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p2p_verifier/dialogs/simple_message_dialog.dart';
import 'package:p2p_verifier/web_view.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

const WHITE_LABEL_URL_1 = 'https://block.dsci.in/';
const WHITE_LABEL_URL_2 = 'https://www.block.dsci.in/';

class QrScanScreen extends StatefulWidget {
  @override
  _QrScanScreenState createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final RegExp validRegEx =
      RegExp(r"^(?:https?:)?(?:\/\/)?(?:[^@\n]+@)?(?:www\.)?([^:\/\n]+)");

  final RegExp urlRegEx = new RegExp(
      r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");

  var qrText = "";
  QRViewController controller;
  bool isFlashOn = false;

  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Stack(
          children: [
            QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Theme.of(context).accentColor,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.75,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  isFlashOn ? Icons.flash_off : Icons.flash_on,
                  color: Colors.white,
                ),
                onPressed: () async {
                  controller.toggleFlash();
                  if (mounted) {
                    setState(() {
                      isFlashOn = !isFlashOn;
                    });
                  }
                },
              ),
            ),
            Positioned(
              bottom: 12,
              right: 16,
              left: 16,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Powered By\n',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontStyle: FontStyle.italic,
                  ),
                  children: [
                    TextSpan(
                        text: "P2P Verifier",
                        style: TextStyle(
                            fontSize: 14.0,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onQRViewCreated(QRViewController _controller) async {
    try {
      this.controller = _controller;
      controller.scannedDataStream.listen((scanData) {
        if (scanData != null && scanData.isNotEmpty) {
          _getResult(scanData);
        }
      });
    } on Exception catch (exp) {
      await MsgDialog.showMsgDialog(
        context: context,
        title: 'An Error Occurred !!',
        msg: "${exp.toString()}",
        positiveText: "Ok",
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _getResult(String scanData) async {
    controller.pauseCamera();
    if (urlRegEx.hasMatch(scanData)) {
      if (scanData.contains(WHITE_LABEL_URL_1) ||
          scanData.contains(WHITE_LABEL_URL_2)) {
        final urlMatches = validRegEx.allMatches(scanData);
        List<String> urls = urlMatches
            .map((urlMatch) => scanData.substring(urlMatch.start, urlMatch.end))
            .toList();

        final val = await ResultDialog.showMsgDialog(
          context: context,
          title: "VERIFIED DOMAIN NAME",
          msg: urls.first,
          width: MediaQuery.of(context).size.width * 0.25,
          dialogType: DialogType.VERIFIED,
          positiveText: "Launch URL",
          onPositivePressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UrlLauncher(
                      url: scanData,
                    )));
            controller.resumeCamera();
          },
        );

        if (val == null || !val) {
          controller.resumeCamera();
        }
      } else {
        await ResultDialog.showMsgDialog(
            context: context,
            title: 'UNKNOWN DOMAIN',
            msg: 'Not a verified domain',
            positiveText: "Scan Again",
            negativeText: "",
            dismissible: true);
        controller.resumeCamera();
      }
    } else {
      await ResultDialog.showMsgDialog(
          context: context,
          title: 'NOT a URL',
          msg: 'Scanned data is not a URL',
          positiveText: "Scan Again",
          negativeText: "",
          dismissible: true);
      controller.resumeCamera();
    }
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press BACK again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
}
