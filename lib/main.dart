// UFRPE- Desenvolvimento de Sistemas de Informação 2022.1
// Aluno: Joel Fausto
// Atividade 4

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class ParPalavra {
  String firstWord = '';
  String secondWord = '';

  ParPalavra(this.firstWord, this.secondWord);

  factory ParPalavra.constructor() {
    WordPair word = generateWordPairs().first;
    ParPalavra p = ParPalavra(word.first, word.second);
    return p;
  }

  String CreateAsPascalCase() {
    return "${firstWord[0].toUpperCase() + firstWord.substring(1)}${secondWord[0].toUpperCase() + secondWord.substring(1)}";
  }

  late final asPascalCase = CreateAsPascalCase();
}

class RepositoryParPalavra {
  final _suggestions = <ParPalavra>[];

  void CreateParPalavra(int num) {
    for (int i = 0; i < num; i++) {
      _suggestions.add(ParPalavra.constructor());
    }
  }

  RepositoryParPalavra() {
    CreateParPalavra(20);
  }

  List getAll() {
    return _suggestions;
  }

  ParPalavra getByIndex(int index) {
    return _suggestions[index];
  }

  void removeParPalavra(ParPalavra word) {
    _suggestions.remove(word);
  }
}

RepositoryParPalavra repositoryParPalavra = new RepositoryParPalavra();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black),
      ),
      initialRoute: '/',
      routes: {
        RandomWords.routeName:(context) => const RandomWords(),
        EditScreen.routeName:(context) => const EditScreen(),
      },
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _saved = <ParPalavra>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  bool cardMode = false;
  String nome = "Startup Name Generator";

  @override
  Widget build(BuildContext context) {
    print("widght state");
    return Scaffold(
        appBar: AppBar(
          title: Text(nome),
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
              icon: Icon(Icons.auto_fix_normal_outlined),
            ),
          ],
        ),
        body: _buildSuggestions(cardMode));
  }

  // Tela de favoritos
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context) {
        final tiles = _saved.map(
          (ParPalavra pair) {
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
      }),
    );
  }

    // Construindo sugestoes
    Widget _buildSuggestions(bool cardMode) {
      print('list mode changed');

      if (cardMode == false) {
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            if (i.isOdd) return const Divider();
            print("list view");
            final index = i ~/ 2;

            if (index >= repositoryParPalavra.getAll().length) {
              repositoryParPalavra.CreateParPalavra(10);
              print("create word");
            }
            return _buildRow(repositoryParPalavra.getByIndex(index));
          },
        );
      } else {
        return _cardVizualizaton();
      }
    }

    // Lista de construcao de linhas
    Widget _buildRow(ParPalavra pair) {
      print("build row");
      final alreadySaved = _saved.contains(pair);
      var color = Colors.transparent;
      return Dismissible(
          key: Key(pair.toString()),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            setState(() {
              if (alreadySaved) {
                _saved.remove(pair);
              }
              repositoryParPalavra.removeParPalavra(pair);
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
                pair.asPascalCase,
                style: _biggerFont,
              ),
              trailing: IconButton(
                icon: Icon(
                  alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: 
                      alreadySaved ? const Color.fromARGB(255, 255, 0, 0) : null,
                  semanticLabel: alreadySaved ? 'Remove from saved' : 'Save'),
                tooltip: "Favorite",
                hoverColor: color,
                onPressed: () {
                  setState(() {
                    if (alreadySaved) {
                      _saved.remove(pair);
                    } else {
                      _saved.add(pair);
                    }
                  });
                }),
            onTap: () {
              setState(() {
                Navigator.popAndPushNamed(context, '/edit', arguments: {
                  'parPalavra': repositoryParPalavra.getAll(),
                  'palavra':pair,
                });
              });
            }));
    }
  
    // Construcao de cards de visualizacao
    Widget _cardVizualizaton() {
      print('card mode changed');
      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 8),
        itemBuilder: (context, index) {
          if (index >= repositoryParPalavra.getAll().length) {
            repositoryParPalavra.CreateParPalavra(10);
          }
          return Column(
            children: [_buildRow(repositoryParPalavra.getByIndex(index))],
          );
        },
      );
    }
  }

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);
  static const routeName = '/edit';

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments ??
        <List, ParPalavra>{}) as Map;
    ParPalavra palavra = args['palavra'];
    List<ParPalavra> ParPalavraList = args['parPalavra'];

    final TextEditingController wordOne = TextEditingController();
    final TextEditingController wordTwo = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edite a palavra'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(hintText: "Insira a 1° palavra"),
                controller: wordOne,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(hintText: "Insira a 2° palavra"),
                controller: wordTwo,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 37, 52, 190),
                          fixedSize: const Size(100, 40)),
                      onPressed: () {
                        setState(() {
                          ParPalavraList[ParPalavraList.indexOf(palavra)] =
                              ParPalavra(wordOne.text, wordTwo.text);
                          Navigator.popAndPushNamed(context, '/');
                        });
                      },
                      child: const Text(
                        'Enviar',
                        style: TextStyle(fontSize: 16),
                      )),
                ),
              ),
            ],
          )),
        ));
  }
}
