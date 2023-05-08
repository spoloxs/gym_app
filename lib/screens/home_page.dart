import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/blocs/workout_cubit.dart';
import 'package:gym_app/blocs/workouts_cubit.dart';
import 'package:gym_app/screens/timer_screen.dart';
import 'package:gym_app/states/workout_states.dart';

import '../helper.dart';
import '../models/workout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Workout Time',)),
        ),
        body: SingleChildScrollView(
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
                                  onPressed: () =>
                                      BlocProvider.of<WorkoutCubit>(context)
                                          .editWorkout(
                                              workoutiterable,
                                              workouts
                                                  .indexOf(workoutiterable)),
                                  icon: const Icon(Icons.edit)),
                              title: Text(workoutiterable.title),
                              trailing: Text(formatTime(
                                  workoutiterable.getTotalTime(), true)),
                              onTap:() {
                                BlocProvider.of<WorkoutCubit>(context).startWorkout(workoutiterable);
                                },
                            ),
                        body: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, i) => ListTile(
                            leading: Text(formatTime(
                                workoutiterable.exercises[i].prelude, true)),
                            title: Text(workoutiterable.exercises[i].title),
                            trailing: Text(formatTime(
                                workoutiterable.exercises[i].duration, true)),
                          ),
                          itemCount: workoutiterable.exercises.length,
                        )),
                  )
                  .toList(),
            ),
          ),
        ));
  }
}
