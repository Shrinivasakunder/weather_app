// ignore: file_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class BottomListView extends StatelessWidget {
  const BottomListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherData = Provider.of<WeatherProvider>(context).weatherData;

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final height = (MediaQuery.of(context).size.height -
        50 -
        MediaQuery.of(context).padding.top);
    final tempMax = weatherData['main']['temp_max'];
    final tempMin = weatherData['main']['temp_min'];
    final precipitation = weatherData['clouds']['all'];
    final humidity = weatherData['main']['humidity'];
    final windspeed = weatherData['wind']['speed'];
    final visibility = (weatherData['visibility'] / 1000).toInt();
    final Min = (tempMin - 273.15).toInt();
    final Max = (tempMax - 273.15).toInt();
    final titleStyle = TextStyle(
      color: Colors.white,
      fontSize: 15,
    );
    final subTitleStyle =
        TextStyle(color: Colors.white, fontSize: 18, height: 1.5);
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.3, color: Colors.white),
          ),
          color: Color.fromRGBO(255, 255, 255, 0.2),
        ),
        height: isLandscape ? height * 0.35 : null,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: kIsWeb ? MediaQuery.of(context).size.width : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 150,
                  //height: 150,
                  child: ListTile(
                    leading: Image.asset('assets/icon_temperature_info.png',
                        height: 33, fit: BoxFit.fitHeight),
                    title: Text(
                      'Min-Max',
                      style: titleStyle,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                    ),
                    subtitle: Text('$Min°-$Max°',
                        style: subTitleStyle,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.visible),
                    horizontalTitleGap: 0.0,
                    minLeadingWidth: 40,
                  ),
                ),
                //Expanded(child: Container()),
                SizedBox(
                  width: 180,
                  //height: 150,
                  child: ListTile(
                    leading: Image.asset('assets/icon_precipitation_info.png',
                        height: 33, fit: BoxFit.fitHeight),
                    title: Text('Precipitation',
                        style: titleStyle,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.visible),
                    subtitle: Text('$precipitation%',
                        style: subTitleStyle,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.visible),
                    horizontalTitleGap: 10.0,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: ListTile(
                    leading: Image.asset('assets/icon_humidity_info.png',
                        height: 33, fit: BoxFit.fitHeight),
                    title: Text('Humidity',
                        style: titleStyle,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.visible),
                    subtitle: Text('$humidity%',
                        style: subTitleStyle,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.visible),
                    horizontalTitleGap: 0.0,
                  ),
                ),
                SizedBox(
                  width: 170,
                  child: ListTile(
                    leading: Image.asset('assets/icon_visibility_info.png',
                        height: 33, fit: BoxFit.fitHeight),
                    title: Text('Visibilty',
                        style: titleStyle,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.visible),
                    subtitle: Text('$visibility%',
                        style: subTitleStyle,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.visible),
                    horizontalTitleGap: 15.0,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: ListTile(
                    leading: Image.asset('assets/icon_wind_info.png',
                        height: 33, fit: BoxFit.fitHeight),
                    title: Text('Wind Speed',
                        style: titleStyle,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.visible),
                    subtitle: Text('$windspeed%',
                        style: subTitleStyle,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.visible),
                    horizontalTitleGap: 15.0,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
