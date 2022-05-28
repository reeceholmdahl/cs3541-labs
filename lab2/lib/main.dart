import 'dart:core';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error.toString()}');
            return Text("Something went wrong!");
          } else if (snapshot.hasData) {
            return RandomWords();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class LikedHistory extends StatefulWidget {
  @override
  _LikedHistoryState createState() => _LikedHistoryState();
}

class _LikedHistoryState extends State<LikedHistory> {
  final dbRef = FirebaseDatabase.instance.reference().child("liked");
  final _biggerFont = TextStyle(fontSize: 18.0);
  final _saved = <WordPair>{};
  List<Map<dynamic, dynamic>> dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liked History"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, _saved);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: FutureBuilder(
          future: dbRef.once(),
          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
            if (snapshot.hasData) {
              dataList.clear();
              if (snapshot.data!.value == null) {
                print("No Liked History...");
                return Text("No Liked History...");
              }
              Map<dynamic, dynamic> values = snapshot.data!.value;
              values.forEach((key, values) {
                dataList.add(values);
                final reg = RegExp(r"(?=[A-Z])");
                var parts = values['name'].split(reg);
                _saved.add(WordPair(parts[0], parts[1]).toLowerCase());
              });
              return new ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(16.0),
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            trailing: Icon(Icons.delete),
                            title: Text(dataList[index]['name'],
                                style: _biggerFont),
                            onTap: () => dbRef
                                    .orderByChild('name')
                                    .equalTo(dataList[index]['name'])
                                    .once()
                                    .then((DataSnapshot snapshot) {
                                  Map<dynamic, dynamic> children =
                                      snapshot.value;
                                  children.forEach((key, value) {
                                    FirebaseDatabase.instance
                                        .reference()
                                        .child('liked')
                                        .child(key)
                                        .remove();
                                  });
                                  setState(() {});
                                })),
                      ],
                    ),
                  );
                },
              );
            }
            return Text("Something went wrong!");
          }),
    );
  }
}

class _RandomWordsState extends State<RandomWords> {
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("liked");
  final _suggestions = <WordPair>[];
  var _saved = <WordPair>{};
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    final reg = RegExp(r"(?=[A-Z])");
    /*dbRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<dynamic, dynamic> children = snapshot.value;
        children.forEach((key, value) {
          var parts = children[key]['name'].toString().split(reg);
          _saved.add(WordPair(parts[0], parts[1]).toLowerCase());
        });
      } else {
        _saved.clear();
      }
    });*/

    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () async {
              final data = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LikedHistory()));
              //_saved = data;
              setState(() {
                _saved = data;
              });
            },
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    DatabaseReference _likedRef =
        FirebaseDatabase.instance.reference().child("liked");
    return ListTile(
      title: Text(
        pair.asCamelCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
            _likedRef
                .orderByChild('name')
                .equalTo(pair.asCamelCase.toString())
                .once()
                .then((DataSnapshot snapshot) {
              if (snapshot.value != null) {
                Map<dynamic, dynamic> children = snapshot.value;
                children.forEach((key, value) {
                  FirebaseDatabase.instance
                      .reference()
                      .child('liked')
                      .child(key)
                      .remove();
                });
              }
            });
          } else {
            _saved.add(pair);
            _likedRef.push().child("name").set(pair.asCamelCase.toString());
          }
        });
      },
    );
  }
}
