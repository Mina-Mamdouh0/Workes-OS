
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:workosaribic/screens/auth/forgetpassword.dart';
import 'package:workosaribic/screens/auth/signup.dart';
import 'package:workosaribic/services/global_method.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late final TextEditingController _emailController=TextEditingController(text: '');
 late final  TextEditingController _passController=TextEditingController(text: '');
  final FocusNode _emailFocusNode=FocusNode();
  final FocusNode _passFocusNode=FocusNode();
 var loginKey=GlobalKey<FormState>();
 bool showText=true;
  final FirebaseAuth _auth =FirebaseAuth.instance;
  bool isLoading=false;
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
    _emailController.dispose();
    _passController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  submitLogin()async{
    bool isValid=loginKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      setState(() {
        isLoading=true;
      });
      try{
        await _auth.signInWithEmailAndPassword(
            email: _emailController.text.toLowerCase().trim(),
            password: _passController.text.trim());
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
                const Text('Login',style: TextStyle(
                  fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold
                ),),
                const SizedBox(height: 9,),
                RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(  text: 'Don\'t have an account?',
                        style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.bold, fontSize: 16)),
                        const TextSpan(  text: '     ',),
                        TextSpan(
                            text: 'Register',
                            recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(context,MaterialPageRoute(builder: (context)=>const RegisterScreen()),),
                            style: TextStyle(color: Colors.blue.shade300,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ])),
                SizedBox(height:size.height*0.05 ,),
                Form(
                  key: loginKey,
                  child: Column(
                    children: [
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
                        onEditingComplete: submitLogin,
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
                    ],
                  ),
                ),
                const SizedBox(height:10 ,),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>const ForgetPasswordScreen()),),
                    child:const Text('Forget password ?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      decoration: TextDecoration.underline
                    ),),
                  ),
                ),
                const SizedBox(height:10 ,),
                MaterialButton(
                    onPressed: submitLogin,
                color: Colors.pink.shade700,
                  elevation: 10.0,
                  padding:const  EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:const [
                       Text('Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),),
                      SizedBox(width: 10,),
                      Icon(Icons.login,color: Colors.white,)
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
