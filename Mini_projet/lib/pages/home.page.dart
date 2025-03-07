import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_projet/pages/apropos.page.dart';
import 'package:mini_projet/pages/parametresquiz.page.dart';

class HomePage extends StatelessWidget{

  TextEditingController txt_paramsquiz = new TextEditingController();
  TextEditingController txt_apropos = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF8C52FF),
    ),
    backgroundColor: Color(0xFF8C52FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Image.asset('images/quiz.png', width: 300, height: 300),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: ()=> _onGetParametresQuiz(context),
            child: Text('Commencer un quiz', style: GoogleFonts.paytoneOne(fontSize: 22, color: Colors.white),
            ),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(500,50), // Réduire la largeur et définir la haute
                backgroundColor: Colors.deepPurple
              ),
            ),
            SizedBox(height: 20),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ElevatedButton(onPressed: ()=> _onAproposPage(context),
                child: Text('À propos', style: GoogleFonts.paytoneOne(fontSize: 22, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(500,50), // Réduire la largeur et définir la haute
                backgroundColor: Colors.deepPurple,
              ),
             ),
            ),
          ],
        ),
      ),
    );
  }
  void _onGetParametresQuiz(BuildContext context){
    String v = txt_paramsquiz.text;
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ParametresQuizPage()));
    txt_paramsquiz.text = "";
  }

  void _onAproposPage(BuildContext context){
    String v = txt_apropos.text;
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AproposPage()));
    txt_apropos.text = "";
  }
}