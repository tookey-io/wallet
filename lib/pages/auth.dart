import 'dart:developer';
import 'dart:io';

import 'package:appcheck/appcheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rust_bridge_template/pages/qr_scanner.dart';
import 'package:flutter_rust_bridge_template/state.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  final String title;

  const AuthPage({Key? key, required this.title}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Consumer<AppState>(builder: (context, state, child) {
          return Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Spacer(),
              const Icon(Icons.phonelink_lock, size: 96, color: Colors.grey),
              const Padding(padding: EdgeInsets.all(10)),
              const Text("Authenticate",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Padding(padding: EdgeInsets.all(5)),
              Container(
                padding: const EdgeInsets.all(30),
                child: const Text(
                    textAlign: TextAlign.center,
                    "Simly use this button\n to authenticate with telegram bot"),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (dotenv.env['TEST_ENV'] != null) {
                      state.signin("");
                    } else {
                      if (Platform.isIOS) {
                        var app = await AppCheck.checkAvailability('tg://');
                        if (app?.packageName != null) {
                          var appLink =
                              "${app!.packageName}resolve?domain=${dotenv.env['TELEGRAM_BOT']}&start=YXBwPWF1dGg";
                          AppCheck.launchApp(appLink).catchError((err) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "${app.appName ?? app.packageName} not found!"),
                            ));
                          });
                        }
                      } else if (Platform.isAndroid) {
                        //
                      }
                    }
                  },
                  child: const Text('Sign with Telegram')),
              const Spacer(),
              const Text(
                "or type /auth to telegram bot\nand scan connection QR code",
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.3, color: Colors.grey),
              ),
              const SizedBox(height: 40)
            ],
          ));
        }),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(height: 45.0),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Scan QR",
          child: const Icon(Icons.qr_code_scanner),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return QRScanner(
                  onData: (raw) {
                    log("Got a data $raw");
                    final pattern = RegExp(r'^tookey:\/\/access\/([0-9a-f]+)$');
                    if (pattern.hasMatch(raw)) {
                      final apiKey = pattern.firstMatch(raw)!.group(1)!;
                      log("ApiKey is $apiKey");
                      state.signin(apiKey);
                      Navigator.pop(context);
                    }
                  },
                );
              }),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    });
  }
}
