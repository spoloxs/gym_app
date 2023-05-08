import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/blocs/workout_cubit.dart';
import 'package:gym_app/helper.dart';
import 'package:gym_app/main.dart';
import 'package:gym_app/models/workout.dart';
import 'package:gym_app/screens/home_page.dart';

import '../blocs/workouts_cubit.dart';
import '../states/workout_states.dart';
import 'editexercise_page.dart';

class editWorkoutScreen extends StatelessWidget {
  const editWorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // Using willpopscop just to work with ios back button
        onWillPop: () => BlocProvider.of<WorkoutCubit>(context)
            .goHome(), // Using willpopscop just to work with ios back button
        child: BlocBuilder<WorkoutCubit, WorkoutState>(
          builder: (context, state) {
            WorkoutEditing we = state as WorkoutEditing;
            return (Scaffold(
              appBar: AppBar(
                title: TextButton(
                  child: Text(
                    we.workout!.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.height / 45),
                  ),
                  onPressed: () {
                    final controller =
                        TextEditingController(text: we.workout!.title);
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              icon: const Text("Workout Name: "),
                              title: TextField(
                                controller: controller,
                                onTapOutside: (event) {
                                  if (controller.text.isNotEmpty) {
                                    Workout renamed = we.workout!
                                        .copyWith(title: controller.text);
                                    BlocProvider.of<WorkoutCubit>(context)
                                        .editWorkout(renamed, we.index);
                                    BlocProvider.of<WorkoutsCubit>(context)
                                        .saveWorkout(renamed, we.index);
                                  }
                                },
                                onSubmitted: (event) {
                                  if (controller.text.isNotEmpty) {
                                    Workout renamed = we.workout!
                                        .copyWith(title: controller.text);
                                    BlocProvider.of<WorkoutCubit>(context)
                                        .editWorkout(renamed, we.index);
                                    BlocProvider.of<WorkoutsCubit>(context)
                                        .saveWorkout(renamed, we.index);
                                  }
                                },
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Workout renamed = we.workout!
                                          .copyWith(title: controller.text);
                                      BlocProvider.of<WorkoutCubit>(context)
                                          .editWorkout(renamed, we.index);
                                      BlocProvider.of<WorkoutsCubit>(context)
                                          .saveWorkout(renamed, we.index);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Rename"))
                              ],
                            ));
                  },
                ),
                leading: BackButton(
                  onPressed: () =>
                      BlocProvider.of<WorkoutCubit>(context).goHome(),
                ),
              ),
              body: ListView.builder(
                  itemCount: we.workout!.exercises.length,
                  itemBuilder: (context, index) {
                    if (we.exindex == index) {
                      return (EditExerciseScreen(
                          workout: we.workout,
                          index: we.index,
                          exIndex: we.exindex));
                    } else {
                      return (ListTile(
                          leading: Text(formatTime(
                              we.workout!.exercises[index].prelude, true)),
                          title: Text(we.workout!.exercises[index].title),
                          trailing: Text(formatTime(
                              we.workout!.exercises[index].duration, true)),
                          onTap: () => BlocProvider.of<WorkoutCubit>(context)
                              .editExercise(index)));
                    }
                  }),
            ));
          },
        ));
  }
}
