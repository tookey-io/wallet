import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rust_bridge_template/pages/auth.dart';
import 'package:flutter_rust_bridge_template/pages/key_list.dart';
import 'package:flutter_rust_bridge_template/pages/wallet_connect.dart';
import 'package:flutter_rust_bridge_template/state.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'ffi.dart';
import 'dart:io' as io;

bool _initialUriIsHandled = false;

Future<void> main() async {
  await dotenv.load();
  const base = "native";
  final dylib = io.Platform.isWindows ? '$base.dll' : 'lib$base.so';

  final lib = io.Platform.isIOS || io.Platform.isMacOS
      ? DynamicLibrary.executable()
      : DynamicLibrary.open(dylib);

  api = NativeImpl(lib);

  api.connectLogger().listen((event) {
    log("Rust log: $event");
  });

  runApp(ChangeNotifierProvider(
    create: ((context) {
      final state = AppState();
      state.initialize();
      return state;
    }),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  Uri? _initialUri;
  Uri? _currentUri;
  Object? _err;

  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _initURIHandler();
    _incomingLinkHandler();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  Future<void> _initURIHandler() async {
    // In this example app this is an almost useless guard, but it is here to
    // show we are not going to call getInitialUri multiple times, even if this
    // was a weidget that will be disposed of (ex. a navigation route change).
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      Fluttertoast.showToast(
          msg: "Invoked _initURIHandler",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white);
      try {
        final initialUri = await getInitialUri();
        if (initialUri != null) {
          debugPrint("Initial URI received $initialUri");
          if (!mounted) return;
          setState(() => _initialUri = initialUri);
        } else {
          debugPrint("Null Initial URI received");
        }
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        debugPrint('Failed to receive initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        debugPrint('Malformed Initial URI received');
        setState(() => _err = err);
      }
    }
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _incomingLinkHandler() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        debugPrint('Received URI: $uri');
        setState(() {
          _currentUri = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) return;
        debugPrint('Error occurred: $err');
        setState(() {
          _currentUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('_initialUri ${_initialUri.toString()}');
    debugPrint('_currentUri ${_currentUri.toString()}');
    if (_err != null) debugPrint('_err ${_err.toString()}');

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tookey Signer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<AppState>(builder: (context, state, child) {
          if (state.accessToken == null) {
            final pattern = RegExp(r'^tookey:\/\/access\/([0-9a-f]+)$');
            if (pattern.hasMatch(_currentUri.toString())) {
              final apiKey =
                  pattern.firstMatch(_currentUri.toString())!.group(1)!;
              log("ApiKey is $apiKey");
              state.signin(apiKey);
            }
            return const AuthPage(title: 'Tookey Signer');
          } else {
            return const KeysListPage(title: "Keys");
          }
        }));
  }
}
