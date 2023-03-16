import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double stageOffset = 0;
  double playerPosY = 0;
  bool isJumping = false;
  bool isFinished = false;
  bool isGameOver = false;

  void resetGame() {
    setState(() {
      stageOffset = 0;
      playerPosY = 0;
      isJumping = false;
      isFinished = false;
      isGameOver = false;
    });
  }

  void scrollStage() {
    setState(() {
      stageOffset += 1;
      if (stageOffset >= 200) {
        isFinished = true;
      }
    });
  }

  void jumpPlayer() {
    if (!isJumping && !isFinished && !isGameOver) {
      isJumping = true;
      Timer.periodic(Duration(milliseconds: 100), (timer) {
        setState(() {
          playerPosY += 1;
        });

        if (playerPosY >= 3) {
          timer.cancel();
          Timer.periodic(Duration(milliseconds: 100), (timer) {
            setState(() {
              playerPosY -= 1;
            });

            if (playerPosY <= 0) {
              isJumping = false;
              timer.cancel();
            }
          });
        }
      });
    }
  }

  @override
  void initState() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (!isFinished && !isGameOver) {
        scrollStage();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isFinished) {
      return GestureDetector(
        onTap: resetGame,
        child: Center(
          child: Text(
            'FINISH',
            style: TextStyle(fontSize: 32),
          ),
        ),
      );
    }
    if (isGameOver) {
      return GestureDetector(
        onTap: resetGame,
        child: Center(
          child: Text(
            'GAME OVER',
            style: TextStyle(fontSize: 32),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: jumpPlayer,
      child: Stack(
        children: [
          // Display scrolled distance
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              'Scrolled: ${stageOffset.toInt()}',
              style: TextStyle(fontSize: 20),
            ),
          ),

          // Draw ground with '-' characters
          Positioned(
            left: -stageOffset * 10,
            top: MediaQuery.of(context).size.height / 2,
            child: Container(
              width: MediaQuery.of(context).size.width + stageOffset * 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(200, (index) => Text('-')),
              ),
            ),
          ),

          // Draw some objects to make scrolling more noticeable
          Positioned(
            left: (-stageOffset * 10 + 150) % (MediaQuery.of(context).size.width - 20),
            top: MediaQuery.of(context).size.height / 2 - 20,
            child: Container(
              width: 20,
                            height: 20,
              color: Colors.orange,
            ),
          ),
          Positioned(
            left: (-stageOffset * 10 + 300) % (MediaQuery.of(context).size.width - 20),
            top: MediaQuery.of(context).size.height / 2 - 40,
            child: Container(
              width: 20,
              height: 20,
              color: Colors.orange,
            ),
          ),

          // Draw player
          Positioned(
            left: 32, // 画面左端から32pxの間を空ける
            bottom: (playerPosY * 10) + (MediaQuery.of(context).size.height / 2) - 20,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Check if the player collides with the object
          Positioned(
            left: (-stageOffset * 10 + 150) % (MediaQuery.of(context).size.width - 20),
            top: MediaQuery.of(context).size.height / 2 - 20,
            child: GestureDetector(
              onTap: () {
                if (!isJumping &&
                    ((-stageOffset * 10 + 150) % (MediaQuery.of(context).size.width - 20) - 32).abs() < 20) {
                  setState(() {
                    isGameOver = true;
                  });
                }
              },
              child: Container(width: 1, height: 1),
            ),
          ),
        ],
      ),
    );
  }
}

