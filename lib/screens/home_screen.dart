import '../models/auth_provider.dart';
import '../models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  static const routeName = "/home_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton.icon(
          color: Theme.of(context).errorColor,
          onPressed: () {
            Provider.of<AuthProvider>(context, listen: false)
                .signOutUser(context);
          },
          icon: Icon(Icons.logout),
          label: Text(DataModel.SIGN_OUT),
        ),
      ),
    );
  }
}
