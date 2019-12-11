import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new MaterialApp(
      title: 'Lazy Calculator',
      theme: new ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: new MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage>{
  List marksArray = [];
  var scrollToEnd = false;

  void buttonPressed(num) {
    scrollToEnd = true;
    setState(() {
      marksArray.add(num);
    });
  }

  void backButtonPressed() {
    scrollToEnd = true;
    setState(() {
      marksArray.removeLast();
    });
  }

  void resetButtonPressed() {
    scrollToEnd = false;
    setState(() {
      marksArray.clear();
    });
  }

  void markPress(int i) {
    scrollToEnd = false;
    setState(() {
      marksArray.removeAt(i);
    });
  }

  String getAverage() {
    if (marksArray.length > 0) {
      double average = 0;
      for (int i = 0; i < marksArray.length; i++) {
        average += marksArray[i];
      }
      return (average / marksArray.length).toStringAsFixed(1);
    }
    else {
      return '0';
    }
  }

  List<Widget> getMarksList() {
    List<Widget> marksList = [];
    for (int i = 0; i < marksArray.length; i++){
      Color color;
      if (marksArray[i] > 9) {
        color = Colors.greenAccent;
      } else if (marksArray[i] > 5) {
        color = Colors.yellow;
      } else {
        color = Colors.deepOrange;
      }
      marksList.add(SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.height * 0.08,
        child: Container(
          padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
          child: RaisedButton(
            color: color,
            child: Text(marksArray[i].toString()),
            onPressed: (){
              markPress(i);
            },
          ),
        )
      ));
    }

    if (scrollToEnd){
      Timer(Duration(milliseconds: 50), () => _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeOut));
    }
    if (marksList.length > 0){
      return marksList;
    } else {
      return new List<Widget>();
    }
  }

  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      appBar: AppBar(
        title: Text('Калькулятор'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Row (
                    children: <Widget>[
                      Expanded(
                        child: Container(
//                          height: 80,
                          padding: EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            tooltip: 'Стерти останню введену оцінку',
                            onPressed: backButtonPressed,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
//                          height: 0,
                          padding: EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.delete_outline),
                            tooltip: 'Очистити все',
                            onPressed: resetButtonPressed,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
//                          height: 50,
                          padding: EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.info_outline),
                            tooltip: 'Про додаток',
                            onPressed: (){
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                      title: Text('Про додаток'),
                                      content: SingleChildScrollView(
                                        child: Table(
                                          children: <TableRow>[
                                            TableRow(
                                              children: <Widget>[
                                                TableCell(
                                                  child: Text('Назва:'),
                                                ),
                                                TableCell(
                                                  child: Text('Калькулятор'),
                                                )
                                              ]
                                            ),
                                            TableRow(
                                                children: <Widget>[
                                                  TableCell(
                                                    child: Text('Версія:'),
                                                  ),
                                                  TableCell(
                                                    child: Text('1.0'),
                                                  )
                                                ]
                                            ),
                                            TableRow(
                                                children: <Widget>[
                                                  TableCell(
                                                    child: Text('Автор:'),
                                                  ),
                                                  TableCell(
                                                    child: Text('YuriyBl'),
                                                  )
                                                ]
                                            ),
                                          ],
                                        )
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('OK'),
                                        )
                                      ],
                                  );
                                }
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  )
                ),
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Text(
                      getAverage(),
                      style: averageTextStyle(num.parse(getAverage()))
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: ListView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        children: getMarksList(),
                      ),
                    ),
                ),
              ],
            )
          ),
          Expanded (
            flex: 3,
            child: Container(
//              color: Color.fromRGBO(250, 0, 0, 1),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        button(10, buttonPressed, Colors.blue[400]),
                        button(11, buttonPressed, Colors.blue[400]),
                        button(12, buttonPressed, Colors.blue[400]),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        button(7, buttonPressed, Colors.blue[300]),
                        button(8, buttonPressed, Colors.blue[300]),
                        button(9, buttonPressed, Colors.blue[300]),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        button(4, buttonPressed, Colors.blue[200]),
                        button(5, buttonPressed, Colors.blue[200]),
                        button(6, buttonPressed, Colors.blue[200]),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        button(1, buttonPressed, Colors.blue[100]),
                        button(2, buttonPressed, Colors.blue[100]),
                        button(3, buttonPressed, Colors.blue[100]),
                      ],
                    ),
                  ),
                ],
              )
            )
          )

        ],
      ),
    );
  }
}

Widget button(num, pressedFunction, color) {
  return Expanded(
    child: Container(
      height: 1000,
      padding: EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: (){pressedFunction(num);},
        color: color,
        child: Text(
            num.toString(),
            style: buttonTextStyle
        ),
      ),
    ),
  );
}

TextStyle buttonTextStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.w400,
  fontFamily: "Roboto",
);

TextStyle averageTextStyle(num) {
  Color color;
  if (num >= 10) {
    color = Colors.green;
  } else if (num >= 5) {
    color = Colors.orange;
  } else {
    color = Colors.redAccent;
  }
  return TextStyle(
    fontSize: 50,
    fontWeight: FontWeight.w600,
    fontFamily: "Roboto",
    color: color
  );
}

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }
}