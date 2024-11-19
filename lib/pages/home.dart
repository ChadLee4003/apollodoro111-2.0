import 'package:apollodoro111/pages/calendar.dart';
import 'package:apollodoro111/pages/progress.dart';
import 'package:apollodoro111/pages/timer.dart';
import 'package:flutter/material.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
              const Text('Apollodoro 111', style: TextStyle(fontSize: 55,color: Colors.white, fontWeight: FontWeight.bold)),

              Image.asset('assets/Drafy.png', width: 300, height: 300),

              const SizedBox(height: 20),

              MaterialButton(onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Countdown()),
                );
              },
              color: Colors.grey,
              child: const Text('Go to Timer',style: TextStyle(color: Colors.white),),
              ),

              const SizedBox(height: 20),

              MaterialButton(onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Planner()),
                );
              },
              color: Colors.grey,
              child: const Text('Go to Calendar',style: TextStyle(color: Colors.white),),
              ),

              const SizedBox(height: 20),

              MaterialButton(onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Progress()),
                );
              },
              color: Colors.grey,
              child: const Text('Go to Badges',style: TextStyle(color: Colors.white),),
              )
            ]
          )      
        )
      )    
    );
  }
}

