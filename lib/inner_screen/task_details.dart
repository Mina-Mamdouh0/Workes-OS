
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:workosaribic/constants/constants.dart';
import 'package:workosaribic/services/global_method.dart';
import 'package:workosaribic/widget/comment_widget.dart';

class TaskDetails extends StatefulWidget {
  final String taskId;
  final String updateBy;
  const TaskDetails({Key? key, required this.taskId, required this.updateBy}) : super(key: key);

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  bool isComment=false;

  String? _authorName;
  String? _authorJop;
  String? imageUser;

  String? taskTitle;
  String? taskDesc;
  bool? isDone;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadLineDateTimeStamp;
  String? deadLineDate;
  String? postedDate;
  bool isDeadLineDateAvailable=false;
  bool isLoading=false;
  late TextEditingController controller=TextEditingController(text: '');

  final auth=FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getDate();
  }
  void getDate()async{
    isLoading=true;
   try{
     final DocumentSnapshot userDate=await FirebaseFirestore.instance
         .collection('Users').doc(widget.updateBy).get();
     if(userDate==null){
       return ;
     }else{
       setState(() {
         _authorName=userDate.get('Name');
         _authorJop=userDate.get('CompanyPosition');
         imageUser=userDate.get('ImageUser');
       });
     }
     final DocumentSnapshot taskDate=await FirebaseFirestore.instance
         .collection('Tasks').doc(widget.taskId).get();
     if(taskDate==null){
       return ;
     }else{
       setState(() {
         taskTitle=taskDate.get('TaskTitle');
         taskDesc=taskDate.get('TaskDesc');
         isDone=taskDate.get('IsDone');
         postedDateTimeStamp=taskDate.get('CreatedAt');
         deadLineDateTimeStamp=taskDate.get('TaskDeadlineTimeStamp');
         deadLineDate=taskDate.get('TaskDeadline');
         var postDat=postedDateTimeStamp!.toDate();
         postedDate='${postDat.year}-${postDat.month}-${postDat.day}';
         var date=deadLineDateTimeStamp!.toDate();
         isDeadLineDateAvailable=date.isAfter(DateTime.now());
       });
     }
   }
   catch(err){
     GlobalMethod.showErrorDialog(error: '$err', context: context);
   }
   finally{
     isLoading=false;
   }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        title: TextButton(child: Text('Back',
        style: TextStyle(
          color: Constants().darkBlue,
          fontStyle: FontStyle.italic,
          fontSize: 20
        ),),
        onPressed: (){
          Navigator.of(context).pop();
        },),
      ),
      body: isLoading?const Center( child: CircularProgressIndicator(),):SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50,),
            Text(taskTitle==null?'':taskTitle!,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Constants().darkBlue
            ),),
            Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 15,horizontal: 5),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Updated by',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Constants().darkBlue
                        ),),
                        const Spacer(),
                        Container(
                          height: 40,width: 40,
                          decoration:BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 2,color: Colors.pink
                            ),
                            image:  DecorationImage(
                              image:  NetworkImage(imageUser==null?'https://media.istockphoto.com/photos/businessman-silhouette-as-avatar-or-default-profile-picture-picture-id476085198?s=612x612':
                                imageUser!,),
                            )
                          ) ,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_authorName==null?'':_authorName!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Constants().darkBlue
                                ),),
                              Text(_authorJop==null?'':_authorJop!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Constants().darkBlue
                                ),),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Text('Updated on',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Constants().darkBlue
                          ),),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(postedDate==null?'':postedDate!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Constants().darkBlue
                            ),),
                        )
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        Text('Deadline data',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Constants().darkBlue
                          ),),
                        const Spacer(),
                         Padding(
                          padding:  const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(deadLineDate==null?'':deadLineDate!,
                            style:const  TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.pink
                            ),),
                        )
                      ],
                    ),
                     Align(
                       alignment: Alignment.center,
                      child:  Text(isDeadLineDateAvailable?'Still have enough time':'no time lift ',
                        style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDeadLineDateAvailable?Colors.green:Colors.red
                        ),),
                    ),
                    const Divider(),
                     Text('Done State',
                      style: TextStyle(
                        fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Constants().darkBlue
                      ),),
                    Row(
                      children: [
                       TextButton(onPressed: (){
                         User? user=auth.currentUser;
                         String uId=user!.uid;
                         if(uId==widget.updateBy){
                           FirebaseFirestore.instance.collection('Tasks')
                               .doc(widget.taskId).update({
                             'IsDone':true
                           });
                           getDate();
                         }else{
                           GlobalMethod.showErrorDialog(error: 'Not to change state', context: context);
                         }
                       },
                       child:  Text('Done',
                         style: TextStyle(
                             decoration: TextDecoration.underline,
                             color: Constants().darkBlue
                         ),)),
                         Opacity(
                          opacity: isDone??false?1:0,
                            child:  const Icon(Icons.check)),
                        const SizedBox(width: 15,),
                        TextButton(onPressed: (){
                          User? user=auth.currentUser;
                          String uId=user!.uid;
                          if(uId==widget.updateBy){
                            FirebaseFirestore.instance.collection('Tasks')
                                .doc(widget.taskId).update({
                              'IsDone':false
                            });
                            getDate();
                          }else{
                            GlobalMethod.showErrorDialog(error: 'Not to change state', context: context);
                          }
                        },
                            child: Text('Not Done',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Constants().darkBlue
                              ),)),
                         Opacity(
                            opacity: isDone??false?0:1,
                            child:  const Icon(Icons.check)),
                      ],
                    ),
                    const Divider(),
                     Text('Task Describtion',
                      style: TextStyle(
                        fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Constants().darkBlue
                      ),),
                     Padding(
                       padding: const EdgeInsets.symmetric(vertical: 3.0),
                       child: Text(taskDesc==null?'':taskDesc!,
                        style: TextStyle(
                            color: Constants().darkBlue
                        ),),
                     ),
                    const Divider(),
                    AnimatedSwitcher(
                      child: isComment?Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 3,
                              child: TextFormField(
                            controller: controller,
                            style: TextStyle(
                                color: Constants().darkBlue,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Please validator The Field ';
                              }
                            },
                            maxLines: 4,
                            maxLength: 1000,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).scaffoldBackgroundColor,
                              hintStyle: TextStyle(
                                  color: Constants().darkBlue,
                                  fontStyle: FontStyle.italic
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.pink.shade700),
                              ),
                              errorBorder:const  OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          )),
                          Flexible(child:
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                              MaterialButton(
                                onPressed:()async{
                                  if(controller.text.length<7){
                                    GlobalMethod.showErrorDialog(error: 'The comment less seven Charters', context: context);
                                  }else{
                                    final cometId=const Uuid().v4();
                                    await FirebaseFirestore.instance.collection('Tasks').doc(widget.taskId).
                                    update(({
                                      'Comments':FieldValue.arrayUnion([{
                                        'userId':widget.updateBy,
                                        'cometId':cometId,
                                        'name':_authorName!,
                                        'commentBody':controller.text,
                                        'userImage':imageUser,
                                        'time':Timestamp.now(),
                                      }])
                                    }));
                                    Fluttertoast.showToast(
                                        msg: "Comment Upload",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        fontSize: 16.0
                                    );
                                    controller.clear();
                                    setState(() {});
                                  }
                                } ,
                                color: Colors.pink.shade700,
                                elevation: 10.0,
                                //padding:const  EdgeInsets.symmetric(horizontal: 14,vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Text('Post',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),),

                              ),
                              TextButton(onPressed: (){
                                setState(() {
                                  isComment=!isComment;
                                });
                              }, child:const  Text('Cancel'))
                            ],),
                          ))
                        ],
                      )
                          :Align(
                        alignment: Alignment.center,
                        child: MaterialButton(
                          onPressed:(){
                            setState(() {
                              isComment=!isComment;
                            });
                          } ,
                          color: Colors.pink.shade700,
                          elevation: 10.0,
                          padding:const  EdgeInsets.symmetric(horizontal: 14,vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('Add a comment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),),

                        ),
                      ),
                        duration: const Duration(milliseconds: 600)),
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('Tasks').doc(widget.taskId).get(),
                        builder: (context, snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return const Center(child: CircularProgressIndicator());
                      }else{
                        if(snapshot.data==null){
                          return Container();
                        }else{
                          return ListView.separated(
                            reverse: true,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context,index){
                                return CommentWidget(
                                  commentBody: snapshot.data!['Comments'][index]['commentBody'],
                                  commenterId: snapshot.data!['Comments'][index]['userId'],
                                  commenterImage: snapshot.data!['Comments'][index]['userImage'],
                                  commenterName: snapshot.data!['Comments'][index]['name'],
                                  commentId: snapshot.data!['Comments'][index]['cometId'],
                                );
                              },
                              separatorBuilder: (context,index){
                                return const Divider();
                              },
                              itemCount: snapshot.data!['Comments'].length);
                        }
                      }
                    }),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
