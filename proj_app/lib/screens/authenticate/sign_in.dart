import 'package:flutter/material.dart';
import 'package:namer_app/screens/home/home.dart'; // Importando a HomePage
import 'package:namer_app/services/auth.dart';
import 'package:namer_app/screens/authenticate/register.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Sign In', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 148, 176, 116),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => _email = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  obscureText: true,
                  validator: (val) => val!.length < 6 ? 'Enter a password 6+ characters long' : null,
                  onChanged: (val) {
                    setState(() => _password = val);
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  child: const Text('Sign In',
                        style: TextStyle(fontSize: 16, color: Colors.white),),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      dynamic result = await _auth.signInWithEmail(_email, _password);
                      if (result == null) {
                        setState(() {
                          _error = 'Could not sign in with those credentials';
                        });
                      } else {
                        // Navegar para a HomePage após login bem-sucedido
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AppHomePage()),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 148, 176, 116),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  child: const Text('Register',
                        style: TextStyle(fontSize: 16, color: Colors.white),),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
                SizedBox(height: 12.0),
                Text(
                  _error,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
