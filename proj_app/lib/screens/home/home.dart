import 'package:flutter/material.dart';
import '../profile/profile.dart';
import '../List/list.dart';
import '../help/help.dart';
import 'package:namer_app/screens/Products/products.dart';

class AppHomePage extends StatefulWidget {
  @override
  _AppHomePageState createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ProductsPage(),
    ListPage(),
    HelpPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('EcoChoices',  style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 148, 176, 116),
          actions: [Builder(
            builder: (context){
              return IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              }
            );
            }
          )
            
          ],
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          backgroundColor: Colors.grey[400],
          selectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Lists',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help),
              label: 'Help',
            )
          ],
        ),
      ),
    );
  }
}