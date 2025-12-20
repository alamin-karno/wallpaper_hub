import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/constants.dart';
import 'dio_interceptor.dart';

@module
abstract class DioModule {
  @Named("Authorized")
  @singleton
  Dio getAuthorizedDioClient() {
    final dioClint = _dioClient();
    dioClint.interceptors.addAll([AuthorizedRequestInterceptor()]);

    if (kDebugMode) {
      dioClint.interceptors.add(PrettyDioLogger(
        requestBody: true,
        responseBody: true,
      ));
    }

    return dioClint;
  }

  @Named('Unauthorized')
  @singleton
  Dio getUnauthorizedDioClient() {
    final dioClint = _dioClient();
    dioClint.interceptors.addAll([UnauthorizedRequestInterceptor()]);

    if (kDebugMode) {
      dioClint.interceptors.add(PrettyDioLogger(
        requestBody: true,
        responseBody: true,
      ));
    }

    return dioClint;
  }

  @Named('Download')
  @singleton
  Dio getDownloadDioClient() {
    final dioClint = _dioClient();
    dioClint.interceptors.addAll([UnauthorizedRequestInterceptor()]);

    if (kDebugMode) {
      dioClint.interceptors.add(PrettyDioLogger(
        requestBody: true,
        responseBody: true,
      ));
    }

    return dioClint;
  }

  Dio _dioClient() {
    final baseOptions = BaseOptions(
      baseUrl: AppApiEndPoint.baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: AppConstants.requestTimeoutAsSeconds,
      receiveTimeout: AppConstants.requestTimeoutAsSeconds,
    );

    return Dio(baseOptions);
  }
}
