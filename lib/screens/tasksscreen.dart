
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workosaribic/constants/constants.dart';
import 'package:workosaribic/widget/drawer_widget.dart';
import 'package:workosaribic/widget/tasks_widget.dart';

class TasksScreen extends StatefulWidget {
   const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String? taskCate;
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      drawer:const  DrawerWidget(),
      appBar: AppBar(
        iconTheme:const IconThemeData(
          color: Colors.black
        ),
        title: const Text('Tasks',style: TextStyle(
          color: Colors.pink
        ),),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        actions: [
          IconButton(onPressed:(){
            showDialog(context: context,
                builder: (context){
                  return AlertDialog(
                    title:const Text('Task Category',
                    style: TextStyle(
                       color: Colors.pink,
                      fontSize: 20
                    ),),
                    content: SizedBox(
                      width: size.width*0.9,
                      child: ListView.builder(
                        itemCount: Constants().taskCategory.length,
                          shrinkWrap: true,
                          itemBuilder: (context,index){
                          return InkWell(
                            onTap: (){
                              setState(() {
                                taskCate=Constants().taskCategory[index];
                              });
                              Navigator.canPop(context)?Navigator.pop(context):null;
                            },
                            child: Row(
                              children: [
                                Icon(Icons.check_circle,
                                color: Colors.red[200],),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(Constants().taskCategory[index],
                                  style:const TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF00325A),
                                    fontStyle: FontStyle.italic,
                                  ),),
                                )
                              ],
                            ),
                          );
                          }),
                    ),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.canPop(context)?Navigator.pop(context):null;
                      },
                          child:const Text('Close',)),
                      TextButton(onPressed: (){
                        setState(() {
                          taskCate=null;
                        });
                        Navigator.canPop(context)?Navigator.pop(context):null;

                      },
                          child:const Text('Cancel Flitter',)),
                    ],
                  );
                });
          },
              icon:const  Icon(Icons.filter_list,color: Colors.black,))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Tasks')
            .where('TaskCategory',isEqualTo: taskCate).
        orderBy('CreatedAt',descending: true).snapshots(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child:  CircularProgressIndicator());
          }
          else if(snapshot.connectionState==ConnectionState.active){
            if(snapshot.data!.docs.isNotEmpty){
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                    return TaskWidget(
                      isDone: snapshot.data!.docs[index]['IsDone'],
                      title: snapshot.data!.docs[index]['TaskTitle'],
                      jop: snapshot.data!.docs[index]['TaskCategory'],
                      uploadBy: snapshot.data!.docs[index]['UploadBy'],
                       taskId: snapshot.data!.docs[index]['TaskId'],
                    );
                  });
            }
            else{
              return const Center(child: Text('No Tasks'),);
            }
          }
          else{
            return const Center(child: Text('Some Thing Error'),);
          }
        },
      )
    );
  }
}
