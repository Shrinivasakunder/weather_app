import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/favourite_provider.dart';

class FavouriteList extends StatefulWidget {
  final int id;
  final String cityName;
  final String country;
  final String icon;
  final String temp;
  final String description;

  const FavouriteList(
      {required Key key,
      required this.id,
      required this.cityName,
      required this.country,
      required this.icon,
      required this.temp,
      required this.description})
      : super(key: key);

  @override
  _FavouriteListState createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  @override
  Widget build(BuildContext context) {
    final intTemp = double.parse(widget.temp);
    final cel = (intTemp - 273.15).toInt();
    const favIcon =
        Icon(Icons.favorite_rounded, color: Color.fromRGBO(255, 229, 57, 0.8));

    String capitalize(str) {
      return "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}";
    }

    final desc = capitalize(widget.description);

    return Dismissible(
      key: ValueKey(widget.cityName),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
              'Do you want to remove ${widget.cityName} from favourites?',
            ),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                style: TextButton.styleFrom(
                    foregroundColor: Color.fromRGBO(103, 58, 183, 1),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Provider.of<FavouriteProvider>(context, listen: false)
                      .delete(widget.cityName);
                  Navigator.of(ctx).pop(true);
                },
                style: TextButton.styleFrom(
                    foregroundColor: Color.fromRGBO(103, 58, 183, 1),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<FavouriteProvider>(context, listen: false)
            .delete(widget.cityName);
      },
      direction: DismissDirection.endToStart,
      child: Container(
          color: const Color.fromRGBO(255, 255, 255, 0.2),
          child: Card(
            color: Colors.transparent,
            elevation: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.cityName}, ${widget.country}',
                          style: const TextStyle(
                              color: Color.fromRGBO(255, 229, 57, 1),
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.network(
                            'https://openweathermap.org/img/wn/${widget.icon}@2x.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                          Text('${cel}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700)),
                          const Text('°c    ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                              )),
                          Text('${desc}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ))
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: IconButton(onPressed: () {}, icon: favIcon),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
