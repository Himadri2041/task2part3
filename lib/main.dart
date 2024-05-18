import 'package:flutter/material.dart';
import 'package:task23/quiz.dart';

void main() {
  runApp(TriviaQuizApp());
}

class TriviaQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trivia Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: mainpage(),
    );
  }
}

class mainpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Column(
      children: <Widget>[
  Align(
    alignment: Alignment.bottomCenter,
    child: Image.asset(
      'lib/images/1st.png',
     
    ),
  ),
   Text(
   'Embark on the Ultimate\nQuiz Adventure',
   style: TextStyle(
     fontWeight: FontWeight.bold,
     fontSize: 32,
     color: Colors.black,
   ),
 ),
MaterialButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(),
      ),
    );
  },
  child: Icon(Icons.arrow_forward),), ],
 ),
    );
  }
}
