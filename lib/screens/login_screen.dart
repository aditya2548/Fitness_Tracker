import '../theme/color_scheme.dart';
import 'package:flare_flutter/flare_actor.dart';

import '../screens/home_screen.dart';

import '../models/data_model.dart';

import '../dialog/custom_dialog.dart';

import '../models/auth_provider.dart';
import '../screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//  Screen to login with email and password
class LoginScreen extends StatelessWidget {
  static const routeName = "/login_screen";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 5,
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(SignUpScreen.routeName);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: CustomColor.buttonColor[900],
                  child: Text(
                    DataModel.SIGNUP,
                    style: TextStyle(
                      // fontSize: 13,
                      color: Theme.of(context).highlightColor,
                    ),
                  ),
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: LoginAuthCard(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginAuthCard extends StatefulWidget {
  const LoginAuthCard({
    Key key,
  }) : super(key: key);

  @override
  _LoginAuthCardState createState() => _LoginAuthCardState();
}

class _LoginAuthCardState extends State<LoginAuthCard> {
  //  teddy animation type
  String animationType = "idle";

  final GlobalKey<FormState> _formKey = GlobalKey();
  //  Map to store all user data
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid data
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
      animationType = "idle";
    });

    // Login user
    final loginResult = await context
        .read<AuthProvider>()
        .loginWithEmailAndPassword(
            _authData["email"], _authData["password"], context);
    setState(() {
      _isLoading = false;
    });
    if (loginResult == "Logged In") {
      setState(() {
        animationType = "success";
      });
      Future.delayed(Duration(seconds: 1)).then((value) {
        Navigator.pop(context);
        Navigator.of(context).pushReplacementNamed(Home.routeName);
      });
    } else {
      setState(() {
        animationType = "fail";
        Future.delayed(Duration(seconds: 2)).then((value) {
          setState(() {
            animationType = "idle";
          });
        });
      });
    }
  }

  @override
  //  All the TextFormFields inside a form with appropriate validations
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: CircleAvatar(
              radius: 88,
              backgroundColor: Colors.lightBlue[200],
              child: CircleAvatar(
                radius: 85,
                backgroundColor: Colors.grey[900],
                child: ClipOval(
                  child: FlareActor(
                    "assets/teddy.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: animationType,
                  ),
                ),
              ),
            ),
          ),
        ),
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 80),
              child: Card(
                color: Colors.grey[900],
                // color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            // style: TextStyle(fontSize: 10),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: DataModel.EMAIL,
                              // errorStyle: TextStyle(fontSize: 8),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return DataModel.INVALID_EMAIL;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['email'] = value;
                            },
                          ),
                          TextFormField(
                            // style: TextStyle(fontSize: 10),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: DataModel.PASSWORD,
                              // errorStyle: TextStyle(fontSize: 8),
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: (value) {
                              if (value.isEmpty || value.length < 6) {
                                return DataModel
                                    .PASSWORD_MIN_LENGTH_LIMIT_ERROR;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['password'] = value;
                            },
                          ),
                          SizedBox(
                            height: 8,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Center(
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Colors.red[900],
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(20),
            //       ),
            //     ),
            //     child: Text(
            //       "PRIVACY",
            //       style: TextStyle(fontSize: 30),
            //     ),
            //     alignment: Alignment.center,
            //     margin: EdgeInsets.only(top: 40),
            //     height: 60,
            //     width: 150,
            //   ),
            //   // ),
            // ),
            if (_isLoading)
              Positioned(
                  bottom: 15, right: 20, child: CircularProgressIndicator())
            else
              Positioned(
                bottom: 15,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () {
                    _submit();
                  },
                  backgroundColor: CustomColor.buttonColor[900],
                  child: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).highlightColor,
                    size: 30,
                  ),
                ),
              ),
            Positioned(
              bottom: 15,
              left: 5,
              child: FlatButton(
                onPressed: () {
                  CustomDialog.resetPasswordDialog(context);
                },
                child: Text(
                  DataModel.FORGOT_PASSWORD,
                  style: TextStyle(
                    // fontSize: 12,
                    color: CustomColor.buttonColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
