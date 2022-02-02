import 'package:flutter/material.dart';

class Myplayer extends StatelessWidget {
  
  final playerX;

  Myplayer({this.playerX});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(playerX, 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 50,
          width: 50,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}