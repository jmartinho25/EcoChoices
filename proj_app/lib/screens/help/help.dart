import 'package:flutter/material.dart';
import 'package:namer_app/services/user_database_service.dart';
import 'package:namer_app/models/user.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  static const List<String> tiles = ["About us", "How to use", "Terms of Service"];
  static const List<IconData> icons = [Icons.info, Icons.help, Icons.policy];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: ListView.separated(
        itemCount: tiles.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(tiles[index]),
            tileColor: Colors.white,
            onTap: () {
              switch (index) {
                case 0:
                  _showAboutUs(context);
                  break;
                case 1:
                  _showHowToUse(context);
                  break;
                case 2:
                  _showTermsOfService(context);
                  break;
              }
            },
            leading: Icon(icons[index]),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          color: Colors.grey,
        ),
      ),
    );
  }

  void _showAboutUs(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('About Us'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "The development of this application was undertaken by students enrolled in the LEIC course at FEUP, as part of their second-year, second-semester Software Engineering course. The team comprised Gonçalo Barros, Hugo Cruz, João Pedro Martinho, Tiago Oliveira, and Tomás Martins.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}


  void _showHowToUse(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('How to Use'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Organize your shopping list:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                    'Start by creating your shopping list. Add products you intend to purchase. Each product will be evaluated based on various sustainability factors.'),
                SizedBox(height: 10),
                Text(
                  '2. View Sustainability Score:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                    'Once your list is complete, a sustainability score will be assigned considering the country of origin, carbon footprint from manufacturing and transportation, price, water used, and chemicals used.'),
                SizedBox(height: 10),
                Text(
                  '3. Get Sustainable Suggestions:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                    'The application will suggest more sustainable product options for each item on your list to increase the overall sustainability score.'),
                SizedBox(height: 10),
                Text(
                  '4. Replace Products Quickly:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                    'You can quickly replace products on your list with the suggested sustainable alternatives.'),
                SizedBox(height: 10),
                Text(
                  '5. Track Your Purchases:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                    'After making your purchases, inform the application to keep track of your shopping history and personal sustainability score.'),
                SizedBox(height: 10),
                Text(
                  '6. Register for More Features:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                    'Create a personal account to maintain your purchase history and calculate your personal sustainability score based on your shopping habits.'),
                SizedBox(height: 10),
                Text(
                  '7. Contribute New Products:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                    'Store owners or employees can submit new products with specific information to the application database. Registered users can flag products if they believe there is false information.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms of Service'),
          content: Text('...'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
