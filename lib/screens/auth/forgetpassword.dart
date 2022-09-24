
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late final TextEditingController _emailController=TextEditingController(text: '');
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
    super.dispose();
  }

  submitForgetPassword(){
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
                const Text('Forget Password',style: TextStyle(
                    fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold
                ),),
                const SizedBox(height: 10,),
                const Text('Email adress',style: TextStyle(
                    fontSize: 18,color: Colors.white,fontWeight: FontWeight.normal
                ),),
                const SizedBox(height: 10,),
                TextField(
                  controller: _emailController,
                  style:const TextStyle(
                    color: Colors.white,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink.shade700),
                    ),
                    enabledBorder:const  UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),)
                ),
                const SizedBox(height:30 ,),
                MaterialButton(
                  onPressed: submitForgetPassword,
                  color: Colors.pink.shade700,
                  elevation: 10.0,
                  padding:const  EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Reset now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),

                ),


              ],
            ),
          )
        ],
      ),
    );
  }
}
