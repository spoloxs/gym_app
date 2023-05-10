import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/blocs/workout_cubit.dart';
import 'package:gym_app/helper.dart';
import 'package:gym_app/models/exercise.dart';
import 'package:gym_app/models/workout.dart';

import '../blocs/workouts_cubit.dart';
import '../states/workout_states.dart';
import 'editexercise_page.dart';

class EditWorkoutScreen extends StatelessWidget {
  const EditWorkoutScreen({Key? key}) : super(key: key);

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
              body:Stack(
                children: [
              ListView.builder(
                  itemCount: we.workout!.exercises.length,
                  itemBuilder: (context, index) {
                    if (we.exindex == index) {
                      return (EditExerciseScreen(
                          workout: we.workout,
                          index: we.index,
                          exIndex: we.exindex));
                    } else {
                      return (ListTile(
                          onLongPress: () =>
                          showDialog(context: context,
                           builder: (_) =>
                           AlertDialog(
                            content: Text("Do you want to delete the exercise \"${we.workout!.exercises[index].title}\" ?"),
                            actions: [TextButton(onPressed: (){
                            final editedWorkout = removeExercise(title: we.workout!.exercises[index].title, workout: we.workout!);
                            BlocProvider.of<WorkoutCubit>(context)
                            .editWorkout(editedWorkout, we.index);
                            BlocProvider.of<WorkoutsCubit>(context)
                            .saveWorkout(editedWorkout, we.index);
                            Navigator.of(_).pop();
                            },
                             child: const Text("Delete"))],
                           )),
                          leading: Text(formatTime(
                              we.workout!.exercises[index].prelude, true)),
                          title: Text(we.workout!.exercises[index].title),
                          trailing: Text(formatTime(
                              we.workout!.exercises[index].duration, true)),
                          onTap: () => BlocProvider.of<WorkoutCubit>(context)
                              .editExercise(index)));
                    }
                  }),
                  Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 1.3, 
                    left: MediaQuery.of(context).size.width / 1.4),
                    child: Container(
                      width: 80,
                      height: 80,
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,                        
                      ),
                      child: FloatingActionButton(onPressed: ()
                      {
                        showDialog(context: context,
                         builder: (_) {
                          final controllertitle = TextEditingController();
                          final controllerduration = TextEditingController(text: "0");
                          final controllerprelude = TextEditingController(text: "0");
                          return(
                            AlertDialog(
                              title: Column(
                                children: [
                                  const Text("Enter exercise name: "),
                                  TextField(
                                    onTap: ()=> controllertitle.clear(),
                                    controller: controllertitle,
                                  ),
                                  const Text("Enter duration: "),
                                  TextField(
                                    controller: controllerduration,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(4),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                  const Text("Enter prelude: "),
                                  TextField(
                                    controller: controllerprelude,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(4),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  )
                                ],
                              ),
                              actions: [
                                TextButton(onPressed: (){
                                  if (controllertitle.text.trim().isNotEmpty)
                                  {
                                    final editedWorkout = addNewExercise(
                                    duration: int.parse(controllerduration.text) > 3599 ? 3599 : int.parse(controllerduration.text),
                                    prelude: int.parse(controllerprelude.text) > 3599 ? 3599 : int.parse(controllerprelude.text),
                                    title: controllertitle.text,
                                    workout: we.workout!);
                                    BlocProvider.of<WorkoutCubit>(context).editWorkout(editedWorkout, we.index);
                                    BlocProvider.of<WorkoutsCubit>(context).saveWorkout(editedWorkout, we.index);
                                    Navigator.of(_).pop();
                                  }
                                  else
                                  {
                                    controllertitle.text = "Cannot be empty...";
                                  }
                                },
                                 child: const Text("ADD"))
                              ],
                            )
                          );
                         });
                      },
                      backgroundColor: Colors.amber,
                      child: const Icon(Icons.add),
                      ),
                    ),),
                  ]),
            ));
          },
        ));
  }

   Workout removeExercise({required String title, required Workout workout})
  {
    Workout editedWorkout = Workout(title: workout.title,
     exercises: List.from(workout.exercises));
    bool found = editedWorkout.exercises.any((element) => element.title == title);
    found ? editedWorkout.exercises.removeWhere((element) => element.title == title) : null;
    return(editedWorkout);
  }


  Workout addNewExercise({required String title,
  required int duration,
  required int prelude,
  required Workout workout}){
    int startTime = workout.exercises.isNotEmpty ? 
            (workout.exercises.last.startTime! + workout.exercises.last.duration + workout.exercises.last.prelude) : 0;

    final Exercise newExercise = Exercise(title: title,
     prelude: prelude,
     duration: duration,
     startTime: startTime);

    Workout editedWorkout = Workout(title: workout.title,
     exercises: List.from(workout.exercises));
    editedWorkout.exercises.add(newExercise);

    return(editedWorkout);
  }
}
