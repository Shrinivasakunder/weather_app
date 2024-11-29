import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../db/dbhelper.dart';

import 'dart:convert';

class WeatherProvider with ChangeNotifier {
  final dbHelper = DatabaseHelper.instance;

  Map<String, dynamic> _weatherData = {};

  Map<String, dynamic> get weatherData {
    return {..._weatherData};
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    try {
      permission = await Geolocator.checkPermission();
    } catch (e) {
      print('Error checking permission: $e');
      return Future.error('Failed to check location permissions');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var locator = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return locator;
  }

  Future<void> setLatlong(context) async {
    Position position = await _getGeoLocationPosition();

    try {
      await Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeatherByCoords(position.latitude, position.longitude);
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchWeatherByCoords(lat, long) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=baafadf469f4805a3127eb7e4f5f4c06');
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        print('ohhhhhhh noooo');
      }
      final extractedData = json.decode(response.body);

      _weatherData = extractedData;
      notifyListeners();
    } catch (error) {
      rethrow;
    }

    notifyListeners();
  }

  Future<void> check(context, cityName) async {
    if (_weatherData.isEmpty) {
      await setLatlong(context);
    } else {
      if (cityName != null) {
        await fetchWeatherByCityName(cityName, context);
      }
    }
  }

  Future<void> fetchWeatherByCityName(cityName, context) async {
    print('I\'m getting called');
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=baafadf469f4805a3127eb7e4f5f4c06');
    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        print('City not found');
        throw Exception();
      }
      final extractedData = json.decode(response.body);
      _weatherData = extractedData;

      notifyListeners();
    } catch (error) {
      rethrow;
    }

    notifyListeners();
  }
}
