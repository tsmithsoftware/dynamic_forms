import 'package:bloc/bloc.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/usecases/sign_in_visitor.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/bloc/form_submit_bloc/form_submit_event.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/bloc/form_submit_bloc/form_submit_state.dart';

class FormSubmitBloc extends Bloc<FormSubmitEvent, FormSubmitState> {
  final SignInVisitor usecase;

  FormSubmitBloc(this.usecase) : super(FormSubmitEmpty());

  @override
  Stream<FormSubmitState> mapEventToState(FormSubmitEvent event) async* {
    if (event is SubmitVisitorSigninEvent) {
      yield FormSubmitLoading();
      final failureOrSuccess = await usecase(SignInVisitorParams(event.model));
      yield failureOrSuccess.fold(
          (l) => FormSubmitError(l), (r) => FormSubmitLoaded());
    }
  }
}
