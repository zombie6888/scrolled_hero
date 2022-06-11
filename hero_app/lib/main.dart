import 'package:flutter/material.dart';
import 'package:hero_app/scrolled_hero.dart';

import 'preview_modal_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      //navigatorObservers: [c.CustomHeroController()],
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const double appBarHeight = 100;
const double tapBarHeight = 100;

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List _children = const [Page1(), Page2()];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(appBarHeight),
        child: AppBar(
          title: const Text('Scrolled hero demo'),
        ),
      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: SizedBox(
        height: tapBarHeight,
        child: BottomNavigationBar(
          onTap: onTabTapped, // new
          currentIndex: _currentIndex, // new
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'fixed hero'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'default hero')
          ],
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (context, index) => GestureDetector(
            onTap: () => Navigator.of(context)
                    .push(PreviewModalRoute(builder: (BuildContext context) {
                  return ScrolledHero(
                      topOffset: appBarHeight,
                      bottomOffset: tapBarHeight,
                      tag: 'kitty-$index',
                      child: Image.asset('assets/kitty.jpg'));
                })),
            child: SizedBox(
                //padding: const EdgeInsets.all(20),
                height: 400,
                width: 400,
                child: ScrolledHero(
                    topOffset: appBarHeight,
                    bottomOffset: tapBarHeight,
                    tag: 'kitty-$index',
                    child: Image.asset('assets/kitty.jpg')))),
        itemCount: 10);
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (context, index) => GestureDetector(
            onTap: () => Navigator.of(context)
                    .push(PreviewModalRoute(builder: (BuildContext context) {
                  return Hero(
                      tag: 'kitty-$index',
                      child: Image.asset('assets/kitty.jpg'));
                })),
            child: SizedBox(
                //padding: const EdgeInsets.all(20),
                height: 400,
                width: 400,
                child: Hero(
                    tag: 'kitty-$index',
                    child: Image.asset('assets/kitty.jpg')))),
        itemCount: 10);
  }
}
