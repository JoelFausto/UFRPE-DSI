// UFRPE- Desenvolvimento de Sistemas de Informação 2022.1
// Aluno: Joel Fausto
// Atividade 3

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),

      home: const RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  bool cardMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Startup Name Generator'),
          actions: [
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _pushSaved,
              tooltip: 'Saved Suggestions',
            ),
            IconButton(
              onPressed: (() {
                setState(() {
                  if (cardMode == false) {
                    cardMode = true;
                    debugPrint('$cardMode');
                  } else if (cardMode == true) {
                    cardMode = false;
                    debugPrint('$cardMode');
                  }
                });
              }),
              tooltip:
                cardMode ? 'List Vizualization' : 'Card Mode Vizualization',
              icon: const Icon(Icons.auto_fix_normal_outlined),
            ),
          ],
        ),

        body: _buildSuggestions(cardMode));
  }

  // Tela de favoritos
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair){
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

    Widget _buildSuggestions(bool cardMode) {
      if (cardMode == false) {
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            if (i.isOdd) return const Divider();

            final index = i ~/ 2;
            if (index >= _suggestions.length) {
              _suggestions.addAll(generateWordPairs().take(10));
            }
            return _buildRow(_suggestions[index], index);
          },
        );
      } else {
        return _cardVizualizaton();
      }
    }

    //Building list Rows
    Widget _buildRow(WordPair pair, int index) {
      final alreadySaved = _saved.contains(_suggestions[index]);
      var color = Colors.transparent;
      final item = pair.asPascalCase;
      return Dismissible(
        key: Key(item),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          setState(() {
            if (alreadySaved) {
              _saved.remove(_suggestions[index]);
            }
            _suggestions.removeAt(index);
          });
        },
        background: Container(
          color: Color.fromARGB(255, 255, 0, 0),
          padding: EdgeInsets.all(8.0),
          alignment: Alignment.centerRight,
          child: const Text(
            "Deletar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ), 
        child: ListTile(
          title: Text(
            _suggestions[index].asPascalCase,
            style: _biggerFont,
          ),
          onTap: () {
            _editWordPair();
          },
          trailing: IconButton(
            icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border, 
              color: alreadySaved ? const Color.fromARGB(255, 255, 0, 0) : null,
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save'),
            tooltip: "Favorite",
            hoverColor: color,
            onPressed: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(_suggestions[index]);
                } else {
                  _saved.add(_suggestions[index]);
                }
              });
            }),
        ),
        );
      
    }

    void _editWordPair() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Edit WordPair"),
          ),
          body: const Center(
            child: Text("Página em construção..."),
          ));
    }));
  }
  
    //Building cards vizualization
    Widget _cardVizualizaton() {
      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 8),
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          //final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return Column(
            children: [_buildRow(_suggestions[index], index)],
          );
        },
      );
    }
  }

