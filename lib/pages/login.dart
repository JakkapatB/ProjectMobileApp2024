import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_mobile/color/color.dart';
import 'package:project_mobile/components/label_text.dart';

import 'package:project_mobile/components/navbar.dart';
import 'package:project_mobile/service/auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/Star.png'),
                fit: BoxFit.contain,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.6, 1.0],
                colors: [
                  HexColor(bgColorBlue),
                  HexColor(colorPink),
                ],
              ),
            ),
            padding: const EdgeInsets.all(40),
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  FocusNode _usernameFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();

  String email = "", password = "";

  TextEditingController mailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Navbar()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 18.0),
            )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 18.0),
            )));
      }
    }
  }

  @override
  void dispose() {
    mailController.dispose();
    passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLogo(widthAndHeight: 200),
        // Image.asset('assets/images/Solar.png'),
        const SizedBox(height: 32.0),
        _buildInputWidget(),
        const SizedBox(height: 32.0),
        _buildButtonLogin()
      ],
    );
  }

  Widget _buildLogo({required double widthAndHeight}) {
    return Container(
      width: widthAndHeight,
      height: widthAndHeight,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/logo.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    bool isPassword = false,
    FocusNode? nextFocusNode,
    void Function()? onEditingComplete,
  }) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please Enter $hintText';
          }
          return null;
        },
        controller: controller,
        focusNode: focusNode,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 3.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onEditingComplete: () {
          if (onEditingComplete != null) {
            onEditingComplete();
          }
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }

  Widget _buildInputWidget() {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          _buildInputField(
            controller: mailController,
            focusNode: _usernameFocus,
            hintText: 'E-mail',
            nextFocusNode: _passwordFocus,
          ),
          const SizedBox(height: 16.0),
          _buildInputField(
            controller: passwordController,
            focusNode: _passwordFocus,
            hintText: 'Password',
            isPassword: true,
            onEditingComplete: () {},
          ),
        ],
      ),
    );
  }

  Widget orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              color: Colors.white,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: LabelText(text: 'or', fontSize: 16, fontColor: Colors.white),
          ),
          Flexible(
            child: Container(
              height: 1,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonLogin() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (_formkey.currentState!.validate()) {
              setState(() {
                email = mailController.text;
                password = passwordController.text;
              });
            }
            userLogin();
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: HexColor(colorYellow),
            ),
            width: double.infinity,
            child: const Text(
              'LOGIN',
              style: TextStyle(
                  // color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        orDivider(),
        InkWell(
          onTap: () {
            AuthMethods().signInWithGoogle(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Google.png',
                  scale: 20,
                ),
                const SizedBox(width: 2),
                const Text(
                  'Continue with Google',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
