import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/blocs/workout_cubit.dart';
import 'package:gym_app/blocs/workouts_cubit.dart';

import '../helper.dart';
import '../models/workout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text(
            'Workout Time',
          )),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: BlocBuilder<WorkoutsCubit, List<Workout>>(
                    builder: (context, workouts) => ExpansionPanelList.radio(
                      children: workouts
                          .map(
                            (workoutiterable) => ExpansionPanelRadio(
                                value: workoutiterable,
                                headerBuilder: (context, isExpanded) => ListTile(
                                      visualDensity: const VisualDensity(
                                          horizontal: 0,
                                          vertical: VisualDensity.maximumDensity),
                                      leading: IconButton(
                                          onPressed: () => BlocProvider.of<
                                                  WorkoutCubit>(context)
                                              .editWorkout(
                                                  workoutiterable,
                                                  workouts
                                                      .indexOf(workoutiterable)),
                                          icon: const Icon(Icons.edit)),
                                      title: Text(workoutiterable.title),
                                      trailing: Text(formatTime(
                                          workoutiterable.getTotalTime(), true)),
                                      onTap: () {
                                        workoutiterable.exercises.isNotEmpty ?
                                        BlocProvider.of<WorkoutCubit>(context)
                                            .startWorkout(workoutiterable) :
                                        showDialog(context: context,
                                         builder: (_) =>
                                          const AlertDialog(
                                            content: Text("No exercises found. Consider adding exercises"),
                                          )
                                         );
                                      },
                                      onLongPress: (){
                                        showDialog(context: context,
                                         builder: (_) =>
                                         AlertDialog(
                                          content: Text("Do you want to delete the workout \"${workoutiterable.title}\" ?"),
                                          actions: [
                                            TextButton(onPressed: (){
                                              BlocProvider.of<WorkoutsCubit>(context)
                                              .removeWorkout(workoutiterable.title);
                                              Navigator.pop(_);
                                            },
                                             child: const Text("Delete"))
                                          ],
                                         ));
                                      },
                                    ),
                                body: ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) => ListTile(
                                    leading: Text(formatTime(
                                        workoutiterable.exercises[i].prelude,
                                        true)),
                                    title:
                                        Text(workoutiterable.exercises[i].title),
                                    trailing: Text(formatTime(
                                        workoutiterable.exercises[i].duration,
                                        true)),
                                  ),
                                  itemCount: workoutiterable.exercises.length,
                                )),
                          )
                          .toList(growable: true),
                    ),
                  ),
                ),
              ),
              ),
            ),
            // const Spacer(),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: SizedBox(
                    height: 70,
                    child: Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10),),
                            color: Colors.blue,),
                          width: MediaQuery.of(context).size.width / 2 - 50,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 60,
                          color: Colors.blue,
                          width: 100 ,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),),
                            color: Colors.blue,),
                          width: MediaQuery.of(context).size.width / 2 - 50,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: FloatingActionButton(
                        child: const Icon(Icons.add), onPressed: () {
                          showDialog(context: context,
                           builder: (_) {
                            final controller = TextEditingController();
                            return AlertDialog(
                              content: TextField(
                                onTap:()=> controller.clear(),
                                controller: controller,
                              ),
                              title: const Text("Name Of Workout: ", 
                              style: TextStyle(color: Colors.grey)),
                              actions: [
                                TextButton(onPressed: () {
                                  controller.text.trim().isNotEmpty? 
                                  {
                                    BlocProvider.of<WorkoutsCubit>(context)
                                  .addWorkout(controller.text),
                                  Navigator.of(context).pop()
                                  } : null;
                                },
                                 child: const Text("Add"))
                              ],
                            );
                           });
                        }),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

