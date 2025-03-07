import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'quiz_page.dart';
import 'app_state.dart';

class ParametresQuizPage extends StatefulWidget {
  @override
  _ParametresQuizPageState createState() => _ParametresQuizPageState();
}

class _ParametresQuizPageState extends State<ParametresQuizPage> {
  String? selectDifficulty;
  int? _selectedNumberOfQuestions;
  int? selectedCategoryId;
  List<Map<String, dynamic>> categories = [];

  final List<String> difficulties = ['Easy', 'Medium', 'Hard'];
  final List<int> _numberOfQuestions = [5, 10, 15, 20];

  @override
  void initState() {
    super.initState();
    getCategoryData();
  }

  void getCategoryData() {
    String url = "https://opentdb.com/api_category.php";
    http.get(Uri.parse(url)).then((resp) {
      setState(() {
        var decodedData = json.decode(resp.body);
        categories = List<Map<String, dynamic>>.from(
            decodedData['trivia_categories'].map((category) => {
              'id': category['id'],
              'name': category['name'],
            }));
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    Map<String, Map<String, String>> translations = {
      'fr': {
        'title': 'Paramétrer votre quiz',
        'category': 'Catégorie',
        'difficulty': 'Difficulté',
        'questions': 'Nombre de questions',
        'start': 'Commencer',
        'select': 'Sélectionner tous les paramètres'
      },
      'en': {
        'title': 'Set up your quiz',
        'category': 'Category',
        'difficulty': 'Difficulty',
        'questions': 'Number of questions',
        'start': 'Start',
        'select': 'Please select all parameters'
      },
      'ar': {
        'title': 'إعداد الاختبار الخاص بك',
        'category': 'الفئة',
        'difficulty': 'الصعوبة',
        'questions': 'عدد الأسئلة',
        'start': 'ابدأ',
        'select': 'يرجى تحديد جميع المعلمات'
      },
    };
    final t = translations[appState.language]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t['title']!, style: GoogleFonts.paytoneOne(fontSize: 25, color: Colors.white)),
        backgroundColor: Color(0xFF8C52FF),
      ),
      backgroundColor: appState.isDarkMode ? Colors.grey[900] : Color(0xFF8C52FF),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/paramsquiz.png', width: 300, height: 200),
                SizedBox(height: 20),
                Text(t['category']!, style: GoogleFonts.lilitaOne(fontSize: 23, color: Color(0xFFf5c93a))),
                SizedBox(height: 10),
                DropdownButton<int>(
                  iconEnabledColor: Colors.white,
                  value: selectedCategoryId,
                  hint: Text('Select category', style: GoogleFonts.exo2(color: Colors.white)),
                  dropdownColor: Color(0xFF8C52FF),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedCategoryId = newValue;
                    });
                  },
                  items: categories.map<DropdownMenuItem<int>>((Map<String, dynamic> category) {
                    return DropdownMenuItem<int>(
                      value: category['id'],
                      child: Text(category['name'], style: GoogleFonts.exo2(color: Colors.white)),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Text(t['difficulty']!, style: GoogleFonts.lilitaOne(fontSize: 23, color: Color(0xFFf5c93a))),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: difficulties.map((String difficulty) {
                    return Row(
                      children: [
                        Radio<String>(
                          value: difficulty,
                          groupValue: selectDifficulty,
                          onChanged: (String? value) {
                            setState(() {
                              selectDifficulty = value;
                            });
                          },
                          activeColor: Colors.white,
                        ),
                        Text(difficulty, style: GoogleFonts.exo2(color: Colors.white)),
                        SizedBox(width: 40),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Text(t['questions']!, style: GoogleFonts.lilitaOne(fontSize: 23, color: Color(0xFFf5c93a))),
                SizedBox(height: 10),
                DropdownButton<int>(
                  iconEnabledColor: Colors.white,
                  value: _selectedNumberOfQuestions,
                  hint: Text('Number of questions', style: GoogleFonts.exo2(color: Colors.white)),
                  dropdownColor: Color(0xFF8C52FF),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedNumberOfQuestions = newValue;
                    });
                  },
                  items: _numberOfQuestions.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value questions', style: GoogleFonts.exo2(color: Colors.white)),
                    );
                  }).toList(),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (selectedCategoryId != null && selectDifficulty != null && _selectedNumberOfQuestions != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizPage(
                            categoryId: selectedCategoryId!,
                            difficulty: selectDifficulty!.toLowerCase(),
                            numberOfQuestions: _selectedNumberOfQuestions!,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(t['select']!)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFf5c93a),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text(
                    t['start']!,
                    style: GoogleFonts.lilitaOne(fontSize: 20, color: Color(0xFF8C52FF)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}