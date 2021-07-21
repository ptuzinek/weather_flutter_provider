class WeatherModel {
  String getWeatherEmoji(int condition) {
    if (condition < 300) {
      return '⛈️';
    } else if (condition < 400) {
      return '☂️';
    } else if (condition < 600) {
      return '🌧️';
    } else if (condition < 700) {
      return '🌨️';
    } else if (condition < 800) {
      return '🌫️';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition == 801 || condition == 802) {
      return '⛅';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '';
    }
  }
}
