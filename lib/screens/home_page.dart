import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_flutter/data/selected_metric.dart';
import 'package:weather_app_flutter/data/weather_manager.dart';
import 'package:weather_app_flutter/screens/favorites_page.dart';
import 'package:weather_app_flutter/screens/search_page.dart';
import 'package:weather_app_flutter/services/weather.dart';

class HomePage extends StatelessWidget {
  String calculateCelsius(double temperature) =>
      num.parse((temperature - 273).toStringAsFixed(1)).toString();

  String calculateFahrenheit(double temperature) =>
      num.parse((1.8 * (temperature - 273) + 32).toStringAsFixed(1)).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        leading: IconButton(
          icon: Icon(
            Icons.near_me,
            size: 30,
          ),
          onPressed: () async {
            Provider.of<WeatherManager>(context, listen: false)
                .setLoadingState(isLoading: true);
            await Provider.of<WeatherManager>(context, listen: false)
                .getLocationAndWeather();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
                icon: Icon(
                  Icons.list,
                  size: 35,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FavouritesScreen()));
                }),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Celsius') {
                Provider.of<WeatherManager>(context, listen: false)
                    .toggleMetric(SelectedMetric.Celsius);
              } else if (value == 'Fahrenheit') {
                Provider.of<WeatherManager>(context, listen: false)
                    .toggleMetric(SelectedMetric.Fahrenheit);
              } else if (value == 'Kelvin') {
                Provider.of<WeatherManager>(context, listen: false)
                    .toggleMetric(SelectedMetric.Kelvin);
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Celsius', 'Fahrenheit', 'Kelvin'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.blueGrey,
        child: Center(
          child: SafeArea(
            child: Consumer<WeatherManager>(
              builder: (context, weatherManager, child) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 20.0, left: 40, right: 40),
                            child: Text(
                              weatherManager.weatherData['name'],
                              style: TextStyle(
                                fontSize: 55,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, bottom: 20, left: 40, right: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  decideMetricToDisplay(weatherManager),
                                  style: TextStyle(
                                    fontSize: 45,
                                  ),
                                ),
                                Text(
                                  WeatherModel().getWeatherEmoji(weatherManager
                                      .weatherData['weather'][0]['id']),
                                  style: TextStyle(fontSize: 45),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Align(
                      widthFactor: 6,
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          size: 40,
                        ),
                        color: weatherManager.favoriteCities
                                .contains(weatherManager.weatherData['name'])
                            ? Colors.red
                            : Colors.black,
                        onPressed: () {
                          weatherManager
                              .saveCity(weatherManager.weatherData['name']);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[800],
        elevation: 15,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
        child: Icon(
          Icons.add_location_alt_rounded,
          size: 30,
        ),
      ),
    );
  }

  String decideMetricToDisplay(WeatherManager weatherManager) {
    switch (weatherManager.selectedMetric) {
      case SelectedMetric.Celsius:
        return '${calculateCelsius(weatherManager.weatherData['main']['temp'])} °C ';
      case SelectedMetric.Fahrenheit:
        return '${calculateFahrenheit(weatherManager.weatherData['main']['temp'])}  °F  ';
      case SelectedMetric.Kelvin:
        return '${weatherManager.weatherData['main']['temp']} K  ';
    }
  }
}
