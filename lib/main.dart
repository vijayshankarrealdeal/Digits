import 'dart:ui';
import 'package:d/model.dart';
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Offset> points = [];
  ModelT model = ModelT();
  List pred = [];
  List<ModelCal> hf = [];
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
                    width: 3.0,
                    color: CupertinoColors.activeOrange,
                  ),
                ),
                height: 500,
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
                          hf = [];
                          RenderBox renderBox = context.findRenderObject();
                          points.add(
                              renderBox.globalToLocal(details.globalPosition));
                        });
                      },
                      onPanEnd: (details) async {
                        points.add(null);

                        pred = await model.canvasPt(points);
                        pred.forEach((element) {
                          hf.add(ModelCal.fromJson(element));
                        });

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
              SizedBox(height: 20),
              Expanded(
                  child: Container(
                child: ListView(
                  children: hf
                      .map(
                        (e) => Center(
                          child: Text(
                            "Label " +
                                e.label +
                                "\nConfidence " +
                                e.confidence.round().toString(),
                            style: TextStyle(
                              color: CupertinoColors.activeBlue,
                              fontSize: 17.0,
                              fontFamily: 'SourceSansPro',
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )),
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
                              hf = [];
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
