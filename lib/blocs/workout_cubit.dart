import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/models/workout.dart';

import '../states/workout_states.dart';

class WorkoutCubit extends Cubit<WorkoutState>{
  WorkoutCubit():super(const WorkoutInitial());

  editWorkout(Workout workout, int index)
  => emit(WorkoutEditing(workout, index, null));

  goHome() // Setting it to WorkoutInitial as calling it automatically returns us to HomePage() (it's written in the main.dart)
  => emit(const WorkoutInitial());

  editExcercise(int? exindex)
  => emit(WorkoutEditing(state.workout, (state as WorkoutEditing).index, (state as WorkoutEditing).exindex))
}