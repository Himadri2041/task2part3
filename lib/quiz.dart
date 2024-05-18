import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'que.dart';


class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<List<Question>> futureQuestions;
  int currentQuestionIndex = 0;
  int score = 0;
  int remainingTime = 10; // Time in seconds for each question
  Timer? timer;

  @override
  void initState() {
    super.initState();
    futureQuestions = fetchQuestions();
    _loadScore();
    _startTimer();
  }

  void _loadScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      score = (prefs.getInt('score') ?? 0);
    });
  }

  void _saveScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('score', score);
  }

  void _startTimer() {
    timer?.cancel();
    setState(() {
      remainingTime = 10;
    });
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          _timeUp();
        }
      });
    });
  }

  void _timeUp() {
    timer?.cancel();
    futureQuestions.then((questions) {
      String correctAnswer = questions[currentQuestionIndex].answer;
      String feedback = "Time's up! The correct answer is: $correctAnswer";

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Time's Up!"),
            content: Text(feedback),
            actions: [
              TextButton(
                child: Text("Next"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    currentQuestionIndex = (currentQuestionIndex + 1) % questions.length;
                    _startTimer();
                  });
                },
              ),
            ],
          );
        },
      );
    });
  }

  void _answerQuestion(String selectedChoice) {
    timer?.cancel();
    futureQuestions.then((questions) {
      String correctAnswer = questions[currentQuestionIndex].answer;
      String feedback = (selectedChoice == correctAnswer) ? "Correct!" : "Incorrect! The correct answer is: $correctAnswer";

      if (selectedChoice == correctAnswer) {
        setState(() {
          score++;
        });
        _saveScore();
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Your Answer"),
            content: Text(feedback),
            actions: [
              TextButton(
                child: Text("Next"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    currentQuestionIndex = (currentQuestionIndex + 1) % questions.length;
                    _startTimer();
                  });
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trivia Quiz'),
      ),
      body: FutureBuilder<List<Question>>(
        future: futureQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No questions available'));
          } else {
            List<Question> questions = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    questions[currentQuestionIndex].question,
                    style: TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Time remaining: $remainingTime seconds',
                    style: TextStyle(fontSize: 20.0, color: Colors.red),
                  ),
                  SizedBox(height: 20.0),
                  ...questions[currentQuestionIndex].choices.map((choice) {
                    return ElevatedButton(
                      onPressed: () => _answerQuestion(choice),
                      child: Text(choice),
                    );
                  }).toList(),
                  SizedBox(height: 20.0),
                  Text(
                    'Score: $score',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}







































































































































