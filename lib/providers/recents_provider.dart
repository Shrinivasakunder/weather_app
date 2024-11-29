import 'package:flutter/material.dart';
import '../model/weather.dart';
import '../db/dbhelper.dart';

class RecentsProvider with ChangeNotifier {
  List _recents = [];
  List get recents => [..._recents];

  Future<void> fetchAndSetRecents() async {
    final data = await DatabaseHelper.instance.queryAllRowsRecent();

    _recents = [...data];
    notifyListeners();
  }

  void insertRecent(weather) async {
    final index = _recents
        .indexWhere((element) => element['cityName'] == weather['name']);
    if (index >= 0) {
      return;
    } else {
      final newCity = {
        'cityName': weather['name'],
        'country': weather['sys']['country'],
        'icon': weather['weather'][0]['icon'],
        'temp': (weather['main']['temp']).toString(),
        'description': weather['weather'][0]['description']
      };
      _recents.add(newCity);

      notifyListeners();
    }
    Map<String, dynamic> row = {
      DatabaseHelper.columnCityName: weather['name'],
      DatabaseHelper.columnCountry: weather['sys']['country'],
      DatabaseHelper.columnIcon: weather['weather'][0]['icon'],
      DatabaseHelper.columnTemp: (weather['main']['temp']).toString(),
      DatabaseHelper.columnDescription: weather['weather'][0]['description'],
    };
    Weather weath = Weather.fromMap(row);
    try {
      var result = await DatabaseHelper.instance.insertRecent(weath);
    } catch (error) {
      print(error);
    }
  }

  void deleteRecent(cityName) async {
    final index =
        _recents.indexWhere((element) => element['cityName'] == cityName);
    if (index >= 0) {
      _recents.removeAt(index);
      notifyListeners();
    }
    var result = await DatabaseHelper.instance.deleteRecent(cityName);
  }

  dynamic deleteAllRecents() async {
    _recents = [];
    notifyListeners();
    var result = await DatabaseHelper.instance.deleteAllRecents();
  }
}
