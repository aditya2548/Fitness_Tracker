import '../theme/color_scheme.dart';

import '../screens/home_screen.dart';
import 'package:flare_flutter/flare_actor.dart';

import '../models/data_model.dart';

import '../models/auth_provider.dart';
import 'package:provider/provider.dart';

import '../screens/login_screen.dart';
import 'package:flutter/material.dart';

//  Sigup screen to create an id
class SignUpScreen extends StatelessWidget {
  static const routeName = "/signup_screen";
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
                    .pushReplacementNamed(LoginScreen.routeName);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                color: CustomColor.buttonColor[900],
                child: Text(
                  DataModel.LOGIN,
                  style: TextStyle(
                    // fontSize: 20,
                    color: Theme.of(context).highlightColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                  child: SignupAuthCard(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupAuthCard extends StatefulWidget {
  const SignupAuthCard({
    Key key,
  }) : super(key: key);

  @override
  _SignupAuthCardState createState() => _SignupAuthCardState();
}

class _SignupAuthCardState extends State<SignupAuthCard> {
  //  teddy animation type
  String animationType = "idle";

  final GlobalKey<FormState> _formKey = GlobalKey();
  //  Map to store all user data
  Map<String, String> _authData = {
    'name': '',
    'email': '',
    'mobileNumber': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

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
    // Sign user up
    final signUpResult = await context
        .read<AuthProvider>()
        .signUpWithEmailAndPassword(_authData, context);
    if (signUpResult == "Signed Up") {
      setState(() {
        animationType = "success";
      });
      Future.delayed(Duration(seconds: 1)).then((value) {
        Navigator.of(context).pop();
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

    setState(() {
      _isLoading = false;
    });
  }

  @override
  //  All the TextFormFields inside a form with appropriate validations
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: CircleAvatar(
              radius: 88,
              backgroundColor: Colors.lightBlue[200],
              child: CircleAvatar(
                backgroundColor: Colors.grey[900],
                radius: 85,
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
        Stack(children: [
          Container(
            margin: EdgeInsets.only(bottom: 80),
            child: Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 8,
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          // style: TextStyle(fontSize: 10),
                          decoration: InputDecoration(
                            labelText: DataModel.NAME,
                            // errorStyle: TextStyle(fontSize: 8),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null ||
                                value.trim() == "" ||
                                value.length < 3) {
                              return DataModel.INVALID_NAME;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['name'] = value;
                          },
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // style: TextStyle(fontSize: 10),
                          decoration:
                              InputDecoration(labelText: DataModel.MOBILE_NUMBER
                                  // errorStyle: TextStyle(fontSize: 8),
                                  ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value.length == 0) {
                              return DataModel.ENTER_MOBILE_NUMBER;
                            } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,10}$)')
                                .hasMatch(value)) {
                              return DataModel.ENTER_VALID_MOBILE_NUMBER;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['mobileNumber'] = value;
                          },
                        ),
                        TextFormField(
                          // style: TextStyle(fontSize: 10),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: DataModel.PASSWORD,
                            // errorStyle: TextStyle(fontSize: 8),
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          controller: _passwordController,
                          validator: (value) {
                            if (value.isEmpty || value.length < 6) {
                              return DataModel.PASSWORD_MIN_LENGTH_LIMIT_ERROR;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['password'] = value;
                          },
                        ),
                        TextFormField(
                          // style: TextStyle(fontSize: 10),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: DataModel.CONFIRM_PASSWORD,
                            // errorStyle: TextStyle(fontSize: 8),
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return DataModel.PASSWORD_DONT_MATCH;
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(FocusNode()),
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
        ]),
      ],
    );
  }
}
