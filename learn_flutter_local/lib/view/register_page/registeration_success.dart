import 'package:flutter/material.dart';
import 'package:learn_flutter/view/profile_page/profile.dart';

class RegisterSuccessPage extends StatelessWidget {
  final userID;
  const RegisterSuccessPage({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registeration Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Registeration Successful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            userID: userID,
                          )),
                );
              },
              child: Text('Go to your profile'),
            ),
          ],
        ),
      ),
    );
  }
}
