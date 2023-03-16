import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: HolographicCard(),
        ),
      ),
    );
  }
}

class HolographicCard extends StatefulWidget {
  @override
  _HolographicCardState createState() => _HolographicCardState();
}

class _HolographicCardState extends State<HolographicCard> {
  double xOffset = 0;
  double yOffset = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          xOffset += details.delta.dx / 100; // 傾きを緩やかにする
          yOffset -= details.delta.dy / 100; // 傾きを緩やかにする
        });
      },
      onPanEnd: (details) {
        setState(() {
          xOffset = 0;
          yOffset = 0;
        });
      },
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(yOffset)
          ..rotateY(xOffset),
        alignment: FractionalOffset.center,
        child: Container(
          width: 200,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.withOpacity(1 - xOffset.abs() / 1.5),
                Colors.purple.withOpacity(1 - xOffset.abs() / 1.5),
                Colors.pink.withOpacity(1 - yOffset.abs() / 1.5),
                Colors.orange.withOpacity(1 - yOffset.abs() / 1.5),
              ],
              stops: [0.1, 0.3, 0.8, 1],
            ),
          ),
        ),
      ),
    );
  }
}
