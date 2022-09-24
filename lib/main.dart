import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workosaribic/screens/auth/login.dart';
import 'package:workosaribic/user_states.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _futureFireBase=Firebase.initializeApp();
   MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureFireBase,
        builder:(context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'WorkOs Arabic',
            theme: ThemeData(
              scaffoldBackgroundColor:const Color(0xFFEDE7Dc),
              primarySwatch: Colors.blue,
            ),
            home: const Scaffold(
              body: Center(
                 child: Text('The app loading',
                 style: TextStyle(
                   fontSize: 30,
                   fontWeight: FontWeight.bold,
                   color: Colors.black,
                 ),),
              ),
            ),
          );
        }
        else if(snapshot.hasError){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'WorkOs Arabic',
            theme: ThemeData(
              scaffoldBackgroundColor:const Color(0xFFEDE7Dc),
              primarySwatch: Colors.blue,
            ),
            home: const Scaffold(
              body: Center(
                child: Text('The app error',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),),
              ),
            ),
          );
        }
        else{
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'WorkOs Arabic',
            theme: ThemeData(
              scaffoldBackgroundColor:const Color(0xFFEDE7Dc),
              primarySwatch: Colors.blue,
            ),
            home: const UserStates(),
          );
        }

        } );
  }
}
