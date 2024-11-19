import 'dart:async';
import "dart:math";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class Countdown extends StatefulWidget {
  const Countdown({super.key});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  final player = AudioPlayer();
  int timerseconds=5;
  int timerminutes=0;
  Timer? timer;
  int? studyseconds=5;
  int? studyminutes=0;
  int? breakseconds=7;
  int? breakminutes=0;
  String patterntime = 'STUDY TIME';
  bool timeractive = false;
  String task = '';
  String motivation = '';
  int numberOfCycles = 0;
  final inputStM=TextEditingController();
  final inputStS=TextEditingController();
  final inputBrM=TextEditingController();
  final inputBrS=TextEditingController();
  String twoDigits(int n) => n.toString().padLeft(2,'0');
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
      studyminutes=prefs.getInt('studyminutes');
      studyseconds=prefs.getInt('studyseconds');
      breakminutes=prefs.getInt('breakminutes');
      breakseconds=prefs.getInt('breakseconds');
      timerminutes=prefs.getInt('studyminutes')!;
      timerseconds=prefs.getInt('studyseconds')!;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('number', numberOfCycles);
    await prefs.setInt('studyminutes', studyminutes!);
    await prefs.setInt('studyseconds', studyseconds!);
    await prefs.setInt('breakminutes', breakminutes!);
    await prefs.setInt('breakseconds', breakseconds!);

  }

  void startTimer(){
    
    if(!timeractive){
      timeractive = true;
      timer=Timer.periodic(const Duration(seconds: 1), (_){
        if(timerseconds==0){
          if(timerminutes==0){
            if(patterntime == 'STUDY TIME'){
              setState(() {
                timerseconds=breakseconds!;
                timerminutes=breakminutes!;
                patterntime='BREAK TIME';
                task=randomTask();
                motivation=randomMotivation();
                numberOfCycles++;
              });
              playNotif();
              
            }else{
              setState(() {
                timerseconds=studyseconds!;
                timerminutes=studyminutes!;
                patterntime='STUDY TIME';
              });
              playNotif();
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
              Text('No. of Badges: ${(numberOfCycles - numberOfCycles.remainder(10))~/10}', 
                style: const TextStyle(color: Colors.white), 
              ),
              Text(patterntime, style: const TextStyle(fontSize: 60,color: Colors.white, fontWeight: FontWeight.bold), ),
              
              Text(patterntime=='BREAK TIME'?task+motivation:'Try your best to be productive.',
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

              const Text('Current Study and Break Time', style: TextStyle(color: Colors.white)),
              Text('Study Time: ${twoDigits(studyminutes!)}:${twoDigits(studyseconds!)} Break Time:${twoDigits(breakminutes!)}:${twoDigits(breakseconds!)}', 
                style: const TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  Expanded(
                    child:
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: inputStM,
                      style: const TextStyle(color: Colors.white),
                      decoration:const InputDecoration(
                        
                        hintText: 'min', hintStyle: TextStyle(color: Colors.white), 
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        ),
                      )
                    ),
                  ),
                  Expanded(
                    child:
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: inputStS,
                      style: const TextStyle(color: Colors.white),
                      decoration:const InputDecoration(
                        
                        hintText: 'sec', hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        ),
                      )
                    ),
                  ),
                  Expanded(
                    child:
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: inputBrM,
                      style: const TextStyle(color: Colors.white),
                      decoration:const InputDecoration(
                        
                        hintText: 'min', hintStyle: TextStyle(color: Colors.white), 
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        ),
                      )
                    ),
                  ),
                  Expanded(
                    child:
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: inputBrS,
                      style: const TextStyle(color: Colors.white),
                      decoration:const InputDecoration(
                        
                        hintText: 'sec', hintStyle: TextStyle(color: Colors.white),
                        
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        ),
                      )
                    ),
                  )
                ],
              ),
              
              
              
                

              
              MaterialButton(
                onPressed: (){
                  if (int.tryParse(inputStM.text)==null || int.tryParse(inputStS.text)==null || int.tryParse(inputBrM.text)==null || int.tryParse(inputBrS.text)==null){
                    showDialog(
                      context: context, 
                      builder: (context) => AlertDialog(
                        actions: [
                          TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            }, 
                            child: const Text('Close')
                          )
                        ],
                        title: const Text('Error'),
                        contentPadding: const EdgeInsets.all(20.0),
                        content: const Text('Please fill in all boxes'),
                      )
                    );
                  }else if(int.tryParse(inputStM.text)!>60 || int.tryParse(inputStS.text)!>59 || int.tryParse(inputBrM.text)!>60 || int.tryParse(inputBrS.text)!>59){
                    showDialog(
                      context: context, 
                      builder: (context) => AlertDialog(
                        actions: [
                          TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            }, 
                            child: const Text('Close')
                          )
                        ],
                        title: const Text('Error'),
                        contentPadding: const EdgeInsets.all(20.0),
                        content: const Text('Please type a number from 0 to 60 for minutes and 0 to 59 for seconds'),
                      )
                    );
                  }else{
                    setState(() {
                      studyminutes=int.tryParse(inputStM.text);
                      studyseconds=int.tryParse(inputStS.text);
                      breakminutes=int.tryParse(inputBrM.text);
                      breakseconds=int.tryParse(inputBrS.text);
                    });
                    
                  }

                  
                },
                color: Colors.grey,
                child: const Text('Set', style: TextStyle(color: Colors.white)),
                  

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
    
    final minutes = twoDigits(timerminutes);
    final seconds = twoDigits(timerseconds);
    return Text(
      '$minutes:$seconds',
      style: const TextStyle(fontSize: 50,color: Colors.yellow),
    );
  }
  Future<void> playNotif() async{
    await player.play(AssetSource('notification.mp3'));
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