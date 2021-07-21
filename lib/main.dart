import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_flutter/data/weather_manager.dart';
import 'package:weather_app_flutter/l10n/l10n.dart';
import 'package:weather_app_flutter/screens/landing_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const favoritesBox = 'favorite_books';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<List<String>>('favorite_cities');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WeatherManager>(
      create: (context) => WeatherManager(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: L10n.all,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: LandingPage(),
      ),
    );
  }
}
