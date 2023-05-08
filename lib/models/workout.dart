import 'package:equatable/equatable.dart';

import 'exercise.dart';

class Workout extends Equatable{ // As this data will change as per user, we need to use Equatable
  
  final String title;
  final List<Exercise> exercises;
  const Workout({required this.title, required this.exercises});

  factory Workout.fromJson(Map <String, dynamic> json){
    List<Exercise> exercises = [];
    int index = 0; 
    int startTime = 0;
    for(var ex in (json['exercises'] as Iterable))
    {
      exercises.add(Exercise.fromJson(ex, index, startTime));
      index++;
      startTime += exercises.last.prelude + exercises.last.duration;
    }
    return(Workout(title: json['title'] as String, exercises: exercises));
  }

  Map<String, dynamic> toJson() => {
    "title" : title,
    "exercises" : exercises,
  };

  int getTotalTime(){
    int time = exercises.fold(0, (previousValue, element) => previousValue + element.prelude + element.duration);
    return time;
  }

  copyWith({String? title, List<Exercise>? exercises}) => Workout(title: title??this.title, exercises: exercises??this.exercises);

  Exercise getCurrentExercise(int? elapsed) => (exercises.lastWhere((element) => element.startTime! <= elapsed!));

  @override
  List<Object?> get props => [title, exercises];
}