import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_flutter/data/selected_metric.dart';

const apiKey = '63cb7c28d798621b8255af03e533e064';

class WeatherManager extends ChangeNotifier {
  List<String> favoriteCities = [];
  bool isLoading = true;
  bool isFirstLaunch = true;
  SelectedMetric selectedMetric = SelectedMetric.Celsius;
  late double lat;
  late double lon;
  late String cityName;
  var weatherData;
  var favoriteCitiesBox;

  void toggleMetric(SelectedMetric selectedMetric) {
    switch (selectedMetric) {
      case SelectedMetric.Celsius:
        this.selectedMetric = SelectedMetric.Celsius;
        break;
      case SelectedMetric.Fahrenheit:
        this.selectedMetric = SelectedMetric.Fahrenheit;
        break;
      case SelectedMetric.Kelvin:
        this.selectedMetric = SelectedMetric.Kelvin;
        break;
    }
    notifyListeners();
  }

  Future loadCities() async {
    if (isFirstLaunch) {
      favoriteCitiesBox = Hive.box<List<String>>('favorite_cities');
      this.isFirstLaunch = false;
    }
    if (favoriteCitiesBox.get('cities') != null) {
      this.favoriteCities = favoriteCitiesBox.get('cities');
      notifyListeners();
    }
  }

  void saveCity(String cityName) async {
    var box = Hive.box<List<String>>('favorite_cities');

    if (favoriteCities.contains(cityName)) {
      this.favoriteCities.remove(cityName);
      notifyListeners();
      box.put('cities', favoriteCities);
    } else {
      this.favoriteCities.add(cityName);
      notifyListeners();
      box.put('cities', favoriteCities);
    }
  }

  Future getCityWeather(String cityName) async {
    http.Response response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey'));

    if (response.statusCode == 200) {
      String data = response.body;

      var decodedData = jsonDecode(data);

      updateWeatherData(decodedData);
    } else {
      print(response.statusCode);
    }
  }

  void getLocalisationWeather() async {
    http.Response response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey'));

    if (response.statusCode == 200) {
      String data = response.body;

      var decodedData = jsonDecode(data);

      updateWeatherData(decodedData);
    } else {
      print(response.statusCode);
    }
  }

  Future getLocationAndWeather() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      updatePosition(position.latitude, position.longitude);

      print(position);
      getLocalisationWeather();
    } catch (e) {
      print(e);
    }
  }

  void updatePosition(double lat, double lon) {
    this.lat = lat;
    this.lon = lon;
    notifyListeners();
  }

  void updateWeatherData(var weatcherData) {
    this.weatherData = weatcherData;
    this.isLoading = false;
    notifyListeners();
  }

  void setLoadingState({required bool isLoading}) {
    this.isLoading = isLoading;
    notifyListeners();
  }
}
