import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:community/helpers/shared_preferences.dart';
import 'package:community/provider/custom_provider.dart';
import 'package:community/router/routing_constants.dart';
import 'package:community/screens/home/view/home.dart';
import 'package:community/service/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'locator/locator.dart';
import 'router/router.dart' as router;

import 'config/theme.dart';


// Called when Doing Background Work initiated from Widget
FutureOr<void> backgroundCallback(Uri? uri) async {
  await HomeWidget.updateWidget(name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocator();

  if (Platform.isAndroid) {
    await MediaStore.ensureInitialized();
    final mediaStorePlugin = MediaStore();
    List<Permission> permissions = [
      Permission.storage,
    ];

    if ((await mediaStorePlugin.getPlatformSDKInt()) >= 33) {
      permissions.add(Permission.photos);
      permissions.add(Permission.audio);
      permissions.add(Permission.videos);
    }

    await permissions.request();
    // You have set this otherwise it throws AppFolderNotSetException
    MediaStore.appFolder = "MediaStorePlugin";
  }

  bool? login = await getLoggedIn();
  await Hive.initFlutter();
  if (login == null) {
    runApp(const MyApp(
      login: false,
    ));
  } else {
    runApp(MyApp(
      login: login,
    ));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.login});
  final bool login;
  @override
  State<MyApp> createState() => _MyAppState(login: login);
}

class _MyAppState extends State<MyApp> {
  _MyAppState({required this.login});
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;
  final _navKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    if (login) {
      initAppLinks();
    }
  }


  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> updateAppWidget() async {
    await HomeWidget.updateWidget(name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
  }


  Future<void> initAppLinks() async {
    // Create an instance of AppLinks
    _appLinks = AppLinks();

    // Handle the initial deep link if the app is closed
    try {
      final Uri? initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink.toString());
      }
    } catch (e) {
      print('Failed to get initial link: $e');
    }

    // Listen for incoming deep links while the app is open
    _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri.toString());
      }
    }, onError: (err) {
      print('Failed to handle deep link: $err');
    });
  }

  void _handleDeepLink(String link) {
    if (link == 'myapp://widget_screen') {
      _navKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
            (Route<dynamic> route) => false, // Remove all previous routes
      );
    }
  }

  final bool login;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: CustomProvider()),
        ],
      child: GetMaterialApp(
        title: '',
        onGenerateRoute: router.generateRoute,
        navigatorKey: locator.get<NavigationService>().navigatorKey,
        initialRoute: login == true ? homeScreenViewRoute : baseUrl,
        theme: CustomTheme.lightTheme(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
      ),
    );
  }
}
