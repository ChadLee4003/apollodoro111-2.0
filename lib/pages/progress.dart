import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  int numberOfCycles=0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      numberOfCycles=prefs.getInt('number')??0;
    });
  }


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
              CircularPercentIndicator(
                radius: 200,
                lineWidth: 30,
                percent: 1-numberOfCycles.remainder(10)*0.1,
                center: Text('${10-numberOfCycles.remainder(10)} more until next badge', 
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
                progressColor: Colors.yellow,
                backgroundColor: Colors.yellow.shade100
              ),

              Image.asset('assets/Badge.png', width: 300, height: 150),

              Text('X ${(numberOfCycles - numberOfCycles.remainder(10))~/10}', 
              style: const TextStyle(color: Colors.white, fontSize: 50)),

              
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