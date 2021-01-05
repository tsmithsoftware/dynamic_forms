import 'dart:convert';

import 'package:dynamic_forms/common/error/exception.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/checks_page_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visit_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ChecksPageLocalDataSource {
  Future<ChecksPageModel> getLastChecksPageModel();

  Future<void> cacheChecksPageModel(ChecksPageModel modelToCache);

  Future<void> cacheSignInVisitor(VisitModel visit);
}

const CACHED_CHECKS_PAGE = "CACHED_CHECKS_PAGE";

class ChecksPageLocalDataSourceImpl implements ChecksPageLocalDataSource {
  final SharedPreferences sharedPreferences;

  ChecksPageLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheChecksPageModel(ChecksPageModel modelToCache) async {
   return sharedPreferences.setString(CACHED_CHECKS_PAGE, json.encode(modelToCache.toJson()));
  }

  @override
  Future<ChecksPageModel> getLastChecksPageModel() async {
    final jsonString = sharedPreferences.getString(CACHED_CHECKS_PAGE);
    if (jsonString != null) {
      return Future.value(ChecksPageModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheSignInVisitor(VisitModel visit) async {
    // TODO: implement cacheSignInVisitor
    throw UnimplementedError();
  }
}