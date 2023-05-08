import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/models/exercise.dart';
import 'package:gym_app/models/workout.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class WorkoutsCubit extends HydratedCubit<List<Workout>>{ // Used cubit as we need to change data in it
  WorkoutsCubit():super([]);

  getWorkout() async{
    final List<Workout> workouts = [];

    final workoutsJson = jsonDecode(await rootBundle.loadString("assets/workouts.json"));
    for(var el in (workoutsJson as Iterable))
    {
      workouts.add(Workout.fromJson(el));
    }

    emit(workouts); // Tells flutter change in state of workouts
  }

  saveWorkout(Workout workout, int index) // For saving in the state management memory
  {
    Workout newWorkout = Workout(title: workout.title,
     exercises: []);

     int exindex = 0;
     int startTime = 0;
     for(var ex in workout.exercises)
     {
      newWorkout.exercises.add(
        Exercise(title: ex.title, 
        prelude: ex.prelude, 
        duration: ex.duration,
        index: ex.index,
        startTime: ex.startTime)
      );
      exindex++;
      startTime += ex.prelude + ex.duration; 
     }

     state[index] = newWorkout;
     emit([...state]); // Gets everything already there and either adds or replaces conflicting data if there
  }
  
  @override
  List<Workout>? fromJson(Map<String, dynamic> json) {
    List<Workout> workouts = [];
    
    for(var workout in json["workouts"])
    {
      workouts.add(Workout.fromJson(workout));
    }

    return(workouts);
  }
  
  @override
  Map<String, dynamic>? toJson(List<Workout> state) {
    var json = {
      "workouts" : []
    };
    for(var workout in state)
    {
      json["workouts"]!.add(workout.toJson());
    }

    return(json);
  }
  // We could do this for BLoC
  // on<Events>() async{
  //   final List<Workout> workouts = [];

  //   final workoutsJson = jsonDecode(await rootBundle.loadString("assets/workouts.json"));
  //   for(var el in (workoutsJson as Iterable))
  //   {
  //     workouts.add(Workout.fromJson(el));
  //   }

  //   emit(workouts); 
  // }
}