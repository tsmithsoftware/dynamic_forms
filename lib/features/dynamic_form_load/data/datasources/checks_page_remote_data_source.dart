import 'package:dynamic_forms/features/dynamic_form_load/data/models/checks_page_model.dart';

abstract class ChecksPageRemoteDataSource {
  Future<ChecksPageModel> getChecksPage(int countryNumber);
}