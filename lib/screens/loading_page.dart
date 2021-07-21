import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_flutter/data/weather_manager.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  void launchAppData() async {
    if (Provider.of<WeatherManager>(context, listen: false).isFirstLaunch ==
        true) {
      await Provider.of<WeatherManager>(context, listen: false)
          .getLocationAndWeather();
      await Provider.of<WeatherManager>(context, listen: false).loadCities();
    }
  }

  @override
  void initState() {
    super.initState();
    launchAppData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey,
        child: Center(
          child: CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(Colors.grey.shade800)),
        ),
      ),
    );
  }
}
