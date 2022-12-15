import 'package:english_words/english_words.dart';

class ParPalavra {
  String firstWord = '';
  String secondWord = '';

  ParPalavra(this.firstWord, this.secondWord);

// Factory -> criar novas palavras usando a base Word Pair
  factory ParPalavra.constructor() {
    WordPair word = generateWordPairs().first;
    ParPalavra p = ParPalavra(word.first, word.second);
    return p;
  }

// Function -> Transforma a segunda parte de uma palavra em LowerCase
  String lowerCase(String word) {
    return word.toLowerCase();
  }

// Function -> Muda as palavras para PascalCase
  String CreateAsPascalCase() {
    return "${firstWord[0].toUpperCase() + lowerCase(firstWord.substring(1))}${secondWord[0].toUpperCase() + lowerCase(secondWord.substring(1))}";
  }

// Var que recebe o PascalCase da function
  late final asPascalCase = CreateAsPascalCase();
}