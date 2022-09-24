
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workosaribic/constants/constants.dart';
import 'package:workosaribic/services/global_method.dart';
import 'package:workosaribic/widget/drawer_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/auth/login.dart';

class ProfileScreen extends StatefulWidget {
  final String id;
  const ProfileScreen({Key? key, required this.id}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool isLoading=false;
  String name='';
  String email='';
  String phoneNumber='';
  String? imageUrl;
  String joinAt='';
  bool isSameUser=false;
  final auth =FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getDateUser();
  }
  void getDateUser()async{
    isLoading=true;
    try{
      final DocumentSnapshot userDate=await FirebaseFirestore.instance.
    collection('Users')
          .doc(widget.id)
          .get();
      setState(() {
        name=userDate.get('Name');
        email=userDate.get('Email');
        imageUrl=userDate.get('ImageUser');
        phoneNumber=userDate.get('PhoneNumber');
        Timestamp joined=userDate.get('CreateAt');
        var joinedDate=joined.toDate();
        joinAt='${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
      });

      User? user=auth.currentUser;
      String uId=user!.uid;
      setState(() {
        isSameUser=uId==widget.id;
      });
    }catch(err){
      GlobalMethod.showErrorDialog(error: '$err', context: context);
    }finally{
      isLoading=false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        elevation: 0.0,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: isLoading?const Center(child: CircularProgressIndicator(),):Center(
        child: Stack(
          children: [
            Card(
              margin: const EdgeInsets.all( 50),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const  SizedBox(height: 30,),
                      Align(
                       alignment: Alignment.center,
                       child: Text(name,
                       style: const TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 20,
                       ),),
                     ),
                     Align(
                       alignment: Alignment.center,
                       child: Text('jop Shared Jap ($joinAt)...',
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 18,
                           color: Constants().darkBlue
                         ),),
                     ),
                     const Divider(color: Colors.black,),
                     const Text('Contact Info',
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 20,
                       ),),
                     const SizedBox(height: 20,),
                     buildRowText(text: 'Email : ',con: email),
                     buildRowText(text: 'Phone Number : ',con: phoneNumber),
                     isSameUser?const Divider(color: Colors.black,
                     height: 30,):Container(),
                     isSameUser?Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         buildCircleAvatar(color: Colors.green,icons: FontAwesomeIcons.whatsapp,fct: ()async{
                           String phoneNum=phoneNumber;
                           await launch('https://send/$phoneNum/?text=Hello');
                         }),
                         buildCircleAvatar(color: Colors.pink,icons: Icons.email,fct:
                             ()async{
                           String emailSend=email;
                           await launch('mailto:$emailSend');

                         }),
                         buildCircleAvatar(color: Colors.purple,icons: Icons.call,fct: ()async{
                           String phone=phoneNumber;
                           await launch('tel:$phone');


                         }),
                       ],
                     ):Container(),
                     isSameUser?const Divider(color: Colors.black,
                     height:30,):Container(),
                     isSameUser?Center(
                       child: MaterialButton(
                         onPressed: (){
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
                                       final _auth=FirebaseAuth.instance;
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
                         },
                         color: Colors.pink.shade700,
                         elevation: 10.0,
                         padding:const  EdgeInsets.symmetric(vertical: 14),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             mainAxisSize: MainAxisSize.min,
                             children:const [
                               Text('Logout',
                                 style: TextStyle(
                                   color: Colors.white,
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold,
                                 ),),
                               SizedBox(width: 10,),
                               Icon(Icons.logout,color: Colors.white,)
                             ],
                           ),
                         ),

                       ),
                     ):Container(),


                   ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor:Theme.of(context).scaffoldBackgroundColor,
                  child:  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                        imageUrl==null?
                        'https://media.istockphoto.com/photos/businesswoman-using-computer-in-dark-office-picture-id557608443?k=6&m=557608443&s=612x612&w=0&h=fWWESl6nk7T6ufo4sRjRBSeSiaiVYAzVrY-CLlfMptM=':
                        imageUrl!),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCircleAvatar({
  required Color color,
    required IconData icons,
    required Function() fct,
}) {
    return InkWell(
      onTap: fct,
      child: CircleAvatar(
                 radius: 22,
                 backgroundColor:color,
                 child: CircleAvatar(
                   radius: 20,
                   backgroundColor: Colors.white,
                   child: Icon(icons,
                   color: color,),
                 ),
               ),
    );
  }

  Widget buildRowText({
  required String text,
  required String con,
}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
               children: [
                  Text(text,
                   style:const  TextStyle(
                     fontWeight: FontWeight.bold,
                     fontSize: 20,
                   ),),
                  Text(con,
                   style: TextStyle(
                     fontWeight: FontWeight.normal,
                     fontSize: 18,
                     color: Constants().darkBlue
                   ),),
               ],
             ),
    );
  }
}
