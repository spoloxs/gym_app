import 'package:equatable/equatable.dart';
import 'package:gym_app/models/workout.dart';

abstract class WorkoutState extends Equatable{
  final Workout? workout;
  final int? elapsed;
  const WorkoutState(this.workout, this.elapsed);
}

class WorkoutInitial extends WorkoutState{ // Create the inital state
  const WorkoutInitial():super(null,0);
  
  @override
  List<Object?> get props => [];// Just to tell initial state has been initialized
}

class WorkoutEditing extends WorkoutState{ // Create the editing state
  const WorkoutEditing(workout, this.index, this.exindex):super(workout,0);
  final int index;
  final int? exindex;
  @override
  List<Object?> get props => [workout, index, exindex];
}