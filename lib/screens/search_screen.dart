import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/recents_provider.dart';
import 'package:weather_app/providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search-screen';
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _onSubmit(context) async {
    var result;
    if (_controller.text.isEmpty) {
      return;
    }
    try {
      await Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeatherByCityName(_controller.text, context);
      result = Provider.of<WeatherProvider>(context, listen: false).weatherData;
      Provider.of<RecentsProvider>(context, listen: false).insertRecent(result);
    } catch (error) {
      //print('Not found this');
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Alert!!"),
            content: Text("No city found with name ${_controller.text}"),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Navigator.popAndPushNamed(context, '/', arguments: _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search for City',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          autofocus: true,
          controller: _controller,
          onSubmitted: (_) => _onSubmit(context),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_sharp,
                color: Colors.black, size: 25)),
      ),
      body: Container(),
    );
  }
}
