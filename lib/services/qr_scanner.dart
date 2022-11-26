import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({required this.onData, this.onCancel, super.key});

  final void Function(String) onData;
  final VoidCallback? onCancel;

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

  // In order to get hot reload to work we need to pause the camera
  // if the platform is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: controller,
          onDetect: (barcode, args) {
            setState(() {
              result = barcode;
            });

            if (barcode.rawValue != null) widget.onData(barcode.rawValue!);
          },
        ),
        Positioned(
          bottom: 21,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Center(
              child: FloatingActionButton(
                heroTag: 'close',
                backgroundColor: Colors.white,
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
        if (dotenv.env['TEST_ENV'] != null) ...[
          Positioned(
            bottom: 21,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30, right: 30),
              child: FloatingActionButton(
                heroTag: 'switchCamera',
                backgroundColor: Colors.white,
                onPressed: () async {
                  await controller.switchCamera();
                },
                child: const Icon(
                  Icons.cameraswitch_outlined,
                  color: Colors.blue,
                ),
              ),
            ),
          )
        ]
      ],
    );
  }
}
