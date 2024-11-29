import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/screens/search_screen.dart';
import '../widgets/weather.dart';
import '../drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final String? cityName =
        ModalRoute.of(context)!.settings.arguments as String?;
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background_android.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
              preferredSize:
                  const Size.fromHeight(50.0), // here the desired height
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: AppBar(
                  systemOverlayStyle:
                      const SystemUiOverlayStyle(statusBarColor: Colors.black),
                  elevation: 0.0,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/logo_splash.png',
                      width: 140, height: 35, //fit: BoxFit.contain
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        Navigator.of(context).pushNamed(SearchScreen.routeName);
                      },
                      iconSize: 27,
                    ),
                  ],
                  backgroundColor: Colors.transparent,
                ),
              )),
          drawer: const MainDrawer(path: '/'),
          body: Consumer<WeatherProvider>(
              builder: (context, weatherProvider, child) {
            return FutureBuilder(
                future: Provider.of<WeatherProvider>(context, listen: false)
                    .check(context, cityName),
                builder: (ctx, dataSnapshot) {
                  // print(weatherProvider.weatherData);
                  return weatherProvider.weatherData.isNotEmpty
                      ? Weather(weatherData: weatherProvider.weatherData)
                      : const Center(
                          child:
                              CircularProgressIndicator(color: Color.fromARGB(255, 255, 7, 7)));
                });
          })),
    );
  }
}
