import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smartHome/widgets/form_submit_button.dart';
import '../providers/auth.dart';
import '../widgets/heading_lable_card.dart';
import '../widgets/social_login_card.dart';

import '../containts.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  String _email;
  String _password;
  String _confirmPassword;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AuthMode _authMode = AuthMode.Login;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Ocurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Okay'))
        ],
      ),
    );
  }

  void switchAuthMode() {
    setState(() {
      _authMode =
          _authMode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
    });
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: kTextFieldStyle.copyWith(labelText: "Email"),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onFieldSubmitted: (_value) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }
        _email = value;
        return null;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: kTextFieldStyle.copyWith(labelText: "Password"),
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      focusNode: _passwordFocusNode,
      onFieldSubmitted: (_value) {
        FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is Required';
        }
        _password = value;
        return null;
      },
    );
  }

  Widget _buildConfirmPassword() {
    return TextFormField(
      decoration: kTextFieldStyle.copyWith(labelText: "Confirm Password"),
      keyboardType: TextInputType.visiblePassword,
      focusNode: _confirmPasswordFocusNode,
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Confirm password is Required';
        }

        if (value != _password) {
          return 'Confirm Password not matched';
        }
        _confirmPassword = value;
        return null;
      },
    );
  }

  Widget _buildTextLink(lable, onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: GestureDetector(
        child: new Text(
          lable,
          style: TextStyle(
            color: Colors.blueAccent,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              HeadingLableCard(
                heading: _authMode == AuthMode.Login ? "Sign In" : "Sign up",
                lable:
                    "Sign in by your ID to user our services and other features",
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildEmail(),
                    _buildPassword(),
                    if (_authMode == AuthMode.Signup) _buildConfirmPassword(),
                    _buildTextLink(
                        _authMode == AuthMode.Login
                            ? "Don't you have a account ?"
                            : "Already  have an account ?", () {
                      switchAuthMode();
                    }),
                  ],
                ),
              ),
              SocialLoginCard(),
              FormSubmitButton(
                lable: 'Submit',
                onPress: () async {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  _formKey.currentState.save();
                  try {
                    if (_authMode == AuthMode.Login) {
                      // Log user in
                      await Provider.of<Auth>(context, listen: false)
                          .login(_email, _password);
                    } else {
                      // Sign user up
                      await Provider.of<Auth>(context, listen: false)
                          .signup(_email, _password);
                    }
                  } catch (error) {
                    var errorMessage = 'Authenticate Failed';
                    print(error);
                    if (error.toString().contains('wrong-password')) {
                      errorMessage = 'Invalid Password!';
                    } else if (error.toString().contains('user-not-found')) {
                      errorMessage = 'User Not Found';
                    } else if (error
                        .toString()
                        .contains('email-already-in-use')) {
                      errorMessage = 'Email Already In Use';
                    }
                    _showErrorDialog(errorMessage);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
