import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dynamic_forms/common/error/failure.dart';
import 'package:dynamic_forms/common/util/presentation/input_converter.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/checks_page_entity.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/usecases/get_checks_page.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class DynamicChecksLoadBloc extends Bloc<DynamicChecksLoadEvent, DynamicChecksLoadState> {
  final GetChecksPage getChecksPage;
  final InputConverter inputConverter;

  DynamicChecksLoadBloc({
    @required GetChecksPage concrete,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(inputConverter != null),
        this.getChecksPage = concrete, super(Empty());

  @override
  Stream<DynamicChecksLoadState> mapEventToState(
      DynamicChecksLoadEvent event,
      ) async* {
    if (event is GetChecksPageEvent) {
      final inputEither = inputConverter.stringToUnsignedInteger(event.countryId);

      yield* inputEither.fold(
            (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
            (integer) async* {
              yield Loading();
              final failureOrChecksPage = await getChecksPage(GetChecksPageParams(checkPageId: integer));
              yield* _eitherLoadedOrErrorState(failureOrChecksPage);
            },
      );
    }
  }

  Stream<DynamicChecksLoadState> _eitherLoadedOrErrorState(
      Either<Failure, ChecksPageEntity> either,
      ) async* {
    yield either.fold(
          (failure) => Error(message: _mapFailureToMessage(failure)),
          (page) => Loaded(checksPage: page),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch(failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}