import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/blocs/workout_cubit.dart';
import 'package:gym_app/helper.dart';
import 'package:gym_app/models/exercise.dart';
import 'package:gym_app/states/workout_states.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../models/workout.dart';

class TimeScreen extends StatelessWidget{
  const TimeScreen({super.key});

  Map<String, dynamic> getstats(Workout workout, int elapsed)
  {
    int workoutTotal = workout.getTotalTime();
    Exercise exercise = workout.getCurrentExercise(elapsed);
    int exerciseElapsed = elapsed - exercise.startTime!;

    bool isprelude = exerciseElapsed < exercise.prelude;
    int completedtime = isprelude ? exerciseElapsed : exerciseElapsed - exercise.prelude;
    int remainingtime = isprelude ? exercise.prelude - exerciseElapsed : exercise.duration + exercise.prelude - exerciseElapsed;

    return{
      "currentexercise" : exercise,
      "totaltime" : workoutTotal,
      "exerciseprogress" : exerciseElapsed,
      "isprelude" : isprelude,
      "completedtime" : completedtime,
      "workoutprogress" : elapsed / workoutTotal,
      "remainingtime" : remainingtime
    };
  }

  @override
  Widget build(BuildContext context){
    return(BlocConsumer<WorkoutCubit, WorkoutState>(
      listener:(context, state) {
        
      },
      builder: (context, state) {
        final stats = getstats(state.workout!, state.elapsed!);
        final bgcolor = stats["isprelude"] ? const Color.fromARGB(255, 252, 186, 186) : const Color.fromARGB(255, 194, 219, 240);
        final maincolor = (stats["isprelude"] ? Colors.red : Colors.blue);
        final height = MediaQuery.of(context).size.height;
        final width = MediaQuery.of(context).size.width;
        return(
          Scaffold(appBar: AppBar(
            leading: BackButton(onPressed: () 
            => BlocProvider.of<WorkoutCubit>(context).goHome(),),
            title: Text(state.workout!.title),
          ),
          body: Column(
            children: [
              Center(child: Text(stats["currentexercise"].title,
              style: TextStyle(
                color: Colors.black26,
                fontSize: height / 30,
                fontWeight: FontWeight.bold,
              ),),),
              SizedBox(
                height: height / 80,
                width: width,
                child: LinearProgressIndicator(
                  minHeight: 10,
                  backgroundColor: bgcolor,
                  color: maincolor,
                  value: stats["workoutprogress"],
                ),
              ),
              SizedBox(
                height: height / 30,
                width: width,
                child: DotsIndicator(
                  decorator: DotsDecorator(
                  activeColor: maincolor,
                  color: bgcolor),
                  position: state.workout!.exercises.indexOf(stats["currentexercise"]),
                  dotsCount: state.workout!.exercises.length,
                )
              ),
              Container(height: height / 10,),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.0/1.0,
                  child: Stack(
                    children: [CircularStepProgressIndicator(
                      unselectedColor: bgcolor,
                      selectedColor: maincolor,
                      totalSteps: stats["isprelude"] ? stats["currentexercise"].prelude : stats["currentexercise"].duration,
                      currentStep: stats["completedtime"],
                      ),
                  Center(child: Text(formatTime((stats['remainingtime']), true)))],
                  ),
                ),
              ),
              Container(height: height / 10,),
            ],
          ),
          )
        );
      }
    ,));
  }
}