import 'package:flutter/material.dart';
import 'package:namer_app/models/user.dart'; // Import the MyUser class
import 'package:namer_app/services/auth.dart';
import 'package:namer_app/screens/profile/editProfile.dart';
import 'package:namer_app/screens/authenticate/sign_in.dart';
import 'package:namer_app/services/user_database_service.dart';

class ProfilePage extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 148, 176, 116),
      ),
      body: FutureBuilder<MyUser>(
        future: _loadUserProfile(), // Load the user profile asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading user profile.'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('User profile is empty.'));
          } else {
            MyUser myUser = snapshot.data!;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(myUser.profileImage ?? ''),
                    ),
                    SizedBox(height: 20),
                    Text(
                      myUser.name ?? 'No Name',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      myUser.email ?? 'No Email',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 148, 176, 116),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Function to load the user profile asynchronously
  Future<MyUser> _loadUserProfile() async {
    String email = _auth.getCurrentUserEmail() ?? '';
    try {
      MyUser myUser = await UserDatabaseService().getUserByEmail(email);
      return myUser;
    } catch (error) {
      throw Exception('Failed to load user profile: $error');
    }
  }
}
