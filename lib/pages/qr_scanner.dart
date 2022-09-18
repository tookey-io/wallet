import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
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
            MobileScanner(controller: controller, onDetect: (barcode, args) {
              setState(() {
                result = barcode;
              });

              if (barcode.rawValue == null) {
                debugPrint('Failed to scan Barcode');
              } else {
                final String code = barcode.rawValue!;
                debugPrint('Barcode found! $code');
              }
            }),
            // QRView(
            //   key: qrKey,
            //   onQRViewCreated: _onQRViewCreated,
            // ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: (result != null)
                        ? Text(
                            'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.rawValue}')
                        : FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: () async {
                              await controller.switchCamera();
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