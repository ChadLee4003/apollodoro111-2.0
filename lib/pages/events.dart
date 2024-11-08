import 'dart:convert';

class Event {
  final String title;

  Event(this.title);

  Map<String, dynamic> toJson() => {
    'title': title,
  };

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(json['title']);
  }

  @override
  String toString() => title;
}

// alignment: Alignment.center,
// decoration: const BoxDecoration(
//   image: DecorationImage(
//     image: AssetImage('assets/spacebackgroundcalendar.png'),
//     fit: BoxFit.cover,
//   ),
// ),


// MaterialButton(
//   onPressed: () {
//     Navigator.pop(context);
//   },
//   color: Colors.grey,
//   child: const Text('Back to Home',
//     style: TextStyle(color: Colors.white),
//   ),
// ),