import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../screens/search_screen.dart';
import '../widgets/favouriteList.dart';
import '../providers/favourite_provider.dart';
import '../db/dbhelper.dart';

import '../drawer.dart';

class FavouritesScreen extends StatefulWidget {
  static const routeName = '/favourites-screen';
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final dbHelper = DatabaseHelper.instance;

  Future<dynamic> ShowDialog(method) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: const Text('Are you sure want to remove all the favourites?',
            style: TextStyle(fontSize: 18)),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
            style: TextButton.styleFrom(
                foregroundColor: const Color.fromRGBO(103, 58, 183, 1),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(ctx).pop(true);
              method();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromRGBO(103, 58, 183, 1),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget upperPart(total, method) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$total City added as favourite ',
              style: const TextStyle(color: Colors.white, fontSize: 15)),
          TextButton(
              onPressed: () => ShowDialog(method),
              child: const Text('Remove All',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)))
        ],
      ),
    );
  }

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarColor: Colors.black),
      leading: Builder(builder: (ctx) {
        return IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () => displayDrawer(ctx),
          iconSize: 27,
          color: Colors.black,
        );
      }),
      title: Container(
        alignment: Alignment.centerLeft,
        child: const Text(
          'Favourite',
          style: TextStyle(color: Colors.black),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.of(context).pushNamed(SearchScreen.routeName);
          },
          iconSize: 27,
          color: Colors.black,
        ),
      ],
      backgroundColor: Colors.white,
    );

    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background_android.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        drawer: const MainDrawer(
          path: FavouritesScreen.routeName,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              FutureBuilder(
                  future: Provider.of<FavouriteProvider>(context, listen: false)
                      .fetchAndSetFav(),
                  builder: (ctx, dataSnapshot) {
                    return Consumer<FavouriteProvider>(
                        builder: (context, favouritesProvider, child) {
                      return favouritesProvider.favourites.isEmpty
                          ? const EmptyContainer()
                          : Expanded(
                              child: Column(
                                children: [
                                  upperPart(
                                    favouritesProvider.favourites.length,
                                    () => favouritesProvider.deleteAll(),
                                  ),
                                  FavListView(
                                    favoritesData: favouritesProvider,
                                  ),
                                ],
                              ),
                            );
                    });
                  })
            ]),
          ),
        ),
      ),
    );
  }
}

class FavListView extends StatelessWidget {
  final favoritesData;
  const FavListView({Key? key, required this.favoritesData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: favoritesData.favourites.length,
          itemBuilder: (ctx, i) => Container(
                margin: const EdgeInsets.symmetric(vertical: 0.8),
                child: FavouriteList(
                    cityName: favoritesData.favourites[i]['cityName'],
                    country: favoritesData.favourites[i]['country'],
                    icon: favoritesData.favourites[i]['icon'],
                    temp: favoritesData.favourites[i]['temp'],
                    description: favoritesData.favourites[i]['description'],
                    id: i,
                    key: ValueKey(i)),
              )),
    );
  }
}

class EmptyContainer extends StatelessWidget {
  const EmptyContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/icon_nothing.png',
              width: 180, height: 100, fit: BoxFit.contain),
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Text('No Favourites added',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                )),
          )
        ],
      )),
    );
  }
}
