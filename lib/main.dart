import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/blocs/workouts_cubit.dart';
import 'package:gym_app/screens/editworkout_page.dart';
import 'package:gym_app/screens/home_page.dart';
import 'package:gym_app/screens/timer_screen.dart';
import 'package:gym_app/states/workout_states.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'blocs/workout_cubit.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory()
  );
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
              return (const TimeScreen());
            },
          ),
        ));
  }
}
