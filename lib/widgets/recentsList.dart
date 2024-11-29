import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favourite_provider.dart';
import '../providers/recents_provider.dart';

class RecentsList extends StatefulWidget {
  final int id;
  final String cityName;
  final String country;
  final String icon;
  final String temp;
  final String description;

  const RecentsList({
    required Key key,
    required this.id,
    required this.cityName,
    required this.country,
    required this.icon,
    required this.temp,
    required this.description,
  }) : super(key: key);

  @override
  _RecentsListState createState() => _RecentsListState();
}

class _RecentsListState extends State<RecentsList> {
  @override
  Widget build(BuildContext context) {
    final intTemp = double.parse(widget.temp);
    final cel = (intTemp - 273.15).toInt();
    const nonFavIcon = Icon(Icons.favorite_outline_sharp, color: Colors.white);
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
              'Do you want to remove ${widget.cityName} from recents?',
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
                  Provider.of<RecentsProvider>(context, listen: false)
                      .deleteRecent(widget.cityName);
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
        Provider.of<RecentsProvider>(context, listen: false)
            .deleteRecent(widget.cityName);
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
                  Consumer<FavouriteProvider>(
                      builder: (context, favouritesProvider, child) {
                    return FutureBuilder(
                        future: Provider.of<FavouriteProvider>(context,
                                listen: false)
                            .fetchAndSetFav(),
                        builder: (ctx, dataSnapshot) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: IconButton(
                                onPressed: () {
                                  favouritesProvider.toggleFavourites(
                                      widget.cityName,
                                      widget.country,
                                      widget.icon,
                                      widget.temp,
                                      widget.description);
                                },
                                icon: favouritesProvider.favourites.any(
                                        (element) =>
                                            element['cityName'] ==
                                            widget.cityName)
                                    ? favIcon
                                    : nonFavIcon),
                          );
                        });
                  })
                ],
              ),
            ),
          )),
    );
  }
}
