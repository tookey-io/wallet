import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:appcheck/appcheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tookey/services/qr_scanner.dart';
import 'package:tookey/state.dart';
import 'package:tookey/widgets/toaster.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.title});

  final String title;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool authenticating = false;

  Future<void> _onQrData(AppState state, String raw) async {
    log('Got a data $raw');
    final pattern = RegExp(r'^tookey:\/\/access\/([0-9a-f]+)$');

    if (!pattern.hasMatch(raw)) {
      return Toaster.error('QR is incorrect', gravity: ToastGravity.CENTER);
    }

    final apiKey = pattern.firstMatch(raw)!.group(1)!;
    log('ApiKey is $apiKey');

    await state.signin(apiKey).catchError((dynamic error) {
      if (error is TimeoutException) {
        return Toaster.error(
          'Request Timeout',
          gravity: ToastGravity.BOTTOM,
          time: 10,
        );
      }
    });

    // if (mounted) Navigator.pop(context);
  }

  Future<void> _onTelegramSignin(AppState state) async {
    if (dotenv.env['TEST_ENV'] != null) return state.signin('');

    final bot = dotenv.env['TELEGRAM_BOT'];

    if (Platform.isAndroid) {
      final installedApps = await AppCheck.getInstalledApps();
      debugPrint(installedApps.toString());

      final appLink = 'tg://resolve?domain=$bot&start=YXBwPWF1dGg';
      // final appLink = 'https://t.me/$bot?start=YXBwPWF1dGg';
      final url = Uri.parse(appLink);
      log('Launch $url');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication)
            .catchError((dynamic err) async {
          debugPrint(err.toString());
          await Toaster.error(
            'Cannot launch url: ${url.toString()}',
            gravity: ToastGravity.BOTTOM,
          );
        });
      } else {
        await Toaster.error(
          'Cannot open url: ${url.toString()}',
          gravity: ToastGravity.BOTTOM,
        );
      }
      // await AppCheck.launchApp(appLink).catchError((err) {
      //   Toaster.error('Telegram not found!', gravity: ToastGravity.BOTTOM);
      // });
    }

    if (Platform.isIOS) {
      final package = Platform.isIOS ? 'tg://' : 'org.telegram.messenger';
      final app = await AppCheck.checkAvailability(package);
      if (app?.packageName != null) {
        final appLink = 'tg://resolve?domain=$bot&start=YXBwPWF1dGg';
        await AppCheck.launchApp(appLink).catchError((err) {
          Toaster.error('Telegram not found!', gravity: ToastGravity.BOTTOM);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
    return Consumer<AppState>(
      builder: (context, state, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              TextButton(
                style: style,
                onPressed: () {},
                child: const Icon(Icons.more_horiz_outlined),
              ),
            ],
          ),
          body: Consumer<AppState>(
            builder: (context, state, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Spacer(),
                    const Icon(
                      Icons.phonelink_lock,
                      size: 96,
                      color: Colors.grey,
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    const Text(
                      'Authenticate',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Container(
                      padding: const EdgeInsets.all(30),
                      child: const Text(
                        textAlign: TextAlign.center,
                        'Simly use this button\n to authenticate with telegram',
                      ),
                    ),
                    ElevatedButton(
                      child: const Text('Sign with Telegram'),
                      onPressed: () => _onTelegramSignin(state),
                    ),
                    const Spacer(),
                    const Text(
                      'or type /auth to telegram bot\nand scan connection QR code',
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 1.3, color: Colors.grey),
                    ),
                    const SizedBox(height: 40)
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Container(height: 45),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Scan QR',
            child: const Icon(Icons.qr_code_scanner),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<QRScanner>(
                builder: (context) {
                  return QRScanner(onData: (raw) => _onQrData(state, raw));
                },
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
