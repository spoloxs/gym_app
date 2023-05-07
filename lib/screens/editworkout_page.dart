import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/blocs/workout_cubit.dart';
import 'package:gym_app/helper.dart';
import 'package:gym_app/main.dart';
import 'package:gym_app/models/workout.dart';
import 'package:gym_app/screens/home_page.dart';

import '../states/workout_states.dart';

class editWorkoutScreen extends StatelessWidget {
  const editWorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // Using willpopscop just to work with ios back button
        onWillPop:() => BlocProvider.of<WorkoutCubit>(context).goHome(), // Using willpopscop just to work with ios back button
        child: BlocBuilder<WorkoutCubit, WorkoutState>(
          builder: (context, state) {
            WorkoutEditing we = state as WorkoutEditing;
            return (Scaffold(
              appBar: AppBar(
                title: Text(we.workout!.title),
                leading: BackButton(
                  onPressed: () =>
                      BlocProvider.of<WorkoutCubit>(context).goHome(),
                ),
              ),
              body: ListView.builder(
                  itemCount: we.workout!.excercises.length,
                  itemBuilder: (context, index) {
                    return (ListTile(
                      leading:
                          Text(formatTime(we.workout!.excercises[index].prelude, true)),
                      title: Text(we.workout!.excercises[index].title),
                      trailing: Text(formatTime(we.workout!.excercises[index].duration, true)),
                    ));
                  }),
            ));
          },
        ));
  }
}
