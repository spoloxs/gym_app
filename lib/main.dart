import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/blocs/workouts_cubit.dart';
import 'package:gym_app/models/workout.dart';
import 'package:gym_app/screens/editworkout_page.dart';
import 'package:gym_app/screens/home_page.dart';
import 'package:gym_app/states/workout_states.dart';

import 'blocs/workout_cubit.dart';

void main() {
  runApp(const WorkoutClass());
}

class WorkoutClass extends StatelessWidget {
  const WorkoutClass({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Workouts',
        theme: ThemeData(
            primaryColor: Colors.blue,
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.black38),
            )),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<WorkoutsCubit>(create: (BuildContext context) {
              WorkoutsCubit workoutsCubit = WorkoutsCubit();
              if (workoutsCubit.state.isEmpty) {
                workoutsCubit.getWorkout();
              }
              return (workoutsCubit);
            }),
            BlocProvider<WorkoutCubit>(
                create: (BuildContext context) => WorkoutCubit())
          ],
          child: BlocBuilder<WorkoutCubit, WorkoutState>(
            builder: (context, state) {
              if (state is WorkoutInitial) {
                return (const HomePage());
              } else if (state is WorkoutEditing) {
                return (const editWorkoutScreen());
              }
              return Container();
            },
          ),
        ));
  }
}
