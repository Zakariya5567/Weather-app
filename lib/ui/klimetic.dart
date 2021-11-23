
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import '../util/utils.dart' as util;

class Klimetic extends StatefulWidget {
  @override
  _KlimeticState createState() => _KlimeticState();
}

class _KlimeticState extends State<Klimetic> {
  String _cityEntered;
  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator
        .of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
          return new ChangeCity();
        }));
    setState(() {
      if(results != null && results.containsKey('enter')){
        _cityEntered=results['enter'];
      }
    });

  }

  void showStuff() async {
    Map data = await getWeather(util.appId, util.defaultCity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new Text("Kilmetic Weather"),
        backgroundColor: Colors.red,
        actions: [
          new IconButton(
            onPressed: () {
              _goToNextScreen(context);
            },
            icon: Icon(Icons.search),
          )
        ], //appbar action
      ),
      body: new Stack(
        children: [
          new Center(
            child: Image.asset('images/umbrella.png',
              width: 490.0, height: 1200.0,
              fit: BoxFit.fill,),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 0.0),
            child: new Text(
              '${_cityEntered==null?  util.defaultCity:_cityEntered}',
              style: cityStyle(),
            ),
          ), //Caontainer for City Text
          new Container(
            alignment: Alignment.center,
            child: Image.asset('images/light_rain.png'),
          ), //Container for weather image
          new Container(
            margin: const EdgeInsets.fromLTRB(20.0, 390.0, 0.0, 0.0),
            child: updateTempWidget(_cityEntered ),
          ) //Container for weather detail
        ], //Stack children

      ),
    );
  } //Widget build
  Future<Map> getWeather(String appId, String city) async {
    String apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util
        .appId}&units=imperial';
    http.Response response = await http.get(Uri.parse(apiUrl));
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return FutureBuilder(
        future: getWeather(util.appId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
              child: new Column(
                children: [
                  new ListTile(
                    title: new Text("${content['main']['temp']}F".toString(),
                      style: new TextStyle(
                          color: Colors.white, fontSize: 40.0,fontWeight: FontWeight.w900)),
                    subtitle:new Text("Humidity: ${content['main']['humidity'].toString()}\n"
                                      "Max: ${content['main']['temp_max'].toString()}F\n"
                                      "min: ${content['main']['temp_min'].toString()}F\n"
                        ,style:new TextStyle(color: Colors.white,fontSize: 24.0) ,)
                    ),
                ],
              ),
            );
          }
          else {
            return new Container();
          }
        }
    );
  }
} //KlimeticState

class ChangeCity extends StatelessWidget {
  const ChangeCity({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _cityController = new TextEditingController();
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Change City"),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: new Stack(
        children: [
          new Center(
            child: new Image.asset('images/white_snow.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,),
          ),
          new ListView(
            children: [
              new ListTile(
                title: new TextField(
                  controller: _cityController,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      hintText: "Enter City"
                  ),
                ),
              ),
              new FlatButton(
                  child: new Text("Search"),
                  color:Colors.cyan,
                  onPressed: () {
                    Navigator.pop(context,{
                    'enter':_cityController.text,
                    });
                  },
                ),
            ],
          )
        ],
      ),
    );
  }
}


TextStyle cityStyle() {
  return TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 24.0,
    fontStyle: FontStyle.italic,
  );
}
TextStyle tempStyle() {
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    fontSize: 39.0,
  );
}
