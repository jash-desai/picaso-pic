import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:insta_ui_only/providers/authentication.dart';
import 'package:insta_ui_only/screens/signup_screen.dart';
import 'package:insta_ui_only/widgets/textfield_widget.dart';
import 'package:insta_ui_only/globals/globals.dart';
// import 'package:insta_ui_only/main.dart';
import 'package:insta_ui_only/globals/myColors.dart';
import 'package:provider/provider.dart';
import 'homeBar_screen.dart';
import 'intro_screen.dart';

Future createAlertDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Forgot Password?',
          style: TextStyle(
            color: Colors.pink,
          ),
        ),
        content: Text('Only FrontEnd work done.\ Sorry no BackEnd!'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Oukay!'),
          ),
        ],
      );
    },
  );
}

class LogIn extends StatefulWidget {
  static const route = '/login_screen';
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  String _username, _password, _email;
  var isLoading = false;

  final auth = FirebaseAuth.instance;

  void tryLogIn() async {
    if (!_formKey.currentState.validate()) {
      return null;
    }
    _formKey.currentState.save();

    final authInstance = Provider.of<Authentication>(context, listen: false);

    setState(() {
      isLoading = true;
    });
    try {
      await authInstance.login(_email, _password);

      Navigator.of(context)
          .pushNamedAndRemoveUntil(InstaHome.route, (route) => false);
    } catch (error) {
      authInstance.showError(error.toString(), context);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? kWhite
              : kBlack,
      body: isLoading
          ? Center(
              // show the progress circle while loading
              child: CircularProgressIndicator(
                backgroundColor: Colors.pink.shade300,
                color: Colors.pink.shade300,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 50, 0, 80),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          iconSize: 25,
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 35),
                        child: Image(
                          width: MediaQuery.of(context).size.width * 0.55,
                          image: MediaQuery.of(context).platformBrightness ==
                                  Brightness.light
                              ? AssetImage('assets/images/insta_logo_light.jpg')
                              : AssetImage('assets/images/insta_logo_dark.jpg'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFieldWidget(
                            isEmailAddress: false,
                            height: MediaQuery.of(context).size.height * 0.058,
                            width: MediaQuery.of(context).size.width * 0.9,
                            obscureText: false,
                            hintText: 'Username',
                            prefixIconData: Icons.mail_outline,
                            onChanged: (value) {
                              _username = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter your email!";
                              }
                              if (!value.contains("@") ||
                                  !value.contains(".")) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015),
                          TextFieldWidget(
                            isEmailAddress: false,
                            height: MediaQuery.of(context).size.height * 0.058,
                            width: MediaQuery.of(context).size.width * 0.9,
                            obscureText: true,
                            hintText: 'Password',
                            prefixIconData: Icons.lock_outline,
                            onChanged: (value) {
                              _password = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter your password!";
                              }
                              if (value.length < 6) {
                                return "Please enter a password greater than 6 characters";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 16, 32),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    createAlertDialog(context).then(
                                      (onValue) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Sorry for the feature-less UI :(',
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Builder(
                    builder: (context) => Center(
                      child: GestureDetector(
                        onTap: () async {
                          tryLogIn();
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.blue[500],
                            borderRadius: BorderRadius.circular(5),
                            border: Border.fromBorderSide(BorderSide.none),
                          ),
                          child: InkWell(
                            splashColor: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.055,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Center(
                                child: Text(
                                  'Log In',
                                  style: TextStyle(
                                    color: Global.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.height * 0.01,
                          2 + MediaQuery.of(context).size.height * 0.11,
                          MediaQuery.of(context).size.height * 0.01,
                          MediaQuery.of(context).size.height * 0.01,
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.40,
                          height: 1,
                          color: kGrey.withOpacity(0.3),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.height * 0.01,
                          2 + MediaQuery.of(context).size.height * 0.11,
                          MediaQuery.of(context).size.height * 0.01,
                          MediaQuery.of(context).size.height * 0.01,
                        ),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: kGrey.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.height * 0.01,
                          2 + MediaQuery.of(context).size.height * 0.11,
                          MediaQuery.of(context).size.height * 0.01,
                          MediaQuery.of(context).size.height * 0.01,
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.40,
                          height: 1,
                          color: kGrey.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      MediaQuery.of(context).size.height * 0.06,
                      0,
                      MediaQuery.of(context).size.height * 0.14,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(
                              fontSize: 16,
                              color: kGrey.withOpacity(0.9),
                            ),
                          ),
                          TextSpan(
                            text: ' Sign Up.',
                            style: TextStyle(
                              color: kBlue,
                              fontSize: 16,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context)
                                  .popAndPushNamed(SignUp.route),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.04,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: kGrey.withOpacity(0.3),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Instagram ',
                        style: TextStyle(
                          color: kGrey.withOpacity(0.95),
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        'OT ',
                        style: TextStyle(
                          color: kGrey.withOpacity(0.95),
                          fontSize: 9,
                        ),
                      ),
                      Text(
                        'Facebook ',
                        style: TextStyle(
                          color: kGrey.withOpacity(0.95),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
