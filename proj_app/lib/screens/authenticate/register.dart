import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:namer_app/models/user.dart';
import 'package:namer_app/services/auth.dart';
import 'package:namer_app/services/user_database_service.dart';
import 'package:namer_app/screens/home/home.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _error = '';
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  void _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 148, 176, 116),
        elevation: 0.0,
        title: const Text('Register', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                validator: (val) => val!.isEmpty ? 'Enter your name' : null,
                onChanged: (val) {
                  setState(() => _name = val);
                },
              ),
              SizedBox(height: 20.0),
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                obscureText: true,
                validator: (val) {
                  if (val!.length < 6) {
                    return 'Enter a password 6+ characters long';
                  }
                  if (val != _password) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onChanged: (val) {
                  setState(() => _confirmPassword = val);
                },
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: _selectImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                  child: _imageFile == null
                      ? Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                          size: 40,
                        )
                      : null,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: const Text('Register',
                        style: TextStyle(fontSize: 16, color: Colors.white),),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_imageFile == null) {
                      setState(() {
                        _error = 'Please select a profile image';
                      });
                      return;
                    }

                    dynamic result = await _auth.registerWithEmailAndPassword(
                      _email,
                      _password,
                      _name,
                    );

                    if (result != null) {
                      String? imageUrl;
                      try {
                        imageUrl = await UserDatabaseService().uploadProfileImage(_imageFile!);
                      } catch (e) {
                        setState(() {
                          _error = 'Failed to upload image';
                        });
                        return;
                      }

                      try {
                        MyUser user = new MyUser(name: _name, email: _email, profileImage: imageUrl);
                        await UserDatabaseService().addUser(user);
                      } catch (e) {
                        setState(() {
                          _error = 'Failed to save user data';
                        });
                        return;
                      }

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AppHomePage()),
                      );
                    } else {
                      setState(() {
                        _error = 'Please supply a valid email';
                      });
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
              const SizedBox(height: 12.0),
              Text(
                _error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}