import 'package:community/router/routing_constants.dart';
import 'package:community/service/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'locator/locator.dart';
import 'router/router.dart' as router;


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider.value(value: LocaleProvider()),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          title: '',
          onGenerateRoute: router.generateRoute,
          navigatorKey: locator.get<NavigationService>().navigatorKey,
          initialRoute: splashScreenViewRoute,
          theme: CustomTheme.lightTheme(),
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}
