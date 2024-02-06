import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_mobile/color/color.dart';
import 'package:project_mobile/components/label_text.dart';

import 'package:project_mobile/components/navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page Example',
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FocusNode _usernameFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void login() {
    String username = _usernameController.text;
    String password = _passwordController.text;
    if (username == 'admin' && password == '1234') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Navbar()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLogo(),
        const LabelText(
          text: 'Welcome to',
          fontSize: 36,
          fontColor: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        // const SizedBox(height: 8.0),
        const LabelText(
          text: 'Your Planet',
          fontSize: 22,
          fontColor: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        Image.asset('assets/images/Solar.png'),
        _buildInputField(
          controller: _usernameController,
          focusNode: _usernameFocus,
          hintText: 'Username',
          nextFocusNode: _passwordFocus,
        ),
        SizedBox(height: 16.0),
        _buildInputField(
          controller: _passwordController,
          focusNode: _passwordFocus,
          hintText: 'Password',
          isPassword: true,
          onEditingComplete: () {
            login();
          },
        ),
        const SizedBox(height: 32.0),
        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                login();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor(colorYellow)),
              child: const LabelText(
                text: 'Login',
                fontSize: 18,
                fontColor: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            orDivider(),
            InkWell(
              onTap: () {
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/Google.png',
                      scale: 20,
                    ),
                    SizedBox(width: 40),
                    Text(
                      'Continue with Google',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: const LabelText(
        text: 'FOCUS YOUR LIFE',
        fontSize: 36,
        fontColor: Colors.black,
        fontWeight: FontWeight.bold,
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
      child: TextField(
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
            child: LabelText(
                text: 'or continue with',
                fontSize: 16,
                fontColor: Colors.white),
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
}
