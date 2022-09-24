
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../inner_screen/profile.dart';

class WorkerWidget extends StatefulWidget {
  final String image;
  final String name;
  final String email;
  final String jop;
  final String phoneNumber;
  final String uId;
  const WorkerWidget({Key? key, required this.image, required this.name, required this.email, required this.jop, required this.phoneNumber, required this.uId}) : super(key: key);

  @override
  _WorkerWidgetState createState() => _WorkerWidgetState();
}

class _WorkerWidgetState extends State<WorkerWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin:const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      color: Colors.white,
      child: ListTile(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProfileScreen(id: widget.uId,)));
        },
        onLongPress: (){
          showDialog(context: context,
              builder: (context){
                return AlertDialog(
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.canPop(context)?Navigator.pop(context):null;
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
            backgroundImage: NetworkImage(
              widget.image),
          ),
        ),
        title: Text(widget.name,
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
           const  Icon(Icons.more_horiz,
              color: Colors.pink,size: 35,),
            Text('${widget.jop} --- ${widget.phoneNumber}',
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
        trailing:InkWell(
          onTap: ()async{
    String emailSend=widget.email;
    await launch('mailto:$emailSend');
    },
          child: const Icon(Icons.email,
            color: Colors.pink,),
        ),
      ),
    );
  }
}
