import 'dart:convert';

import 'package:equatable/equatable.dart';

class Excercise extends Equatable{ // Needs to be equatable in order to be changeable as workout is equatable
  Excercise(
    {
      required this.title,
      required this.prelude,
      required this.duration,
      this.index,
      this.startTime
    }
  ); // constructor

  String title;
  int prelude;
  int duration;
  int? index;
  int? startTime;

  // Also a constructor but can send data already in Excercise class stored in memory
  // so we are using factory
  factory Excercise.fromJson(Map<String, dynamic> json, int index, int startTime) => Excercise(
    title : json["title"], 
    prelude : json["prelude"], 
    duration : json["duration"],
    index : index,
    startTime: startTime
    );

  Map<String, dynamic> toJson () => {
    "title" : title,
    "prelude" : prelude,
    "duration" : duration,
  };
  
  @override
  List<Object?> get props => [title, prelude, duration, index, startTime];
}