import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/blocs/workout_cubit.dart';

import '../models/workout.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Time'),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<WorkoutsCubit, List<Workout>>(
          builder: (context, workouts) => ExpansionPanelList.radio(
            children: workouts.map((e) => ExpansionPanelRadio(
              value: e,
              headerBuilder: (context, isExpanded) => ListTile(
                visualDensity: const VisualDensity(
                  horizontal: 0, vertical: VisualDensity.maximumDensity
                ),
                leading: const IconButton(onPressed: null, icon: Icon(Icons.edit)),
                title: Text(e.title!),
              ),
              body: ListView.builder(shrinkWrap: true,
                itemBuilder: (context, i) => ListTile(
                  leading: Text(""),
                  title: Text(e.excercises[i].title),
              ),
              itemCount: e.excercises.length,
              )
              ),).toList(),
          ),
        ),
      )
    );
  }
}