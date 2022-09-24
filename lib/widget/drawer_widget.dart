
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workosaribic/constants/constants.dart';
import 'package:workosaribic/inner_screen/add_task.dart';
import 'package:workosaribic/inner_screen/profile.dart';
import 'package:workosaribic/screens/allworker.dart';
import 'package:workosaribic/screens/auth/login.dart';
import 'package:workosaribic/screens/tasksscreen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _auth=FirebaseAuth.instance;
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration:const BoxDecoration(
              color: Colors.lightBlue
            ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundImage:  NetworkImage('https://media.istockphoto.com/photos/businesswoman-using-computer-in-dark-office-picture-id557608443?k=6&m=557608443&s=612x612&w=0&h=fWWESl6nk7T6ufo4sRjRBSeSiaiVYAzVrY-CLlfMptM='),
                    radius: 30.0,
                  ),
                  Text('Work Os',
                  style: TextStyle(
                    color:Constants().darkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),)
                ],
              )),
          _listTile(text: 'All tasks',icons: Icons.all_inbox,onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> TasksScreen()));

          }),
          _listTile(text: 'My Account',icons: Icons.account_box_outlined,onTap: (){
            final auth=FirebaseAuth.instance;
            User? user=auth.currentUser;
            String uId=user!.uid;
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ProfileScreen(id: uId,)));
          }),
          _listTile(text: 'Register Workers',icons: Icons.work,onTap: (){

            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const AllWorker()));
          }),
          _listTile(text: 'Add Tasks',icons: Icons.add_task,onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const AddTasks()));
          }),
          const Divider(height: 5,),
          _listTile(text: 'Logout',icons: Icons.logout,onTap: (){
            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:const  [
                        Icon(Icons.logout,color: Colors.blue,),
                        SizedBox(width: 5,),
                         Text('Sign out',style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic
                        ),),
                      ],
                    ),
                    content:const Text('Do you wanna Sign out ? ',
                    style: TextStyle(
                      fontSize: 15
                    ),),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.canPop(context)?Navigator.pop(context):null;
                      },
                          child:const Text('Cancel',
                          style: TextStyle(
                             color: Colors.blue
                          ),)),
                      TextButton(onPressed: (){
                        _auth.signOut();
                        Navigator.canPop(context)?Navigator.pop(context):null;
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>const LoginScreen()));
                      },
                          child:const Text('ok',
                            style: TextStyle(
                                color: Colors.red
                            ),))
                    ],
                  );
                });
          }),

        ],
      ),
    );
  }
  Widget _listTile({required IconData icons,required String text,required Function() onTap}){
return ListTile(
  onTap: onTap,
  leading: Icon(icons,color: Constants().darkBlue,),
  title: Text(text,style: TextStyle(
    color: Constants().darkBlue,
    fontSize: 18,
    fontStyle: FontStyle.italic
  ),),
);
  }
}
