import 'package:bike_secure/home.dart';
import 'package:bike_secure/main.dart';
import 'package:bike_secure/screens/LoginScreen.dart';
import 'package:bike_secure/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController mobileNumberTextEditingController =
      TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  Widget build(BuildContext context) {

    String bikeID = getRandomString(8);

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back1.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget>[
              SizedBox(height: 170.0),
              Text(
                'Register Form',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(fontSize: 16.0, color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 10.0),
                ),
                style: TextStyle(fontSize: 16.0),
              ),
              TextField(
                controller: nameTextEditingController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "User Name",
                  labelStyle: TextStyle(fontSize: 16.0, color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 10.0),
                ),
                style: TextStyle(fontSize: 16.0),
              ),
              TextField(
                controller: mobileNumberTextEditingController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  labelStyle: TextStyle(fontSize: 16.0, color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 10.0),
                ),
                style: TextStyle(fontSize: 16.0),
              ),
              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(fontSize: 16.0, color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 10.0),
                ),
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0,),
              Text(
                'your bike ID - $bikeID',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 50.0),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[800],
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0)
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28.0, 16.0, 28.0, 16.0),
                    child: Text(
                      'REGISTER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0
                      ),
                    ),
                  ),
                  onPressed: () async {
              
                    if (nameTextEditingController.text.length < 4) {
                      displayToastMessage(
                          "Name must be atleast 4 charactors!", context);
                    } else if (!emailTextEditingController.text.contains("@")) {
                      displayToastMessage("Email is not valid", context);
                    } else if (mobileNumberTextEditingController.text.isEmpty) {
                      displayToastMessage("Mobile Number is mandatory", context);
                    } else if (passwordTextEditingController.text.length < 7) {
                      displayToastMessage(
                          "Password must be atleast 8 charactors!", context);
                    } else {

                      dynamic result = await registerNewUser(context, bikeID);

                      print('register uid ' + result.uid.toString());

                      Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Home(uid: result.uid,))
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Text('Already Registerd'),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => LoginPage()));
                },
                child: const Text('Login Here',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future registerNewUser(BuildContext context, String bikeID) async {
    final User? firebaseUser = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((err) {
      displayToastMessage("Error: " + err, context);
    })).user;

    String userId = firebaseUser!.uid;

    DatabaseService(uid: userId).updateUserData(
      name: nameTextEditingController.text, 
      email: emailTextEditingController.text,
      password: passwordTextEditingController.text,
      bikeId: bikeID,
      isInDanger: false
    );

    return firebaseUser;

  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
