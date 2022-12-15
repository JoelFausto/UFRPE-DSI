import 'package:flutter/material.dart';
import 'ParPalavra.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);
  static const routeName = '/edit';

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments ?? <List, ParPalavra>{}) as Map;
    var palavra = args['palavra'];
    List<ParPalavra> ParPalavraList = args['parPalavra'];
    final TextEditingController wordOne = TextEditingController();
    final TextEditingController wordTwo = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Word'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(hintText: "Insira a primeira palavra"),
                controller: wordOne,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(hintText: "Insira a segunda palavra"),
                controller: wordTwo,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          // ignore: deprecated_member_use
                          primary: const Color.fromARGB(255, 255, 0, 0),
                          fixedSize: const Size(100, 40)),
                      onPressed: () {
                        setState(() {
                          if (palavra == true) {
                            ParPalavraList.insert(0, ParPalavra(wordOne.text, wordTwo.text));
                            palavra == false;
                          } else {
                            ParPalavraList[ParPalavraList.indexOf(palavra)] = ParPalavra(wordOne.text, wordTwo.text);
                          }

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
    