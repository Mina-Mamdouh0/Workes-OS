
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workosaribic/screens/auth/login.dart';
import 'package:workosaribic/screens/tasksscreen.dart';

class UserStates extends StatelessWidget {
  const UserStates({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,userSnapshot){
        if(!userSnapshot.hasData){
          return const LoginScreen();
        }
        else if(userSnapshot.hasData){
          return TasksScreen();
        }
        else if(userSnapshot.hasError){
          return const Center(
            child: Text('The app error',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),),
          );
        }
        return const Scaffold(
          body:  Center(
            child: Text('something Want',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),),
          ),
        );
        });
  }
}
