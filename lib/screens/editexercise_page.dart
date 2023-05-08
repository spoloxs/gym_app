import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/blocs/workout_cubit.dart';
import 'package:gym_app/helper.dart';
import 'package:gym_app/models/exercise.dart';
import 'package:gym_app/models/workout.dart';
import 'package:numberpicker/numberpicker.dart';

import '../blocs/workouts_cubit.dart';

class EditExerciseScreen extends StatefulWidget {
  const EditExerciseScreen(
      {Key? key, this.workout, required this.index, this.exIndex})
      : super(key: key);
  final Workout? workout;
  final int index;
  final int? exIndex;

  @override
  State<StatefulWidget> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  TextEditingController? _titlecontroller;
  @override
  void initState() {
    _titlecontroller = TextEditingController(
        text: widget.workout!.exercises[widget.exIndex!].title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: ()=> showDialog(context: context,
             builder: ((_){
              final controller = TextEditingController(text: '${widget.workout!.exercises[widget.exIndex!].prelude}');
             return AlertDialog(
              icon: const Center(
                child: Text("Set Prelude:"),
              ),
              title: TextField(
                controller: controller,
                inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(4),
                    FilteringTextInputFormatter.digitsOnly
                ],
                onSubmitted: (value) => setState(() {
                  widget.workout!.exercises[widget.exIndex!] = widget
                  .workout!.exercises[widget.exIndex!]
                  .CopyWith(prelude: int.parse(controller.text) > 3599 ? 3599 : int.parse(controller.text));
                  BlocProvider.of<WorkoutsCubit>(context)
                  .saveWorkout(widget.workout!, widget.index);
                }),
                onTapOutside: (value) => setState(() {
                  widget.workout!.exercises[widget.exIndex!] = widget
                  .workout!.exercises[widget.exIndex!]
                  .CopyWith(prelude: int.parse(controller.text) > 3599 ? 3599 : int.parse(controller.text));
                  BlocProvider.of<WorkoutsCubit>(context)
                  .saveWorkout(widget.workout!, widget.index);
                }),
              ),
             );})),
            child: NumberPicker(
                minValue: 0,
                maxValue: 3599,
                value: widget.workout!.exercises[widget.exIndex!].prelude,
                textMapper: (numberText) =>
                    formatTime(int.parse(numberText), false),
                onChanged: (value) => setState(() {
                  widget.workout!.exercises[widget.exIndex!] = widget
                  .workout!.exercises[widget.exIndex!]
                  .CopyWith(prelude: value);
              BlocProvider.of<WorkoutsCubit>(context)
                  .saveWorkout(widget.workout!, widget.index);
                })),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextField(
            textAlign: TextAlign.center,
            controller: _titlecontroller,
            onChanged: (value) => setState(() {
              widget.workout!.exercises[widget.exIndex!] = widget
                  .workout!.exercises[widget.exIndex!]
                  .CopyWith(title: value);
              BlocProvider.of<WorkoutsCubit>(context)
                  .saveWorkout(widget.workout!, widget.index);
            }),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: ()=> showDialog(context: context,
             builder: ((_){
              final controller = TextEditingController(text: '${widget.workout!.exercises[widget.exIndex!].duration}');
             return AlertDialog(
              icon: const Center(
                child: Text("Set Duration:"),
              ),
              title: TextField(
                controller: controller,
                inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(4),
                    FilteringTextInputFormatter.digitsOnly,
                ],
                onSubmitted: (value) => setState(() {
                  widget.workout!.exercises[widget.exIndex!] = widget
                  .workout!.exercises[widget.exIndex!]
                  .CopyWith(duration: int.parse(controller.text) > 3599 ? 3599 : int.parse(controller.text));
                  BlocProvider.of<WorkoutsCubit>(context)
                  .saveWorkout(widget.workout!, widget.index);
                }),
                onTapOutside: (value) => setState(() {
                  widget.workout!.exercises[widget.exIndex!] = widget
                  .workout!.exercises[widget.exIndex!]
                  .CopyWith(duration: int.parse(controller.text) > 3599 ? 3599 : int.parse(controller.text));
                  BlocProvider.of<WorkoutsCubit>(context)
                  .saveWorkout(widget.workout!, widget.index);
                }),
              ),
             );})),
            child: NumberPicker(
                minValue: 0,
                maxValue: 3599,
                value: widget.workout!.exercises[widget.exIndex!].duration,
                textMapper: (numberText) =>
                    formatTime(int.parse(numberText), false),
                onChanged: (value) => setState(() {
                  widget.workout!.exercises[widget.exIndex!] = 
                  widget.workout!.exercises[widget.exIndex!]
                  .CopyWith(duration: value);
              BlocProvider.of<WorkoutsCubit>(context)
                  .saveWorkout(widget.workout!, widget.index);
                })),
          ),
        ),
      ],
    );
  }
}
