import 'dart:convert';

import 'package:flutter/services.dart';
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

     for(var ex in workout.exercises)
     {
      newWorkout.exercises.add(
        Exercise(title: ex.title, 
        prelude: ex.prelude, 
        duration: ex.duration,
        index: ex.index,
        startTime: ex.startTime)
      );
     }

     state[index] = newWorkout;
     emit([...state]); // Gets everything already there and either adds or replaces conflicting data if there
  }

  addWorkout(String title) // For adding in the state management memory
  {
     bool found = state.every((element) => element.title == title);
     Workout newWorkout = Workout(title: title,
     exercises: const []);
     found ? saveWorkout(newWorkout, state.indexOf(newWorkout)) :
     state.add(newWorkout);
     emit([...state]); // Gets everything already there and either adds or replaces conflicting data if there
  }

  removeWorkout(String title)
  {
    bool found = state.any((element) => element.title == title);
    found ? state.removeWhere((element) => element.title == title) : null;
    emit([...state]);
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