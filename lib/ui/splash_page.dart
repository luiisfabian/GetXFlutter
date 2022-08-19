import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 24,),
            Text("Loading", style: TextStyle(fontSize: 24),)
            
          ],
        ),
      ),
    );
  }
}