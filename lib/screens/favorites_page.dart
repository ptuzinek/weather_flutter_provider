import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_flutter/data/weather_manager.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
      ),
      body: ListView.builder(
        itemCount: Provider.of<WeatherManager>(context).favoriteCities.length,
        itemBuilder: (context, index) => ListTile(
          title:
              Text(Provider.of<WeatherManager>(context).favoriteCities[index]),
          onTap: () async {
            Provider.of<WeatherManager>(context, listen: false)
                .setLoadingState(isLoading: true);

            Provider.of<WeatherManager>(context, listen: false).getCityWeather(
                Provider.of<WeatherManager>(context, listen: false)
                    .favoriteCities[index]);

            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
