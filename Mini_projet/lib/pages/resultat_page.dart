import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';
import 'parametresquiz.page.dart';

class ResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<dynamic> questions;

  ResultPage({required this.score, required this.totalQuestions, required this.questions});

  HtmlUnescape unescape = HtmlUnescape();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultats', style: GoogleFonts.paytoneOne(fontSize: 25, color: Colors.white)),
        backgroundColor: Color(0xFF8C52FF),
      ),
      backgroundColor: Color(0xFF8C52FF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Score : $score / $totalQuestions',
              style: GoogleFonts.lilitaOne(fontSize: 30, color: Color(0xFFf5c93a)),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  var question = questions[index];
                  return Card(
                    color: Color(0xFFf5c93a),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            unescape.convert(question['question']),
                            style: GoogleFonts.exo2(fontSize: 16, color: Color(0xFF8C52FF)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Réponse correcte : ${unescape.convert(question['correct_answer'])}',
                            style: GoogleFonts.exo2(fontSize: 14, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ParametresQuizPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFf5c93a),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: Text(
                    'Rejouer',
                    style: GoogleFonts.lilitaOne(fontSize: 20, color: Color(0xFF8C52FF)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFf5c93a),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: Text(
                    'Accueil',
                    style: GoogleFonts.lilitaOne(fontSize: 20, color: Color(0xFF8C52FF)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}