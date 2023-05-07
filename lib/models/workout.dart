import 'package:equatable/equatable.dart';

import 'exercise.dart';

class Workout extends Equatable{ // As this data will change as per user, we need to use Equatable
  
  final String title;
  final List<Excercise> excercises;
  const Workout({required this.title, required this.excercises});
  factory Workout.fromJson(Map <String, dynamic> json){
    List<Excercise> excercises = [];
    int index = 0; 
    int startTime = 0;
    for(var ex in (json['exercises'] as Iterable))
    {
      excercises.add(Excercise.fromJson(ex, index, startTime));
      index++;
      startTime += excercises.last.prelude + excercises.last.duration;
    }
    return(Workout(title: json['title'] as String, excercises: excercises));
  }

  Map<String, dynamic> toJson() => {
    "title" : title,
    "excercises" : excercises,
  };

  int getTotalTime(){
    int time = excercises.fold(0, (previousValue, element) => previousValue + element.prelude + element.duration);
    return time;
  }

  copyWith({String? title, List<Excercise>? excercises}) => Workout(title: title??this.title, excercises: excercises??this.excercises);

  @override
  List<Object?> get props => [title, excercises];
}