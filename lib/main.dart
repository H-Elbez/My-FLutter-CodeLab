import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart'; 

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'My Startup Name Generator',
      home: new RandomWords(),
        theme: new ThemeData(
        primaryColor: Colors.red,
      ), 
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _savedSuggestions = new Set<WordPair>();   
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

    Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (BuildContext _context, int i) {
       if (i.isOdd) {
          return new Divider();
        }

        final int index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }
    );
  }

  Widget _buildRow(WordPair pair) {
  final bool alreadySaved = _savedSuggestions.contains(pair); 
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      onTap: (){
        setState(() {
        if(alreadySaved){
          _savedSuggestions.remove(pair);
        }else{
          _savedSuggestions.add(pair);
        }   
        });
       
      },
      trailing: new Icon( alreadySaved ? Icons.favorite : Icons.favorite_border,color:
      alreadySaved ? Colors.red : null,),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
        new MaterialPageRoute<void>(   
      builder: (BuildContext context) {
        final Iterable<ListTile> tiles = _savedSuggestions.map(
          (WordPair pair) {
            return new ListTile(
              title: new Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          },
        );
        final List<Widget> divided = ListTile
          .divideTiles(
            context: context,
            tiles: tiles,
          )
          .toList();

            return new Scaffold(       
          appBar: new AppBar(
            title: const Text('Saved Suggestions'),
          ),
          body: new ListView(children: divided),
        );  
      },
    ),         
  );
  }
  
  @override
  Widget build(BuildContext context) {
     return new Scaffold (                   
      appBar: new AppBar(
        title: new Text('My Startup Name Generator'),
         actions: <Widget>[      
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
          
      body: _buildSuggestions(),
    );
  }
}