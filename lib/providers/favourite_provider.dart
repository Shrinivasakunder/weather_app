import 'package:flutter/material.dart';
import '../model/weather.dart';
import '../db/dbhelper.dart';

class FavouriteProvider with ChangeNotifier {
  List _favourites = [];
  List get favourites => [..._favourites];

  Future<void> fetchAndSetFav() async {
    final data = await DatabaseHelper.instance.queryAllRows();

    _favourites = [...data];
    notifyListeners();
  }

  void _insert(name, country, icon, temp, description) async {
    final newCity = {
      'cityName': name,
      'country': country,
      'icon': icon,
      'temp': temp.toString(),
      'description': description
    };
    _favourites.add(newCity);
    notifyListeners();
    Map<String, dynamic> row = {
      DatabaseHelper.columnCityName: name,
      DatabaseHelper.columnCountry: country,
      DatabaseHelper.columnIcon: icon,
      DatabaseHelper.columnTemp: temp.toString(),
      DatabaseHelper.columnDescription: description,
    };
    Weather weath = Weather.fromMap(row);
    try {
      var result = await DatabaseHelper.instance.insert(weath);
    } catch (error) {
      print('Exist');
    }
  }

  void delete(cityName) async {
    final index =
        _favourites.indexWhere((element) => element['cityName'] == cityName);
    _favourites.removeAt(index);
    notifyListeners();
    try {
      var result = await DatabaseHelper.instance.delete(cityName);
    } catch (e) {}
    print('Deleted');
  }

  void toggleFavourites(name, country, icon, temp, description) async {
    final index =
        _favourites.indexWhere((element) => element['cityName'] == name);
    if (index >= 0) {
      delete(name);
    } else {
      _insert(name, country, icon, temp, description);
    }
  }

  dynamic deleteAll() async {
    _favourites = [];
    notifyListeners();
    var result = await DatabaseHelper.instance.deleteAll();
    print(' $result,rows deleted');
  }
}
