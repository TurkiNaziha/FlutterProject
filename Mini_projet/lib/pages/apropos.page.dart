import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AproposPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('À propos', style: GoogleFonts.paytoneOne(fontSize: 25, color: Colors.white)),
        backgroundColor: Color(0xFF8C52FF),
      ),
      backgroundColor: Color(0xFF8C52FF),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Quiz Time !', style: GoogleFonts.lilitaOne(fontSize: 40, color: Color(0xFFf5c93a),),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Cette application mobile, développée avec Flutter, offre aux utilisateurs une expérience interactive de quiz sur une variété de sujets. Les questions sont récupérées en temps réel depuis l’API gratuite Open Trivia Database (OpenTDB), garantissant ainsi un contenu riche et diversifié.\n\nGrâce à un système de score intégré, les joueurs peuvent suivre leurs performances tout en testant leurs connaissances. Ils ont également la possibilité de choisir parmi plusieurs catégories et niveaux de difficulté. À la fin de chaque quiz, les réponses correctes sont affichées pour un apprentissage continu et amusant.\n\nPrêt à relever le défi ?',
                  style: GoogleFonts.exo2(
                    fontSize: 20,
                    color: Colors.white, // Couleur du texte en noir
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20), // Espace entre le texte et l'image
                Image.asset(
                  'images/Apropos.png', // Chemin de l'image dans votre projet
                  width: 200, // Largeur de l'image
                  height: 200, // Hauteur de l'image
                  fit: BoxFit.cover, // Ajustement de l'image
                ),
              ],
            ),
          ),
        ),
    );
  }
}