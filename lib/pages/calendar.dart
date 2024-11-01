import 'package:flutter/material.dart';

class Planner extends StatefulWidget {
  const Planner({super.key});

  @override
  State<Planner> createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
              'assets/spacebackgroundcalendar.png'
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