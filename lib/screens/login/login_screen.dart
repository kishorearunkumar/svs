import 'package:flutter/material.dart';
import 'package:svs/services/api_service.dart';
import 'dart:convert';
import 'package:svs/models/user.dart';
import 'package:svs/models/login-response.dart';
import 'package:svs/utils/app_shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final globalKey = new GlobalKey<ScaffoldState>();

  String _username;
  String _password;
  bool _isLoading = false;
  bool _isRememberMe = false;
  User rememberMe = User(userName: "", password: "");
  final TextEditingController userNameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    setUserPassword();
  }

//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      body: Center(
        child: loginBody(),
      ),
    );
  }
//------------------------------------------------------------------------------

  loginUser() async {
    if (_formKey.currentState.validate()) {
      setState(() => _isLoading = true);

      User user = User(userName: _username, password: _password);

      login(user).then((response) {
        if (response.statusCode == 201) {
          LoginResponse loginResponse =
              loginResponseFromJson(Utf8Codec().decode(response.bodyBytes));
          AppSharedPreferences.setUserLoggedIn(true);
          AppSharedPreferences.setUserProfile(loginResponse);
          if (_isRememberMe) {
            AppSharedPreferences.setRememberMe(user);
          } else {
            AppSharedPreferences.clearRememberMe();
          }

          Navigator.pushReplacementNamed(context, "/home");
        } else {
          globalKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: new Text("Invalid Username or Password !!"),
          ));
          setState(() => _isLoading = false);
        }
      }).catchError((error) {
        print('error : $error');
        globalKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("No Internet Connection. Loading Offline Content."),
        ));
        setState(() => _isLoading = false);
      });
    }
  }

  Future<void> setUserPassword() async {
    try {
      rememberMe = await AppSharedPreferences.getRememberMe();
      setState(() {
        userNameController.text = rememberMe.userName;
        passwordController.text = rememberMe.password;
        if (userNameController.text == "" &&
            passwordController.text == "" &&
            userNameController.text.isEmpty &&
            passwordController.text.isEmpty) {
          _isRememberMe = false;
        } else {
          _isRememberMe = true;
        }
      });
    } catch (e) {
      print(e);
    }
  }

//------------------------------------------------------------------------------

  loginBody() => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[loginHeader(), loginFields()],
        ),
      );

//------------------------------------------------------------------------------
  loginHeader() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset('assets/images/svs.png',
              alignment: Alignment.center, width: 175.0),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Cable and Internet Billing Software",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18.0,
                color: new Color(0xffae275f)),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            "Sign in to continue",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      );

//------------------------------------------------------------------------------

  loginFields() => Container(
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
                  child: TextFormField(
                    controller: userNameController,
                    maxLines: 1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter username';
                      }
                      _username = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter your username",
                      labelText: "Username",
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                  child: TextFormField(
                    controller: passwordController,
                    maxLines: 1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter password';
                      }
                      _password = value;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      labelText: "Password",
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        activeColor: Color(0xffae275f),
                        onChanged: (value) {
                          setState(() {
                            _isRememberMe = value;
                          });
                        },
                        value: _isRememberMe,
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_isRememberMe == false) {
                                _isRememberMe = true;
                              } else {
                                _isRememberMe = false;
                              }
                            });
                          },
                          child: Text("Remember me")),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 15.0,
                // ),
                _isLoading
                    ? new CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 30.0),
                        width: double.infinity,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: FloatingActionButton(
                                mini: true,
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                                backgroundColor: Color(0xffae275f),
                                foregroundColor: Colors.white,
                                onPressed: () {
                                  loginUser();
                                },
                                child: Text("SIGN IN"),
                              ),
                            ),
                            // Container(
                            //   height: 20.0,
                            //   width: 1.0,
                            //   color: Colors.black38,
                            //   margin: const EdgeInsets.only(
                            //       left: 10.0, right: 10.0),
                            // ),
                            // Expanded(
                            //   child: FloatingActionButton(
                            //     mini: true,
                            //     shape: StadiumBorder(
                            //       side: BorderSide(
                            //         color: Color(0xffae275f),
                            //         width: 1.0,
                            //       ),
                            //     ),
                            //     backgroundColor: Colors.white,
                            //     onPressed: () {
                            //       return null;
                            //     },
                            //     foregroundColor: Color(0xffae275f),
                            //     child: Text("REGISTER"),
                            //   ),
                            // )
                          ],
                        )),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "www.getsvs.in",
                  style: TextStyle(color: new Color(0xffae275f)),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "Help : +91 91768 17574 / 98843 17574",
                  style: TextStyle(color: Colors.black54),
                )
              ],
            )),
      );
}
