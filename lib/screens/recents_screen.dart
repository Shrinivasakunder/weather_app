import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../screens/search_screen.dart';
import '../widgets/recentsList.dart';
import '../providers/recents_provider.dart';
import '../drawer.dart';

class RecentsScreen extends StatelessWidget {
  static const routeName = '/recents-screen';
  const RecentsScreen({Key? key}) : super(key: key);

  Future<dynamic> ShowDialog(method, context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: const Text('Are you sure want to remove all the recents ?',
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

  Widget upperPart(method, context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('You recently searched for',
              style: TextStyle(color: Colors.white, fontSize: 15)),
          TextButton(
              onPressed: () => ShowDialog(method, context),
              child: const Text('Clear All',
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
          'Recent Search',
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
          drawer: MainDrawer(path: routeName),
          body: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder(
                        future:
                            Provider.of<RecentsProvider>(context, listen: false)
                                .fetchAndSetRecents(),
                        builder: (ctx, dataSnapshot) {
                          return Consumer<RecentsProvider>(
                              builder: (context, recentsProvider, child) {
                            return recentsProvider.recents.isEmpty
                                ? const EmptyContainer()
                                : Expanded(
                                    child: Column(
                                      children: [
                                        upperPart(
                                            () => recentsProvider
                                                .deleteAllRecents(),
                                            context),
                                        RecentListView(
                                          recentsData: recentsProvider,
                                        ),
                                      ],
                                    ),
                                  );
                          });
                        })
                  ]),
            ),
          ),
        ));
  }
}

class RecentListView extends StatelessWidget {
  final recentsData;
  const RecentListView({Key? key, required this.recentsData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List result = recentsData.recents;
    final reversedList = result.reversed.toList();
    return Expanded(
      child: ListView.builder(
        itemCount: reversedList.length,
        itemBuilder: (ctx, i) => Container(
          margin: const EdgeInsets.symmetric(vertical: 0.8),
          child: RecentsList(
              cityName: reversedList[i]['cityName'],
              country: reversedList[i]['country'],
              icon: reversedList[i]['icon'],
              temp: reversedList[i]['temp'],
              description: reversedList[i]['description'],
              id: i,
              key: ValueKey(i)),
        ),
      ),
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
            child: Text('No Recent Search',
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
