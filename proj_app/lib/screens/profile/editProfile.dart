import 'package:flutter/material.dart';
import 'dart:io';
import 'package:namer_app/models/user.dart';
import 'package:namer_app/screens/home/home.dart';
import 'package:namer_app/services/auth.dart';
import 'package:namer_app/services/user_database_service.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  File? _imageFile;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      // Carregar dados do usuário apenas se for necessário exibi-los em algum lugar
      // MyUser user = await UserDatabaseService().getUserByEmail(_auth.getCurrentUserEmail() ?? '');
    } catch (error) {
      print('Error loading user profile: $error');
    }
  }

  void _selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 148, 176, 116),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              _imageFile != null
                  ? Image.file(_imageFile!, height: 150)
                  : Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: Center(
                        child: Text(
                          'No image selected',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
              SizedBox(height: 16.0),
              Center(
                child: TextButton(
                  onPressed: _selectImage,
                  child: Text('Select Image'),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Update user profile data in Firestore
                      try {
                        // Determine the profile image URL if an image is selected
                        if (_imageFile != null) {
                          _imageUrl = await UserDatabaseService().uploadProfileImage(_imageFile!);
                          // Atualizar os dados do usuário no Firestore com a nova imagem
                          await UserDatabaseService().updateUserProfileWithImage(_auth.getCurrentUserEmail() ?? '', _imageUrl ?? '');
                          // Mostrar mensagem de sucesso ou voltar para a página anterior
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Profile updated successfully!'),
                          ));
                          // Navegar de volta para a página inicial após a atualização bem-sucedida
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => AppHomePage()),
                          );
                        }
                      } catch (error) {
                        // Mostrar mensagem de erro
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to update profile: $error'),
                        ));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 148, 176, 116),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
