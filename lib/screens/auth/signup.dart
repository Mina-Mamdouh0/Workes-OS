
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workosaribic/constants/constants.dart';
import 'package:workosaribic/services/global_method.dart';

import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late final TextEditingController _nameController=TextEditingController(text: '');
  late final TextEditingController _emailController=TextEditingController(text: '');
  late  final TextEditingController _passController=TextEditingController(text: '');
  late  final TextEditingController _phoneController=TextEditingController(text: '');
  late  final TextEditingController _positionCmController=TextEditingController(text: '');
  final FocusNode _nameFocusNode=FocusNode();
  final FocusNode _emailFocusNode=FocusNode();
  final FocusNode _passFocusNode=FocusNode();
  final FocusNode _phoneFocusNode=FocusNode();
  final FocusNode _positionCmFocusNode=FocusNode();
  var signUpKey=GlobalKey<FormState>();
  final FirebaseAuth _auth =FirebaseAuth.instance;
  bool showText=true;
  bool isLoading=false;
  File? _file;
  String? url;
  @override
  void initState() {
    _animationController=AnimationController(vsync: this,
        duration: const Duration(seconds: 20));
    _animation=CurvedAnimation(parent: _animationController, curve: Curves.linear)..addListener(() {
      setState(() {});
    })..addStatusListener((status) {
      if(status==AnimationStatus.completed){
        _animationController.reset();
        _animationController.forward();
      }
    });
    _animationController.forward();
    super.initState();
  }
  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _phoneController.dispose();
    _positionCmController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _phoneFocusNode.dispose();
    _positionCmFocusNode.dispose();
    super.dispose();
  }

  submitSignUp()async{
    bool isValid=signUpKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      if(_file==null){
        GlobalMethod.showErrorDialog(error: 'Please Pick Up The Image', context: context);
        return;
      }
      setState(() {
        isLoading=true;
      });
      try{
        await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.toLowerCase().trim(),
            password: _passController.text.trim());
        final  user=_auth.currentUser;
        final  uId=user!.uid;
        final ref= FirebaseStorage.instance.ref().child('UsersImage').
        child(uId+'.jpg');
        await ref.putFile(_file!);
        url =await ref.getDownloadURL();
       await FirebaseFirestore.instance.collection('Users').doc(uId).set({
          'id':uId,
          'Name':_nameController.text,
          'Email':_emailController.text,
          'PhoneNumber':_phoneController.text,
          'ImageUser':url,
          'CompanyPosition':_positionCmController.text,
          'CreateAt':Timestamp.now(),
        });
        Navigator.canPop(context)?Navigator.pop(context):null;
      }
      catch(error){
        GlobalMethod.showErrorDialog(error: error.toString(), context: context);
        setState(() {
          isLoading=false;
        });
      }
    }else{
      setState(() {
        isLoading=false;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: "https://media.istockphoto.com/photos/businesswoman-using-computer-in-dark-office-picture-id557608443?k=6&m=557608443&s=612x612&w=0&h=fWWESl6nk7T6ufo4sRjRBSeSiaiVYAzVrY-CLlfMptM=",
            placeholder: (context, url) => Image.asset('assets/images/wallpaper.jpg',fit: BoxFit.fill,),
            errorWidget: (context, url, error) =>const Icon(Icons.error),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              children: [
                SizedBox(height: size.height*0.1,),
                const Text('Register',style: TextStyle(
                    fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold
                ),),
                const SizedBox(height: 9,),
                RichText(
                    text: TextSpan(
                        children: [
                          const TextSpan(  text: 'Already have an account?',
                              style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const TextSpan(  text: '     ',),
                          TextSpan(
                              text: 'Login',
                              recognizer: TapGestureRecognizer()..onTap = () =>  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const LoginScreen()),),
                              style: TextStyle(color: Colors.blue.shade300,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ])),
                SizedBox(height:size.height*0.05 ,),
                Form(
                  key: signUpKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex:3,
                            child: TextFormField(
                              focusNode: _nameFocusNode,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: ()=>FocusScope.of(context).requestFocus(_emailFocusNode),
                              controller: _nameController,
                              style:const TextStyle(
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Please validator The name ';
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Name',
                                hintStyle:const TextStyle(
                                    color: Colors.white
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.pink.shade700),
                                ),
                                enabledBorder:const  UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                errorBorder:const  UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    margin:const  EdgeInsets.all(10),
                                    height: MediaQuery.of(context).size.width*0.2,
                                    width: MediaQuery.of(context).size.width*0.2,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: _file==null?Image.network('https://media.istockphoto.com/photos/businessman-silhouette-as-avatar-or-default-profile-picture-picture-id476085198?s=612x612',
                                      fit: BoxFit.fill,):Image.file(_file!,
                                      fit: BoxFit.fill,),
                                    ),
                                  ),
                                  GestureDetector(
                                     onTap: (){
                                       showDialog(context: context,
                                           builder: (context){
                                         return AlertDialog(
                                           title:const  Text(
                                             'Please choose an option',
                                             style: TextStyle(
                                               fontSize: 20,
                                               color: Colors.black,
                                               fontWeight: FontWeight.bold
                                             ),
                                           ),

                                           content: Column(
                                             mainAxisSize: MainAxisSize.min,
                                             children: [
                                               InkWell(
                                                 onTap: ()async{
                                                   Navigator.pop(context);
                                                   XFile? _picked=await ImagePicker().pickImage(source: ImageSource.camera,maxHeight: 1080,maxWidth: 1080);
                                                   if(_picked !=null){
                                                     File? croppedFile = (await ImageCropper().cropImage(sourcePath:_picked.path ,maxWidth: 1080,maxHeight: 1080 )) ;
                                                     setState(() {
                                                       _file=croppedFile ;
                                                     });
                                                    }
                                                 },
                                                 child: Padding(
                                                   padding: const EdgeInsets.all(8.0),
                                                   child: Row(
                                                     children: const [
                                                       Icon(Icons.photo,color: Colors.purple,),
                                                       SizedBox(width: 10,),
                                                       Text('Camera',
                                                       style: TextStyle(
                                                         color: Colors.purple,fontSize: 20
                                                       ),)
                                                     ],
                                                   ),
                                                 ),
                                               ),
                                               InkWell(
                                                 onTap: ()async{
                                               Navigator.pop(context);
                                               XFile? _picked=await ImagePicker().pickImage(source: ImageSource.gallery,maxHeight: 1080,maxWidth: 1080);
                                               if(_picked !=null){
                                                 File? croppedFile = await ImageCropper().cropImage(sourcePath:_picked.path ,maxWidth: 1080,maxHeight: 1080 );
                                                 setState(() {
                                                   _file=croppedFile ;
                                                 });
                                               }
                                               },
                                                 child: Padding(
                                                   padding: const EdgeInsets.all(8.0),
                                                   child: Row(
                                                     children: const [
                                                       Icon(Icons.camera,color: Colors.purple,),
                                                       SizedBox(width: 10,),
                                                       Text('Gallery',
                                                         style: TextStyle(
                                                             color: Colors.purple,fontSize: 20
                                                         ),)
                                                     ],
                                                   ),
                                                 ),
                                               )
                                             ],
                                           ),
                                         );
                                           });
                                     },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(width: 2,
                                        color: Colors.white),
                                        color: Colors.pink
                                      ),
                                       child: Icon(_file==null?Icons.camera_alt:Icons.edit,
                                       color: Colors.white,
                                       size: 20,),

                                    ),
                                  )
                                ],
                              )
                          ),
                        ],
                      ),
                      const SizedBox(height:10 ,),
                      TextFormField(
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: ()=>FocusScope.of(context).requestFocus(_passFocusNode),
                        controller: _emailController,
                        style:const TextStyle(
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value){
                          if(value!.isEmpty||!value.contains('@')){
                            return 'Please validator The Email ';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle:const TextStyle(
                              color: Colors.white
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink.shade700),
                          ),
                          enabledBorder:const  UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder:const  UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(height:10 ,),
                      TextFormField(
                        focusNode: _passFocusNode,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: ()=>FocusScope.of(context).requestFocus(_phoneFocusNode),
                        controller: _passController,
                        style:const TextStyle(
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value){
                          if(value!.isEmpty||value.length<8){
                            return 'Please validator The PassWord ';
                          }
                        },
                        obscureText: showText,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: (){
                                setState(() {
                                  showText=!showText;
                                });
                              },
                              child: Icon(showText?Icons.visibility:Icons.visibility_off,color: Colors.white,)),
                          hintText: 'Password',
                          hintStyle:const TextStyle(
                              color: Colors.white
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink.shade700),
                          ),
                          enabledBorder:const  UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder:const  UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(height:10 ,),
                      TextFormField(
                        focusNode: _phoneFocusNode,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: ()=>FocusScope.of(context).requestFocus(_positionCmFocusNode),
                        controller: _phoneController,
                        style:const TextStyle(
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please validator The Position ';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          hintStyle:const TextStyle(
                              color: Colors.white
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink.shade700),
                          ),
                          enabledBorder:const  UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder:const  UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(height:10 ,),
                      GestureDetector(
                        onTap: (){
                          showDialog(context: context, builder: (context){
                            return AlertDialog(
                              title:const Text('Jop Category',
                                style: TextStyle(
                                    color: Colors.pink,
                                    fontSize: 20
                                ),),
                              content: SizedBox(
                                width: size.width*0.9,
                                child: ListView.builder(
                                    itemCount: Constants().jopCategory.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context,index){
                                      return InkWell(
                                        onTap: (){
                                          setState(() {
                                            _positionCmController.text=Constants().jopCategory[index];
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.check_circle,
                                              color: Colors.red[200],),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(Constants().jopCategory[index],
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
                        child: TextFormField(
                          focusNode: _positionCmFocusNode,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: submitSignUp,
                          controller: _positionCmController,
                          style:const TextStyle(
                            color: Colors.white,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please validator The Position ';
                            }
                          },
                          decoration: InputDecoration(
                            enabled: false,
                            hintText: 'Position in the company',
                            hintStyle:const TextStyle(
                                color: Colors.white
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink.shade700),
                            ),
                            disabledBorder: const  UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                            enabledBorder:const  UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder:const  UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height:20 ,),
                isLoading?const Center( child:  SizedBox(
                  width: 70,
                  height: 70,
                  child:  CircularProgressIndicator(),
                ),):MaterialButton(
                  onPressed: submitSignUp,
                  color: Colors.pink.shade700,
                  elevation: 10.0,
                  padding:const  EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:const [
                      Text('Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),),
                      SizedBox(width: 10,),
                      Icon(Icons.person_add,color: Colors.white,)
                    ],
                  ),

                ),


              ],
            ),
          )
        ],
      ),
    );
  }
}
