import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ParametresQuizPage extends StatefulWidget {
  String category = "";
  @override
  _ParametresQuizPageState createState() => _ParametresQuizPageState();
}

class _ParametresQuizPageState extends State<ParametresQuizPage> {
  String? selectDifficulty;
  int? _selectedNumberOfQuestions;
  int? selectedCategoryId;

  final List<String> difficulties = ['Facile', 'Moyen', 'Difficile'];
  final List<int> _numberOfQuestions = [5, 10, 15, 20];

  @override
  var categoryData;
  List<Map<String, dynamic>> categories = [];
  void initState(){
    super.initState();
    getCategoryData();
  }

  void getCategoryData (){
    String url = "https://opentdb.com/api_category.php";
    http.get(Uri.parse(url)).then((resp) {
      setState(() {
        var decodedData = json.decode(resp.body);
        this.categoryData = decodedData;
        categories = List<Map<String, dynamic>>.from(decodedData['trivia_categories'].map((category)=>{
          'id':category['id'],
          'name':category['name']
        }));
      });
      print(this.categoryData);
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramétrer votre quiz', style: GoogleFonts.paytoneOne(fontSize: 25, color: Colors.white),),
        backgroundColor: Color(0xFF8C52FF),
      ),
      backgroundColor: Color(0xFF8C52FF),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centre verticalement
              children: [
                Image.asset('images/paramsquiz.png',width: 300, height: 200, ),
                SizedBox(height: 20),

                // Choix de la catégorie
                Text(
                  'Catégorie',
                  style: GoogleFonts.lilitaOne(fontSize: 23, color: Color(0xFFf5c93a)),
                ),
                SizedBox(height: 10),
                DropdownButton<int>(
                  iconEnabledColor: Colors.white,
                  value: selectedCategoryId,
                  hint: Text('Sélectionner catégorie', style: GoogleFonts.exo2(color: Colors.white)),
                  dropdownColor: Color(0xFF8C52FF),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedCategoryId=newValue;
                    });
                  },
                  items: categories.map<DropdownMenuItem<int>>((Map<String, dynamic>category){
                    return DropdownMenuItem<int>(
                      value: category['id'],
                      child: Text(category['name'], style: GoogleFonts.exo2(color: Colors.white)),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),

                // Choix de la difficulté
                Text(
                  'Difficulté',
                  style: GoogleFonts.lilitaOne(fontSize: 23, color: Color(0xFFf5c93a)),
                ),
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
                        Text(
                          difficulty,
                          style: GoogleFonts.exo2(color: Colors.white),
                        ),
                        SizedBox(width: 40),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),

                // Choix du nombre de questions
                Text(
                  'Nombre de questions',
                  style: GoogleFonts.lilitaOne(fontSize: 23, color: Color(0xFFf5c93a)),
                ),
                SizedBox(height: 10),
                DropdownButton<int>(
                  iconEnabledColor: Colors.white,
                  value: _selectedNumberOfQuestions,
                  hint: Text('Nombre de questions', style: GoogleFonts.exo2(color: Colors.white)),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
