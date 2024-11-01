import 'package:flutter/material.dart';

class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
              'assets/spacebackground.jpg'
              ),
              fit:BoxFit.cover,
            ),
          ),

          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              
              MaterialButton(onPressed:(){
                Navigator.pop(context);
              },
              color: Colors.grey,
              child: const Text('Back to Home',style: TextStyle(color: Colors.white),),
              )
            ]
          )
        )
      )
    );
  }
}