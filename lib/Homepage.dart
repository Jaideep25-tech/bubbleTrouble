import 'dart:async';

import 'package:bubble_trouble/ball.dart';
import 'package:bubble_trouble/button.dart';
import 'package:bubble_trouble/missile.dart';
import 'package:bubble_trouble/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

enum direction { LEFT, RIGHT }

class _HomepageState extends State<Homepage> {
  static double playerX = 0;
  double missileX = playerX;
  double missileHeight = 10;
  bool midshot = false;
  double ballX = 0.5;
  double ballY = 0;
  var balldirection = direction.LEFT;

  void moveLeft() {
    setState(() {
      if (playerX - 0.1 < -1) {
        //do nothing
      } else {
        playerX -= 0.1;
      }
      if (!midshot) {
        missileX = playerX;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (playerX + 0.1 > 1) {
        //do nothing
      } else {
        playerX += 0.1;
      }
      if (!midshot) {
        missileX = playerX;
      }
    });
  }

  void firemissile() {
    if (midshot == false) {
      Timer.periodic(Duration(milliseconds: 20), (timer) {
        midshot = true;
        setState(() {
          missileHeight += 10;
        });
        if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
          resetMissile();
          timer.cancel();
        }
        if(ballY>heighToCoordinate(missileHeight) && (ballX-missileX).abs()<0.03){
          resetMissile();
          ballX=5;
          timer.cancel();
        }
      });
    }
  }

  double heighToCoordinate(double height) {
    double totalHeight = MediaQuery.of(context).size.height*3/4;
    double position = 1-2*height/totalHeight;
    return position;
  }

  void resetMissile() {
      missileX = playerX;
      missileHeight = 0;
      midshot = false;
  }

  bool playerDies(){
    if((ballX-playerX).abs()<0.05 && ballY >0.95){
      return true;
    }else{
      return false;
    }
  }

  void startGame() {
    double time=0;
    double height=0;
    double velocity=60;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      height =-5*time*time+velocity*time;
      if(height<0){
        time=0;
      }
      setState(() {
        ballY=heighToCoordinate(height);
      });
      time += 0.1;
      if (ballX - 0.005 < -1) {
        balldirection = direction.RIGHT;
      } else if (ballX + 0.005 > 1) {
        balldirection = direction.LEFT;
      }
      if (balldirection == direction.LEFT) {
        setState(() {
          ballX -= 0.005;
        });
      } else if (balldirection == direction.RIGHT) {
        setState(() {
          ballX += 0.005;
        });
      }
      if(playerDies()){
        timer.cancel();
        _showDialog();
      }
    });
  }

  void _showDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: Colors.grey[700],
            title: Center(
              child: Text(
                "You dead bro", 
                style: TextStyle(color: Colors.white),
                )
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
        if (event.isKeyPressed(LogicalKeyboardKey.space)) {
          firemissile();
        }
      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.pink[100],
              child: Center(
                child: Stack(
                  children: [
                    MyBall(ballX: ballX, ballY: ballY),
                    MyMissile(missileX: missileX, height: missileHeight),
                    Myplayer(
                      playerX: playerX,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
                color: Colors.grey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyButton(
                      icon: Icons.play_arrow,
                      function: startGame,
                    ),
                    MyButton(
                      icon: Icons.arrow_back,
                      function: moveLeft,
                    ),
                    MyButton(
                      icon: Icons.arrow_upward,
                      function: firemissile,
                    ),
                    MyButton(
                      icon: Icons.arrow_forward,
                      function: moveRight,
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
