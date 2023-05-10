import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/models/exercise.dart';
import 'package:gym_app/models/workout.dart';
import 'package:wakelock/wakelock.dart';

import '../states/workout_states.dart';

class WorkoutCubit extends Cubit<WorkoutState>{
  WorkoutCubit():super(const WorkoutInitial());

  Timer? _timer;

  editWorkout(Workout workout, int index)
  => emit(WorkoutEditing(workout, index, null));

  goHome() // Setting it to WorkoutInitial as calling it automatically returns us to HomePage() (it's written in the main.dart)
  => emit(const WorkoutInitial());

  editExercise(int? exindex)
  => emit(WorkoutEditing(state.workout, (state as WorkoutEditing).index, exindex));

  onTick(Timer timer){
    if (state is WorkoutRunning)
    {
      WorkoutRunning wr = state as WorkoutRunning;
      if(wr.elapsed! < wr.workout!.getTotalTime())
      {
        emit(WorkoutRunning(wr.workout, wr.elapsed! + 1));
      }
      else{
        timer.cancel();
        Wakelock.disable();
        emit(const WorkoutInitial());
      }
    }
    else{
      timer.cancel();
    }
  }
  
  startWorkout(Workout workout, [int? index])
  {
    Wakelock.enable();
    emit(WorkoutRunning(workout, 0));
    if(state is WorkoutRunning)
     {_timer = Timer.periodic(const Duration(seconds: 1), onTick);}
  }

}