import 'package:dynamic_forms/base_injection_container.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/widgets/widgets.dart';

class DynamicChecksPage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Checks'),
      ),
      body: Scrollbar(controller: _scrollController,isAlwaysShown: true,child: SingleChildScrollView(child: buildBody(context))),
    );
  }

  BlocProvider<DynamicChecksLoadBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DynamicChecksLoadBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top half
            BlocBuilder<DynamicChecksLoadBloc, DynamicChecksLoadState>(
              builder: (context, state) {
                if (state is Empty) {
                  return MessageDisplay(
                    message: "start searching!",
                  );
                } else if (state is Loading) {
                  return LoadingWidget();
                } else if (state is Loaded) {
                  return SingleChildScrollView(child: DynamicChecksPageDisplay(checksPageModel: state.checksPage));
                }
                else if (state is Error) {
                  return MessageDisplay (
                    message: state.message,
                  );
                }
                return Container();
              },
            ),
              SizedBox(height: 20),
              // Bottom half
              PageControls(),
            ],
          ),
        ),
      ),
    );
  }
}
