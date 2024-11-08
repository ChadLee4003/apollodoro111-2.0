import 'dart:async';
import "dart:math";
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Countdown extends StatefulWidget {
  const Countdown({super.key});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  int timerseconds=0;
  int timerminutes=25;
  Timer? timer;
  String patterntime = 'Study Time';
  bool timeractive = false;
  String task = '';
  String motivation = '';
  int numberOfCycles = 0;
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  void dispose() {
    _saveData();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      numberOfCycles=prefs.getInt('number')??0;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('number', numberOfCycles);

  }

  void startTimer(){
    
    if(!timeractive){
      timeractive = true;
      timer=Timer.periodic(const Duration(seconds: 1), (_){
        if(timerseconds==0){
          if(timerminutes==0){
            if(patterntime == 'Study Time'){
              setState(() {
                timerseconds=0;
                timerminutes=5;
                patterntime='Break Time';
                task=randomTask();
                motivation=randomMotivation();
                numberOfCycles++;
              });
            }else{
              setState(() {
                timerseconds=0;
                timerminutes=25;
                patterntime='Study Time';
              });
            }
          }else{
            setState(() {
              timerminutes--;
              timerseconds=59;
            });
          }
        }else{
          setState(() {
            timerseconds--;
          });
        }
        
      });

    }
  }

  void stopTimer(){
    timer?.cancel();
    timeractive = false;
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
              'assets/spacebackground7.jpg'
              ),
              fit:BoxFit.cover,
            ),
          ),

          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(patterntime, style: const TextStyle(fontSize: 60,color: Colors.white)),

              Text(patterntime=='Break Time'?task+motivation:'Try your best to be productive.',
                style: const TextStyle(fontSize: 30, color: Colors.yellow),
                textAlign: TextAlign.center,
              ),

              Image.network('https://r2.erweima.ai/midjourney/1712246037_42b548d1a96d4256819b835faa513ae0.png', width: 300, height: 300),

              buildTimer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: startTimer,
                    color: Colors.green,
                    child: const Text('S T A R T', style: TextStyle(color: Colors.white),),
                  ),

                  const SizedBox(width: 20),

                  MaterialButton(
                    onPressed: stopTimer,
                    color: Colors.red,
                    child: const Text('S T O P', style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
              
              MaterialButton(onPressed:(){
                timer?.cancel();
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



  Widget buildTimer(){
  String twoDigits(int n) => n.toString().padLeft(2,'0');
  final minutes = twoDigits(timerminutes);
  final seconds = twoDigits(timerseconds);
  return Text(
    '$minutes:$seconds',
    style: const TextStyle(fontSize: 50,color: Colors.yellow),
  );
}
}

String randomTask(){
  int number=Random().nextInt(5);
  String task = '';
  if(number==0){
    task='Stretch your back. ';
  }else if (number ==1){
    task='Walk around. ';
  }else if (number ==2){
    task='Look outside. ';
  }else if (number ==3){
    task='Lay down and meditate. ';
  }else{
    task='Wash your face. ';
  }
  return task;
}

String randomMotivation(){
  int number=Random().nextInt(5);
  String motivation = '';
  if(number==0){
    motivation='You can do it! ';
  }else if (number ==1){
    motivation='Believe in yourself! ';
  }else if (number ==2){
    motivation="Don't give up! ";
  }else if (number ==3){
    motivation='Never lose your sparkle! ';
  }else{
    motivation='Failure is a stepping stone to success! ';
  }
  return motivation;
}