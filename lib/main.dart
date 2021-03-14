import 'package:d/modelLoad.dart';
import 'package:d/paint.dart';
import 'package:flutter/cupertino.dart';
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
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(),
    );
  }
}

const double kCanvasSize = 200;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ModelT model = ModelT();
  List<Offset> points = [];

  @override
  void initState() {
    super.initState();
    model.loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 8.0,
                    color: CupertinoColors.activeOrange,
                  ),
                ),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.85,
                padding: EdgeInsets.all(8),
                child: Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          RenderBox renderBox = context.findRenderObject();
                          points.add(
                              renderBox.globalToLocal(details.globalPosition));
                        });
                      },
                      onPanStart: (details) {
                        setState(() {
                          RenderBox renderBox = context.findRenderObject();
                          points.add(
                              renderBox.globalToLocal(details.globalPosition));
                        });
                      },
                      onPanEnd: (details) async {
                        points.add(null);
                        List pred = await model.canvasPt(points);
                        print(pred);
                        setState(() {});
                      },
                      child: ClipRRect(
                        child: CustomPaint(
                          size: Size(kCanvasSize, kCanvasSize),
                          painter: DrawingPainter(
                            offsetPoints: points,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(16),
                  color: CupertinoColors.secondarySystemFill,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      CupertinoButton(
                          child: Text('Clear'),
                          onPressed: () {
                            setState(() {
                              points = [];
                            });
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
