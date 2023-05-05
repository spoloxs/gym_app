import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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