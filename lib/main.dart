import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recents_provider.dart';
import '../providers/favourite_provider.dart';

import '../providers/weather_provider.dart';
import './screens/favourites_screen.dart';
import './screens/recents_screen.dart';
import './screens/search_screen.dart';
import './screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => WeatherProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FavouriteProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => RecentsProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
            //primarySwatch: Colors.blue,
            ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => const HomeScreen(),
          FavouritesScreen.routeName: (ctx) => const FavouritesScreen(),
          RecentsScreen.routeName: (ctx) => const RecentsScreen(),
          SearchScreen.routeName: (ctx) => const SearchScreen(),
        },
      ),
    );
  }
}
