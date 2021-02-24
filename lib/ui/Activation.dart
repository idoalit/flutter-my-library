import 'dart:convert';

import 'package:bibliography/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Activation extends StatefulWidget {
  @override
  ActivationState createState() => ActivationState();
}

class ActivationState extends State<Activation> {

  TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 48.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Welcome to', style: TextStyle(fontSize: 18),),
            Text('My Library', style: TextStyle(fontSize: 36),),
            Padding(padding: EdgeInsets.only(top: 24.0), child:
            Text('This apps is for research purpose only. Please, enter activation code to use this apps.', textAlign: TextAlign.center,),),
            SizedBox(height: 40.0,),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _codeController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Activation Code',
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(40)),
              child: FlatButton(
                onPressed: () async {

                  Code code = await requestActivation(_codeController.text);

                  if(code.status) {

                    Fluttertoast.showToast(
                        msg: code.message,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );

                    //save state
                    // obtain shared preferences
                    final prefs = await SharedPreferences.getInstance();

                    // set value
                    prefs.setInt('activated', 1);

                    // redirect to home main page
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return MyHomePage();
                    }));

                  } else {

                    Fluttertoast.showToast(
                        msg: code.message,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );

                  }

                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],

        ),
      ),
    );
  }

  Future<Code> requestActivation(String code) async {
    final response = await http.post(
      Uri.http('192.168.100.4:8000', 'activation'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'code': code,
        'key': 'inihanyarandomstringsaja'
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Code.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to activation');
    }
  }
}

class Code {
  final bool status;
  final String message;

  Code({this.status, this.message});

  factory Code.fromJson(Map<String, dynamic> json) {
    return Code(status: json['status'], message: json['message']);
  }
}