import '../db/dbhelper.dart';

class Weather {
  final String cityName;
  final String country;
  final String icon;
  final String description;
  final String temp;

  Weather(
      {required this.cityName,
      required this.country,
      required this.icon,
      required this.description,
      required this.temp});

  Weather.fromMap(Map<String, dynamic> res)
      : cityName = res["cityName"],
        country = res["country"],
        icon = res['icon'],
        description = res['description'],
        temp = res['temp'];

  Map<String, Object?> toMap() {
    return {
      'cityName': cityName,
      'country': country,
      'icon': icon,
      'description': description,
      'temp': 'temp'
    };
  }
}
