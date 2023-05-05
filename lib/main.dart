import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/blocs/workout_cubit.dart';
import 'package:gym_app/models/workout.dart';
import 'package:gym_app/screens/home_page.dart';

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
          bodyMedium: TextStyle(color: Colors.amber), 
        )
      ),
      home: BlocProvider<WorkoutsCubit>(
        create: (BuildContext context){
          WorkoutsCubit workoutsCubit = WorkoutsCubit();
          if(workoutsCubit.state.isEmpty)
          {
            print("..loading data");
            workoutsCubit.getWorkout();
          }
          else
          {
            print("..loaded data");
          }
          return (workoutsCubit);
        },
        child: BlocBuilder<WorkoutsCubit, List<Workout>>(
              builder: (context, state){
                return const HomePage();
              },
        ),
      ),
    );
  }
}