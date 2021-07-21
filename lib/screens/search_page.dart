import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_flutter/data/weather_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String cityName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                onChanged: (newValue) {
                  cityName = newValue;
                },
              ),
            ),
            TextButton(
              onPressed: () async {
                // change LoadingState
                Provider.of<WeatherManager>(context, listen: false)
                    .setLoadingState(isLoading: true);

                // update WeatherManager data
                Provider.of<WeatherManager>(context, listen: false)
                    .getCityWeather(cityName);

                // pop the page
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context)!.getWeather,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
