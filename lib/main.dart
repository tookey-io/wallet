import 'dart:async';
import 'dart:developer';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:tookey/deps.dart';
import 'package:tookey/ffi.dart';
import 'package:tookey/pages/auth.page.dart';
import 'package:tookey/pages/keys/keys.page.dart';
import 'package:tookey/state.dart';
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;

Future<void> main() async {
  await dotenv.load();
  final lib = loadLibrary('native');
  api = NativeImpl(lib);
  api.connectLogger().listen((event) {
    log('Rust log: $event');
  });

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final state = AppState();
        // ignore: cascade_invocations
        state.initialize();
        return state;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uri? _initialUri;
  Uri? _currentUri;
  Object? _err;

  StreamSubscription<Uri?>? _streamSubscription;

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
      try {
        final initialUri = await getInitialUri();
        if (initialUri != null) {
          debugPrint('Initial URI received $initialUri');
          if (!mounted) return;
          setState(() => _initialUri = initialUri);
        } else {
          debugPrint('Null Initial URI received');
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
      _streamSubscription = uriLinkStream.listen(
        (Uri? uri) {
          if (!mounted) return;
          debugPrint('Received URI: $uri');
          setState(() {
            _currentUri = uri;
            _err = null;
          });
        },
        onError: (Object err) {
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
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('_initialUri ${_initialUri.toString()}');
    debugPrint('_currentUri ${_currentUri.toString()}');
    if (_err != null) debugPrint('_err ${_err.toString()}');

    const blackPrimaryValue = 0xFF000000;
    const blackMaterial = MaterialColor(blackPrimaryValue, <int, Color>{
      50: Color(blackPrimaryValue),
      100: Color(blackPrimaryValue),
      200: Color(blackPrimaryValue),
      300: Color(blackPrimaryValue),
      400: Color(blackPrimaryValue),
      500: Color(blackPrimaryValue),
      600: Color(blackPrimaryValue),
      700: Color(blackPrimaryValue),
      800: Color(blackPrimaryValue),
      900: Color(blackPrimaryValue),
    });

    var tookeyTheme = FlexThemeData.dark(
      scheme: FlexScheme.custom,
      appBarStyle: FlexAppBarStyle.surface,
      darkIsTrueBlack: true,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tookey Signer',
      darkTheme: tookeyTheme,
      themeMode: ThemeMode.dark,
      theme: FlexThemeData.light(scheme: FlexScheme.custom),
      // ThemeData(
      //   primarySwatch: blackMaterial,
      //   brightness: Brightness.light,
      //   appBarTheme: const AppBarTheme(
      //     titleTextStyle: TextStyle(fontFamily: 'Kodachi', fontSize: 48)
      //   )
      // ),
      home: Consumer<AppState>(
        builder: (context, state, child) {
          if (state.accessToken == null) {
            final pattern = RegExp(r'^tookey:\/\/access\/([0-9a-f]+)$');
            if (pattern.hasMatch(_currentUri.toString())) {
              final apiKey =
                  pattern.firstMatch(_currentUri.toString())!.group(1)!;
              state.signin(apiKey);
            }
            return const AuthPage(title: 'SigneR');
          }
          return const KeysPage(title: 'Keys');
        },
      ),
    );
  }
}
