import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({
    super.key,
    required this.onData,
    this.onCancel,
    this.bottom,
  });

  final void Function(String) onData;
  final VoidCallback? onCancel;

  final Widget? bottom;

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
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (barcode) {
              setState(() {
                if (result != null) {
                  return;
                }

                result = barcode.barcodes.first;

                if (mounted) Navigator.pop(context);

                if (barcode.barcodes.first.rawValue != null) {
                  widget.onData(barcode.barcodes.first.rawValue!);
                }
              });
            },
          ),
          if (widget.bottom != null)
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              // ignore: use_decorated_box
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 116),
                decoration: BoxDecoration(color: Colors.black.withAlpha(128)),
                child: widget.bottom,
              ),
            ),
          Positioned(
            bottom: 0,
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
      ),
    );
  }
}
