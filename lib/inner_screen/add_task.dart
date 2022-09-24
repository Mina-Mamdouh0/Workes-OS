
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:workosaribic/constants/constants.dart';
import 'package:workosaribic/services/global_method.dart';
import 'package:workosaribic/widget/drawer_widget.dart';

class AddTasks extends StatefulWidget {
  const AddTasks({Key? key}) : super(key: key);

  @override
  _AddTasksState createState() => _AddTasksState();
}

class _AddTasksState extends State<AddTasks> {
  late final TextEditingController _taskCategoryController=TextEditingController(text: 'Task Category');
  late final  TextEditingController _taskTitleController=TextEditingController(text: '');
  late final  TextEditingController _taskDesController=TextEditingController(text: '');
  late final  TextEditingController _taskDeadlineController=TextEditingController(text: 'Pick up to data');
  var taskKey=GlobalKey<FormState>();
  DateTime? _dateTime;
  bool isLoading=false;
  Timestamp?taskDeadlineTimeStamp;
  @override
  void dispose() {
    _taskCategoryController.dispose();
    _taskTitleController.dispose();
    _taskDesController.dispose();
    _taskDeadlineController.dispose();
    super.dispose();
  }
  submitAddTask(){
    bool isValid=taskKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      if(_taskCategoryController.text=='Task Category'||_taskDeadlineController.text=='Pick up to data'){
        GlobalMethod.showErrorDialog(error: 'Enter The Fiald', context: context);
      }
      setState(() {
        isLoading=true;
      });
      var taskId=const Uuid().v4();
      try{
        final auth=FirebaseAuth.instance;
        User? user=auth.currentUser;
        String uId=user!.uid;
        FirebaseFirestore.instance.collection('Tasks').doc(taskId).set({
          'TaskCategory':_taskCategoryController.text,
          'TaskId':taskId,
          'UploadBy':uId,
          'Comments':[],
          'TaskTitle':_taskTitleController.text,
          'TaskDesc':_taskDesController.text,
          'TaskDeadline':_taskDeadlineController.text,
          'TaskDeadlineTimeStamp':taskDeadlineTimeStamp,
          'IsDone':false,
          'CreatedAt':Timestamp.now(),
        });
        Fluttertoast.showToast(
            msg: "Task Upload",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0
        );
        _taskTitleController.clear();
        _taskDesController.clear();
        setState(() {
          _taskCategoryController.text='Task Category';
          _taskDeadlineController.text='Pick up to data';
        });
      }
      catch(err){
        GlobalMethod.showErrorDialog(error: '$err', context: context);
      }
      finally{
        setState(() {
          isLoading=false;
        });
      }
       }else{
      GlobalMethod.showErrorDialog(error: 'Please check a filed', context: context);
    }

  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Constants().darkBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(
         10.0
        ),
        child: Card(
          child: Form(
            key: taskKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text('All Field are required',
                      style: TextStyle(
                        color: Constants().darkBlue,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                    const Divider(thickness: 1,),
                    buildText(text: 'Task Category *'),
                    buildTextForm(fct: (){
                      showDialog(context: context, builder: (context){
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
                                        _taskCategoryController.text=Constants().taskCategory[index];
                                      });
                                      Navigator.of(context).pop();
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
                            TextButton(onPressed: (){},
                                child:const Text('Cancel Flitter',)),
                          ],
                        );
                      });
                    },
                    controller: _taskCategoryController,
                    enabled: false,
                    mixLen: 100,
                    valueKey: 'Task Category'),
                    buildText(text: 'Task Title *'),
                    buildTextForm(fct: (){},
                        controller: _taskTitleController,
                        enabled: true,
                        mixLen: 100,
                        valueKey: 'Task Title'),
                    buildText(text: 'Task Description *'),
                    buildTextForm(fct: (){},
                        controller: _taskDesController,
                        enabled: true,
                        mixLen: 1000,
                        valueKey: 'Task Description'),
                    buildText(text: 'Task Deadline Data *'),
                    buildTextForm(fct: (){
                      showDate();
                    },
                        controller: _taskDeadlineController,
                        enabled: false,
                        mixLen: 100,
                        valueKey: 'Task Deadline'),
                    Center(
                      child: isLoading?const CircularProgressIndicator():MaterialButton(
                        onPressed: submitAddTask,
                        color: Colors.pink.shade700,
                        elevation: 10.0,
                        padding:const  EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children:const [
                              Text('Upload',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),),
                              SizedBox(width: 10,),
                              Icon(Icons.upload_file,color: Colors.white,)
                            ],
                          ),
                        ),

                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildText({required String text}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text,
                    style: TextStyle(
                      color: Colors.pink.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),),
    );
  }

  Widget buildTextForm({
  required TextEditingController controller,
    required String valueKey,
    required bool enabled,
    required int mixLen,
    required Function() fct,

}){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: fct,
        child: TextFormField(
          controller: controller,
          key: ValueKey(valueKey),
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
          maxLines: valueKey=='Task Description'?3:1,
          maxLength: mixLen,
          decoration: InputDecoration(
            enabled:  enabled,
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
        ),
      ),
    );
  }


  showDate()async{
    _dateTime=await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.utc(2030));
    if(_dateTime!=null){
      setState(() {
        taskDeadlineTimeStamp=Timestamp.fromMicrosecondsSinceEpoch(_dateTime!.microsecondsSinceEpoch);
        _taskDeadlineController.text='${_dateTime!.year}-${_dateTime!.month}-${_dateTime!.day}';
      });
    }


  }
}
