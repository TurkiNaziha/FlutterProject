import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart'; // For sound
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // For notifications
import 'package:shared_preferences/shared_preferences.dart';
import 'resultat_page.dart';
import 'app_state.dart';

class QuizPage extends StatefulWidget {
  final int categoryId;
  final String difficulty;
  final int numberOfQuestions;

  QuizPage({
    required this.categoryId,
    required this.difficulty,
    required this.numberOfQuestions,
  });

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isAnswered = false;
  String? selectedAnswer;
  Timer? _timer;
  int _timeLeft = 30;
  HtmlUnescape unescape = HtmlUnescape();
  bool isLoading = true;
  String? errorMessage;

  // Audio and Notification instances
  final AudioPlayer _audioPlayer = AudioPlayer();
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    fetchQuestions();
  }

  void _initializeNotifications() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _playSound(String type) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    bool soundEnabled = prefs.getBool('soundEnabled') ?? true;
    if (soundEnabled) {
      await _audioPlayer.play(AssetSource(type == 'correct' ? 'sounds/correct.mp3' : 'sounds/wrong.mp3'));
    }
  }

  Future<void> _showNotification(String title, String body) async {
    final prefs = await SharedPreferences.getInstance();
    bool notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    if (notificationsEnabled) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('quiz_channel', 'Quiz Notifications',
          importance: Importance.max, priority: Priority.high);
      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      await _flutterLocalNotificationsPlugin.show(
          0, title, body, platformChannelSpecifics);
    }
  }

  Future<void> fetchQuestions() async {
    String url =
        "https://opentdb.com/api.php?amount=${widget.numberOfQuestions}&category=${widget.categoryId}&difficulty=${widget.difficulty}&type=multiple";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          questions = json.decode(response.body)['results'];
          isLoading = false;
          if (questions.isNotEmpty) {
            startTimer();
            _showNotification("Quiz Started", "Good luck with your quiz!");
          }
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "API Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Connection Error: $e";
      });
    }
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0 && !isAnswered) {
        setState(() {
          _timeLeft--;
        });
      } else if (_timeLeft == 0) {
        nextQuestion();
      }
    });
  }

  void nextQuestion() {
    _timer?.cancel();
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        isAnswered = false;
        selectedAnswer = null;
        _timeLeft = 30;
      });
      startTimer();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            score: score,
            totalQuestions: questions.length,
            questions: questions,
          ),
        ),
      );
    }
  }

  void checkAnswer(String answer) {
    if (!isAnswered) {
      setState(() {
        isAnswered = true;
        selectedAnswer = answer;
        if (answer == questions[currentQuestionIndex]['correct_answer']) {
          score++;
          _playSound('correct');
        } else {
          _playSound('wrong');
        }
      });
      Future.delayed(Duration(seconds: 1), nextQuestion);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    Map<String, Map<String, String>> translations = {
      'fr': {'quiz': 'Quiz', 'time_left': 'Temps restant'},
      'en': {'quiz': 'Quiz', 'time_left': 'Time left'},
      'ar': {'quiz': 'اختبار', 'time_left': 'الوقت المتبقي'},
    };
    final t = translations[appState.language]!;

    if (isLoading) {
      return Scaffold(
        backgroundColor: appState.isDarkMode ? Colors.grey[900] : Color(0xFF8C52FF),
        body: Center(child: CircularProgressIndicator(color: Color(0xFFf5c93a))),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: appState.isDarkMode ? Colors.grey[900] : Color(0xFF8C52FF),
        body: Center(
          child: Text(errorMessage!, style: GoogleFonts.exo2(fontSize: 18, color: Colors.white)),
        ),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: appState.isDarkMode ? Colors.grey[900] : Color(0xFF8C52FF),
        body: Center(
          child: Text("No questions retrieved.", style: GoogleFonts.exo2(fontSize: 18, color: Colors.white)),
        ),
      );
    }

    var question = questions[currentQuestionIndex];
    List<String> answers = [...question['incorrect_answers'], question['correct_answer']]..shuffle();

    return Scaffold(
      appBar: AppBar(
        title: Text(t['quiz']!, style: GoogleFonts.paytoneOne(fontSize: 25, color: Colors.white)),
        backgroundColor: Color(0xFF8C52FF),
      ),
      backgroundColor: appState.isDarkMode ? Colors.grey[900] : Color(0xFF8C52FF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${t['time_left']}: $_timeLeft s',
              style: GoogleFonts.exo2(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              unescape.convert(question['question']),
              style: GoogleFonts.lilitaOne(fontSize: 20, color: Color(0xFFf5c93a)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ...answers.map((answer) {
              Color buttonColor = Color(0xFFf5c93a);
              if (isAnswered) {
                if (answer == question['correct_answer']) {
                  buttonColor = Colors.green;
                } else if (answer == selectedAnswer) {
                  buttonColor = Colors.red;
                }
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: isAnswered ? null : () => checkAnswer(answer),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    unescape.convert(answer),
                    style: GoogleFonts.exo2(fontSize: 16, color: Color(0xFF8C52FF)),
                  ),
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            Text(
              'Question ${currentQuestionIndex + 1}/${questions.length}',
              style: GoogleFonts.exo2(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}