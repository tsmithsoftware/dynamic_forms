import 'dart:convert';

import 'package:dynamic_forms/core/error/exception.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/checks_page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ChecksPageLocalDataSource {
  Future<ChecksPageModel> getLastChecksPageModel();
  Future<void> cacheChecksPageModel(ChecksPageModel modelToCache);
}

const CACHED_CHECKS_PAGE = "CACHED_CHECKS_PAGE";

class ChecksPageLocalDataSourceImpl implements ChecksPageLocalDataSource {
  final SharedPreferences sharedPreferences;

  ChecksPageLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheChecksPageModel(ChecksPageModel modelToCache) {
    // TODO: implement cacheChecksPageModel
    throw UnimplementedError();
  }

  @override
  Future<ChecksPageModel> getLastChecksPageModel() {
    final jsonString = sharedPreferences.getString(CACHED_CHECKS_PAGE);
    if (jsonString != null) {
      return Future.value(ChecksPageModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}