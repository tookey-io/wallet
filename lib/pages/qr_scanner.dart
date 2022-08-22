import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // backgroundColor: Colors.transparent,
            // shadowColor: Colors.transparent,
            // actions: [
            // AppBarAction(child: const Icon(Icons.close), onTap: () {}),
            // ],
            ),
        body: Stack(
          children: [
            QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: (result != null)
                        ? Text(
                            'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                        : FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: () async {
                              await controller?.flipCamera();
                            },
                            child: const Icon(Icons.flip_camera_android, color: Colors.blue,),
                          ),
                  )),
            )
          ],
        ));
  }
}

class AppBarAction extends StatelessWidget {
  final Widget _child;
  final Function()? _onTap;

  const AppBarAction({Key? key, required Widget child, void Function()? onTap})
      : _child = child,
        _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: _onTap,
          child: _child,
        ));
  }
}

class NewWidget extends StatelessWidget implements PreferredSizeWidget {
  const NewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Spacer(),
        FloatingActionButton(
            onPressed: () {}, child: Icon(Icons.close_fullscreen))
      ],
    ));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(100, 100);
}
