import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import '../providers/favourite_provider.dart';
import '../widgets/bottomListView.dart';

class Weather extends StatefulWidget {
  final weatherData;
  const Weather({Key? key, this.weatherData}) : super(key: key);

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  String day = DateFormat('E').format(DateTime.now());
  String time = DateFormat('hh:mm a').format(DateTime.now());
  String date = DateFormat('dd LLL yyyy').format(DateTime.now());
  String curUnit = 'C';
  final favText = 'Added to favourite ';
  final nonFavText = 'Add to favourite';
  final nonFavIcon =
      const Icon(Icons.favorite_outline_sharp, color: Colors.white);
  final favIcon = const Icon(Icons.favorite_rounded, color: Colors.orange);

  String capitalize(str) {
    return "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}";
  }

  List<Widget> details(imageIcon, temp, String description) {
    return [
      const SizedBox(
        height: 30,
      ),
      Image.network(
        'https://openweathermap.org/img/wn/$imageIcon@2x.png',
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            temp.toString(),
            style: const TextStyle(
              fontSize: 54,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                curUnit = 'C';
              });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 7),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  color: curUnit == 'C' ? Colors.white : null),
              child: Text(
                '°C',
                style: TextStyle(
                    color: curUnit == 'C'
                        ? const Color.fromRGBO(227, 40, 67, 1)
                        : Colors.white,
                    fontSize: 18),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                curUnit = 'F';
              });
            },
            child: Container(
                margin: const EdgeInsets.only(top: 7),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    color: curUnit == 'F' ? Colors.white : null),
                child: Text(
                  '°F',
                  style: TextStyle(
                      color: curUnit == 'F'
                          ? const Color.fromRGBO(227, 40, 67, 1)
                          : Colors.white,
                      fontSize: 18),
                )),
          )
        ],
      ),
      const SizedBox(
        height: 14,
      ),
      Text(
        description.split(' ').map((str) {
          return str[0].toUpperCase() + str.substring(1) + ' ';
        }).join(''),
        style: const TextStyle(color: Colors.white, fontSize: 21),
        textAlign: TextAlign.center,
      ),
    ];
  }

  Widget favButton(weatherData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer<FavouriteProvider>(
            builder: (context, favouritesProvider, child) {
          return FutureBuilder(
              future: Provider.of<FavouriteProvider>(context, listen: false)
                  .fetchAndSetFav(),
              builder: (ctx, dataSnapshot) {
                return Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        favouritesProvider.toggleFavourites(
                            weatherData['name'],
                            weatherData['sys']['country'],
                            weatherData['weather'][0]['icon'],
                            weatherData['main']['temp'],
                            weatherData['weather'][0]['description']);
                      },
                      icon: favouritesProvider.favourites.any((element) =>
                              element['cityName'] == weatherData['name'])
                          ? favIcon
                          : nonFavIcon,
                      iconSize: 25,
                    ),
                    Text(
                      favouritesProvider.favourites.any((element) =>
                              element['cityName'] == weatherData['name'])
                          ? favText
                          : nonFavText,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ],
                );
              });
        })
      ],
    );
  }

  Widget upperPart(cityName, country, image, curTemp, String description,
      isLandscape, height, weatherData) {
    return SizedBox(
      height: kIsWeb
          ? null
          : isLandscape
              ? height * 1.6
              : null,
      child: Column(
        children: [
          mainContent(
              cityName, country, weatherData, image, curTemp, description),
        ],
      ),
    );
  }

  Column mainContent(
      cityName, country, weatherData, image, curTemp, String description) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 70, right: 70, top: 70),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              '${day.toUpperCase().substring(0, 3)}, ${date.toUpperCase()}    $time',
              style: const TextStyle(
                color: Color.fromARGB(255, 233, 230, 230),
                fontSize: 15,
                letterSpacing: 1.5,
                //height: 0.15
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 15),
          child: Text(
            '$cityName, $country',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 0.3,
                height: 0.21,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        favButton(weatherData),
        ...details(image, curTemp, description),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final weatherData = widget.weatherData;
    print(weatherData);
    final cityName = weatherData['name'];
    final country = weatherData['sys']['country'];
    final image = weatherData['weather'][0]['icon'];
    final String description = weatherData['weather'][0]['description'];
    final temp = weatherData['main']['temp'];
    final cel = (temp - 273.15).toInt();
    final fah = ((((temp - 273) * 9) / 5) + 32).toInt();
    final curTemp = curUnit == 'C' ? cel : fah;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final height = (MediaQuery.of(context).size.height -
        50 -
        MediaQuery.of(context).padding.top);
    // final isFavourite = isFav(weatherData);

    Widget renderPortrait() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 5,
              child: upperPart(cityName, country, image, curTemp, description,
                  isLandscape, height, weatherData)),
          const Expanded(flex: 1, child: BottomListView())
        ],
      );
    }

    Widget renderWeb() {
      return Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      upperPart(cityName, country, image, curTemp, description,
                          isLandscape, height, weatherData),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: double.infinity, child: BottomListView())
        ],
      );
    }

    Widget renderLandscape() {
      return SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          upperPart(cityName, country, image, curTemp, description, isLandscape,
              height, weatherData),
          const BottomListView()
        ],
      ));
    }

    return kIsWeb
        ? renderWeb()
        : isLandscape
            ? renderLandscape()
            : renderPortrait();
  }
}
