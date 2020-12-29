import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GIF That Feeling!',
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
        primarySwatch: Colors.indigo,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainContainer(),
      // home: MyHomePage(title: 'Flutter  Home Page'),
    );
  }
}

class MainContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
            body: Column(
      children: <Widget>[
        titleSection,
        Expanded(flex: 5, child: ParentContainer())
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
    )));
  }
}

class ParentContainer extends StatefulWidget {
  @override
  _ParentContainerState createState() => _ParentContainerState();
}

class _ParentContainerState extends State<ParentContainer> {
  String _searchText = '';
  bool _loading = false;

  var _gifLinks;
  String search_url;

  void _onSearched(String value) async {
    // setState(() {
    //   _loading = true;
    // });
    final gifs = await fetchGifs(value);
    log(gifs.length.toString());
    setState(() {
      _loading = false;
      _searchText = value;
      _gifLinks = gifs;
    });
  }

  Future<dynamic> fetchGifs(value) async {
    search_url = "https://api.tenor.com/v1/search?q=" +
        value +
        "&key=" +
        "O9Y286B6LV83" +
        "&limit=20";
    List<String> links = new List<String>();
    log(search_url);
    final response = await http.get(search_url);
    if (response.statusCode == 200 && response.body != null) {
      var body = jsonDecode(response.body);
      body['results'].forEach((e) {
        Map<dynamic, dynamic> newMap = Map<dynamic, dynamic>.from(e);
        var media = newMap['media'];
        links.add(media[0]['gif']['url']);
      });
      return links;
    } else {
      throw Exception('Failed to loasd');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Padding(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Whatcha Feeling ? ',
              ),
              onSubmitted: _onSearched,
            ),
            padding: EdgeInsets.all(10.0)),
        Text(_searchText),
        _loading
            ? loadingSpinner //: Center(child: Text('Waiting For Search'))
            : GifDisplay(gifList: this._gifLinks)
      ],
      // mainAxisAlignment: MainAxisAlignment.start,
    );
  }
}

Widget titleSection = Row(
  children: [Text('GIF That Feeling!', style: TextStyle(fontSize: 40))],
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.spaceAround,
);

Widget loadingSpinner =
    Container(child: Center(child: CircularProgressIndicator()));

class GifDisplay extends StatelessWidget {
  GifDisplay({this.gifList});

  List gifList;
  // final List gifList = <Widget>[
  //   Container(
  //     padding: const EdgeInsets.all(8),
  //     child: const Text("He'd have you all unravel at the"),
  //     color: Colors.teal[100],
  //   ),
  //   Container(
  //     padding: const EdgeInsets.all(8),
  //     child: const Text('Heed not the rabble'),
  //     color: Colors.teal[200],
  //   ),
  //   Container(
  //     padding: const EdgeInsets.all(8),
  //     child: const Text('Sound of screams but the'),
  //     color: Colors.teal[300],
  //   ),
  //   Container(
  //     padding: const EdgeInsets.all(8),
  //     child: const Text('Who scream'),
  //     color: Colors.teal[400],
  //   ),
  //   Container(
  //     padding: const EdgeInsets.all(8),
  //     child: const Text('Revolution is coming...'),
  //     color: Colors.teal[500],
  //   ),
  //   Container(
  //     padding: const EdgeInsets.all(8),
  //     child: const Text('Revolution, they...'),
  //     color: Colors.teal[600],
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    log("Gif Display called with " +
        (this.gifList == null ? '0' : this.gifList.length.toString()));
    return GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10, mainAxisSpacing: 10, crossAxisCount: 2),
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      itemCount: this.gifList == null ? 0 : this.gifList.length,
      itemBuilder: (BuildContext context, int index) {
        // log(this.gifList[index].toString());
        var image;
        try {
          if (index < gifList.length) {
            image = Image.network(this.gifList[index].toString());
          } else {
            image = Image.network('https://picsum.photos/250?image=9');
          }
        } catch (e) {
          log(e);
        }
        return image;
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
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
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
