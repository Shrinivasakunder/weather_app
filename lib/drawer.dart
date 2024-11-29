import 'package:flutter/material.dart';
import './screens/recents_screen.dart';
import './screens/favourites_screen.dart';

class MainDrawer extends StatefulWidget {
  final String path;

  const MainDrawer({Key? key, this.path = '/'}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  var texts = [
    {
      'title': 'Home',
      'path': '/',
    },
    {
      'title': 'Favourite',
      'path': FavouritesScreen.routeName,
    },
    {
      'title': 'Recent Search',
      'path': RecentsScreen.routeName,
    },
  ];

  int _currentSelected = -1;
  @override
  void initState() {
    super.initState();
    //print('Drawer');
    // Select the item that is currently selected (given the parent)
    var currentText =
        texts.firstWhere((element) => element['path'] == widget.path);
    // Put that in the state (to nicely select the current index)
    _currentSelected = texts.indexOf(currentText);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20),
        child: Column(children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: texts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    texts[index]['title'] as String,
                    style: TextStyle(
                        fontSize: 17,
                        letterSpacing: 0.5,
                        height: 0.36,
                        color: _currentSelected == index
                            ? Colors.black
                            : Colors.grey,
                        fontFamily: 'Roboto Regular'),
                  ),
                  onTap: () {
                    setState(() {
                      _currentSelected = index;
                    });
                    Navigator.of(context)
                        .pushReplacementNamed(texts[index]['path'] as String);
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
