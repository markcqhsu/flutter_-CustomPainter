import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;

  AnimationController _controller;
  List<Snowflake> _snowflakes = List.generate(1000, (index) => Snowflake());

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints.expand(),
          //把畫面佔據到畫面最大, 類似Android的fill parent
          // width: double.infinity, 為了佔滿整個畫面, 可以直接給他一個很大的值, 由flutter來自動修正成螢幕大小
          // height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ Colors.blue, Colors.lightBlue, Colors.white],
              stops: [0.0, 0.7, 0.95],
            ),
          ),
          // color: Colors.blue,
          child: AnimatedBuilder(
            animation: _controller,

            builder: (_, __) {
              _snowflakes.forEach((snow) {
                snow.fall();
              });
              return CustomPaint(
                painter: MyPainter(_snowflakes),
              );
            },
            // child: CustomPaint(
            //   painter: MyPainter(),
            // ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  List<Snowflake> _snowflakes;

  MyPainter(this._snowflakes);

  @override
  void paint(Canvas canvas, Size size) {
    //Size是指畫布的大小
    print(size);
    // canvas.drawCircle(Offset(size.width/2, size.height/2), 20.0, Paint());
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(size.center(Offset(0, 100)), 60.0, whitePaint);
    canvas.drawOval(
        Rect.fromCenter(
          center: size.center(Offset(0, 270)),
          width: 200,
          height: 250,
        ),
        whitePaint);
    // final snowflake = Snowflake();
    _snowflakes.forEach((snowflake) {
      canvas.drawCircle(
          Offset(snowflake.x, snowflake.y), snowflake.radius, whitePaint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Snowflake {
  double x = Random().nextDouble()*428;
  double y = Random().nextDouble()*823;
  double radius = Random().nextDouble() *2 +2;
  double velocity = Random().nextDouble() *4 +2;

  fall(){
    y += velocity;
    if(y>823){
      y = 0;
      x = Random().nextDouble()*428;
      radius = Random().nextDouble() *2 +2;
      velocity = Random().nextDouble() *4 +2;
    }
  }
}
