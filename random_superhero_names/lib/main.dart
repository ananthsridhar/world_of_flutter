// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final randomWord = WordPair.random();
    return MaterialApp(
      title: 'Whats my Superhero Name?!',
      home: RandomSuperoName(),
      theme: ThemeData(primaryColor: Colors.black),
    );
  }
}

class RandomSuperoName extends StatefulWidget {
  @override
  _RandomSuperoNameState createState() => _RandomSuperoNameState();
}

class _RandomSuperoNameState extends State<RandomSuperoName> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);

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
    final isSaved = _saved.contains(pair);
    return ListTile(
        title: Text(pair.asPascalCase, style: _biggerFont),
        trailing: Icon(
          isSaved ? Icons.favorite : Icons.favorite_border,
          color: isSaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (isSaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        });
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final tiles = _saved.map((WordPair pair) {
        return ListTile(
          title: Text(pair.asPascalCase, style: _biggerFont),
        );
      });
      final divided =
          ListTile.divideTiles(tiles: tiles, context: context).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text('Shortlisted Names'),
        ),
        body: ListView(children: divided),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final randomWord = WordPair.random();
    return Scaffold(
        appBar: AppBar(
          title: Text('SuperHero Name Generator'),
          actions: [
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
          ],
        ),
        body:
            _buildSuggestions()); //Text('You\'re a Superhero now, '+randomWord.asPascalCase);
  }
}
