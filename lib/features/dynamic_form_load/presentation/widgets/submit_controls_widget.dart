import 'package:dynamic_forms/base_injection_container.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/bloc/bloc.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/bloc/dynamic_checks_load_bloc.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/bloc/dynamic_checks_load_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SubmitControls extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SubmitControlsState();
}

class SubmitControlsState extends State<SubmitControls> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DynamicChecksLoadBloc, DynamicChecksLoadState>(
      cubit: sl<DynamicChecksLoadBloc>(),
      listener: (context, state) {
        // do stuff here based on BlocA's state
        if (state is Empty) {
          return Text("Empty!");
        } else if (state is Loading) {
          return Text("Loading!");
        } else if (state is Loaded) {
          return Text("Loaded!");
        }
        return Text("nothing!");
      },
      child: Row(children: [Text("blah")])
    );
  }
}
