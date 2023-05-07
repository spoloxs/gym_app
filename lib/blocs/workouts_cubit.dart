import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/models/exercise.dart';
import 'package:gym_app/models/workout.dart';

class WorkoutsCubit extends Cubit<List<Workout>>{ // Used cubit as we need to change data in it
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
     excercises: []);

     int exindex = 0;
     int startTime = 0;
     for(var ex in workout.excercises)
     {
      newWorkout.excercises.add(
        Excercise(title: ex.title, 
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