import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_flutter/data/weather_manager.dart';
import 'package:weather_app_flutter/screens/home_page.dart';

import 'loading_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<WeatherManager>(context).isLoading == true) {
      return LoadingPage();
    }
    return HomePage();
  }
}
