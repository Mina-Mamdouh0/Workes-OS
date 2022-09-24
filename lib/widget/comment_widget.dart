
 import 'package:flutter/material.dart';
import 'package:workosaribic/inner_screen/profile.dart';

class CommentWidget extends StatelessWidget {
  final String commentId;
  final String commenterId;
  final String commenterImage;
  final String commenterName;
  final String commentBody;
   CommentWidget({Key? key, required this.commentId, required this.commenterId, required this.commenterImage, required this.commenterName, required this.commentBody}) : super(key: key);
  List<Color> color=[
    Colors.purple,
    Colors.pink,
    Colors.red,
    Colors.teal,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {
    color.shuffle();
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProfileScreen(id: commenterId,)));
      },
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 40,width: 40,
                decoration:BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 2,color: color[1]
                    ),
                    image:  DecorationImage(
                      image:  NetworkImage(commenterImage,),
                    )
                ) ,
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text(commenterName,
                    style: const TextStyle(
                      fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),),
                  Text(commentBody,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                    ),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
