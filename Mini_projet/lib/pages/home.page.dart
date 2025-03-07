import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_projet/pages/apropos.page.dart';
import 'package:mini_projet/pages/parametresquiz.page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController txt_paramsquiz = TextEditingController();
  TextEditingController txt_apropos = TextEditingController();
  bool soundEnabled = true;
  bool notificationsEnabled = true;
  List<Map<String, dynamic>> highScores = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadHighScores();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      soundEnabled = prefs.getBool('soundEnabled') ?? true;
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', soundEnabled);
    await prefs.setBool('notificationsEnabled', notificationsEnabled);
  }

  Future<void> _loadHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scoresString = prefs.getString('highScores') ?? '[]';
    setState(() {
      highScores = List<Map<String, dynamic>>.from(json.decode(scoresString));
    });
  }

  Future<void> _saveScore(int categoryId, String difficulty, int score) async {
    final prefs = await SharedPreferences.getInstance();
    highScores.add({'categoryId': categoryId, 'difficulty': difficulty, 'score': score});
    await prefs.setString('highScores', json.encode(highScores));
    _loadHighScores();
  }

  Future<void> _resetScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('highScores');
    setState(() {
      highScores = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    Map<String, Map<String, String>> translations = {
      'fr': {
        'title': 'Paramétrer votre quiz',
        'start_quiz': 'Commencer un quiz',
        'about': 'À propos',
        'ranking': 'Classement',
        'settings': 'Paramètres',
        'sound': 'Son',
        'notifications': 'Notifications',
        'reset_scores': 'Réinitialiser les scores',
      },
      'en': {
        'title': 'Set up your quiz',
        'start_quiz': 'Start a quiz',
        'about': 'About',
        'ranking': 'Ranking',
        'settings': 'Settings',
        'sound': 'Sound',
        'notifications': 'Notifications',
        'reset_scores': 'Reset scores',
      },
      'ar': {
        'title': 'إعداد الاختبار الخاص بك',
        'start_quiz': 'بدء الاختبار',
        'about': 'حول',
        'ranking': 'الترتيب',
        'settings': 'الإعدادات',
        'sound': 'الصوت',
        'notifications': 'الإشعارات',
        'reset_scores': 'إعادة تعيين النتائج',
      },
    };

    final t = translations[appState.language]!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8C52FF),
        title: Text(t['title']!, style: GoogleFonts.paytoneOne(fontSize: 25, color: Colors.white)),
        actions: [
          DropdownButton<String>(
            value: appState.language,
            icon: Icon(Icons.language, color: Colors.white),
            dropdownColor: Color(0xFF8C52FF),
            items: [
              DropdownMenuItem(value: 'fr', child: Text('Français', style: TextStyle(color: Colors.white))),
              DropdownMenuItem(value: 'en', child: Text('English', style: TextStyle(color: Colors.white))),
              DropdownMenuItem(value: 'ar', child: Text('العربية', style: TextStyle(color: Colors.white))),
            ],
            onChanged: (value) {
              if (value != null) appState.setLanguage(value);
            },
          ),
          IconButton(
            icon: Icon(appState.isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
            onPressed: () => appState.toggleTheme(),
          ),
        ],
      ),
      backgroundColor: appState.isDarkMode ? Colors.grey[900] : Color(0xFF8C52FF),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/quiz.png', width: 300, height: 300),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _onGetParametresQuiz(context),
                child: Text(t['start_quiz']!, style: GoogleFonts.paytoneOne(fontSize: 22, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  backgroundColor: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _onAproposPage(context),
                child: Text(t['about']!, style: GoogleFonts.paytoneOne(fontSize: 22, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  backgroundColor: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showRankingDialog(context, t),
                child: Text(t['ranking']!, style: GoogleFonts.paytoneOne(fontSize: 22, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  backgroundColor: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showSettingsDialog(context, t),
                child: Text(t['settings']!, style: GoogleFonts.paytoneOne(fontSize: 22, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  backgroundColor: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onGetParametresQuiz(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ParametresQuizPage()));
    txt_paramsquiz.text = "";
  }

  void _onAproposPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AproposPage()));
    txt_apropos.text = "";
  }

  void _showRankingDialog(BuildContext context, Map<String, String> t) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Provider.of<AppState>(context).isDarkMode ? Colors.grey[800] : Colors.white,
        title: Text(t['ranking']!, style: GoogleFonts.lilitaOne(color: Color(0xFF8C52FF))),
        content: SingleChildScrollView(
          child: Column(
            children: highScores.isEmpty
                ? [Text("Aucun score enregistré.", style: TextStyle(color: Colors.black))]
                : highScores.map((score) => ListTile(
              title: Text(
                "Catégorie: ${score['categoryId']} - Difficulté: ${score['difficulty']}",
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text("Score: ${score['score']}", style: TextStyle(color: Colors.black)),
            )).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _resetScores,
            child: Text(t['reset_scores']!, style: TextStyle(color: Color(0xFF8C52FF))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Fermer", style: TextStyle(color: Color(0xFF8C52FF))),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, Map<String, String> t) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Provider.of<AppState>(context).isDarkMode ? Colors.grey[800] : Colors.white,
        title: Text(t['settings']!, style: GoogleFonts.lilitaOne(color: Color(0xFF8C52FF))),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text(t['sound']!, style: TextStyle(color: Colors.black)),
                value: soundEnabled,
                onChanged: (value) {
                  setState(() {
                    soundEnabled = value;
                    _saveSettings();
                  });
                },
              ),
              SwitchListTile(
                title: Text(t['notifications']!, style: TextStyle(color: Colors.black)),
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                    _saveSettings();
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Fermer", style: TextStyle(color: Color(0xFF8C52FF))),
          ),
        ],
      ),
    );
  }
}