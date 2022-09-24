import 'package:flutter/material.dart';

class GlobalMethod{
static showErrorDialog({required String error,required BuildContext context}){
  showDialog(
      context: context,
      builder: (context){
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:const  [
          Icon(Icons.error,color: Colors.red,),
          SizedBox(width: 5,),
          Text('Error',style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic
          ),),
        ],
      ),
      content: Text(error,
        style: const TextStyle(
            fontSize: 15
        ),),
      actions: [
        TextButton(onPressed: (){
        Navigator.canPop(context)?Navigator.pop(context):null;
        },
            child:const Text('ok',
              style: TextStyle(
                  color: Colors.red
              ),))
      ],
    );

}

  );
}



}