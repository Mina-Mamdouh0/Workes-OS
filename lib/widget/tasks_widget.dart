
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workosaribic/inner_screen/task_details.dart';
import 'package:workosaribic/services/global_method.dart';

class TaskWidget extends StatefulWidget {
  final bool isDone;
  final String title;
  final String jop;
  final String uploadBy;
  final String taskId;
  const TaskWidget({Key? key, required this.isDone, required this.title, required this.jop, required this.uploadBy, required this.taskId}) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin:const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      color: Colors.white,
       child: ListTile(
         onTap: (){
           Navigator.of(context).push(MaterialPageRoute(builder: (context){
             return  TaskDetails(
               taskId: widget.taskId,
               updateBy:widget.uploadBy ,
             );}));
         },
         onLongPress: (){
           showDialog(context: context,
               builder: (context){
             return AlertDialog(
               actions: [
                 TextButton(onPressed: (){
                   User? user=auth.currentUser;
                   String userId=user!.uid;
                   if(userId==widget.uploadBy){
                     FirebaseFirestore.instance.collection('Tasks')
                     .doc(widget.taskId).delete();
                     Navigator.canPop(context)?Navigator.pop(context):null;
                   }else{
                     GlobalMethod.showErrorDialog(error: 'You not access to delete the task', context: context);
                   }
                    },
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children:const [
                         Icon(Icons.delete,color: Colors.pink,),
                           SizedBox(width: 5.0,),
                         Text('Delete',
                         style: TextStyle(color: Colors.pink),)
                       ],
                     ))
               ],
             );
               });
         },
         contentPadding:const EdgeInsets.all(10),
         leading:Container(
           padding:const EdgeInsets.only( right: 12),
           decoration:const BoxDecoration(
             border: Border(
               right: BorderSide(
                 color: Colors.black,
                 width: 1.0,
               )
             )
           ),
           child:  CircleAvatar(
             radius: 22.0,
               backgroundColor: Colors.white,
             backgroundImage: AssetImage(widget.isDone?'assets/images/done.jpg':'assets/images/notdone.jpg'),
           ),
         ),
         title: Text(widget.title,
           maxLines: 2,
           overflow: TextOverflow.ellipsis,
           softWrap: true,
         style: const TextStyle(
           color: Colors.blue,
           fontSize: 20,fontWeight: FontWeight.bold
         ),),
         subtitle: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             const Icon(Icons.more_horiz,
             color: Colors.pink,size: 35,),
             Text(widget.jop,
               maxLines: 2,
               overflow: TextOverflow.ellipsis,
               softWrap: true,
               style: const TextStyle(
                  wordSpacing: 2,
                   color: Colors.grey,
                   fontSize: 18,
               ),),
           ],
         ),
         trailing:const Icon(Icons.arrow_forward_ios,
         color: Colors.pink,),
       ),
    );
  }
}
