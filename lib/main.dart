// ignore_for_file: unused_import

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tookey/deps.dart';
import 'package:tookey/ffi.dart';
import 'package:tookey/pages/auth.page.dart';
import 'package:tookey/pages/keys/keys.page.dart';
import 'package:tookey/pages/sign.test.page.dart';
import 'package:tookey/services/networks.dart';
import 'package:tookey/state.dart';
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  await SentryFlutter.init(
    (options) {
      options
        ..dsn =
            'https://bf7393ade2444f7a8c88e385d8b43ac1@o128657.ingest.sentry.io/4504565247049728'
        // Set tracesSampleRate to 1.0 to capture 100% of transactions
        // for performance monitoring.
        // We recommend adjusting this value in production.
        ..tracesSampleRate = 1.0;
    },
    appRunner: () async {
      FlutterError.onError = Sentry.captureException;
      PlatformDispatcher.instance.onError = (exception, stackTrace) {
        Sentry.captureException(exception, stackTrace: stackTrace);
        return false;
      };

      WidgetsFlutterBinding.ensureInitialized();

      await Sentry.captureException(Exception('Start loading'));

      await dotenv.load();
      final lib = loadLibrary('native');

      await Sentry.captureException(Exception('Lib loaded'));
      api = NativeImpl(lib);
      api.connectLogger().listen((event) {
        log('Rust log: $event');
      });
      await Sentry.captureException(Exception('Api initied'));

      await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp],
      );

      await Sentry.captureException(Exception('Run app'));
      runApp(
        ChangeNotifierProvider(
          create: (context) {
            final state = AppState()..initialize();

            Sentry.captureException(Exception('State initialized'));
            return state;
          },
          child: const MyApp(),
        ),
      );
    },
  );
}

Future<void> initSentry() async {}

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

    Sentry.captureException(Exception('Run app task exception'));
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
    final networks =
        DefaultAssetBundle.of(context).loadString('assets/networks.json');
    debugPrint('_initialUri $_initialUri');
    debugPrint('_currentUri $_currentUri');
    if (_err != null) debugPrint('_err $_err');

    final tookeyTheme = FlexThemeData.dark(
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
        builder: (context, state, child) => FutureBuilder<String>(
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              final jsonList = jsonDecode(snapshot.data!) as List<dynamic>;
              state.addNetworks(
                jsonList
                    .map((e) => Network.fromJson(e as Map<String, dynamic>)),
              );

              // ignore: lines_longer_than_80_chars
              log('netowrks: ${state.networks.map((e) => e.toString()).join('\n')}');

              // return const SignTest(title: 'Test sign');

              if (state.refreshToken == null) {
                final pattern = RegExp(r'^tookey:\/\/access\/([0-9a-f]+)$');
                if (pattern.hasMatch(_currentUri.toString())) {
                  final apiKey =
                      pattern.firstMatch(_currentUri.toString())!.group(1)!;
                  state.signin(apiKey);
                }
                return const AuthPage(title: 'Signer');
              } else {
                return const KeysPage(title: 'Keys');
              }
            } else {
              return const Text('Loading networks');
            }
          },
          future: networks,
        ),
      ),
    );
  }
}
