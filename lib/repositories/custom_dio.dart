import 'package:api_via_cep_flutter/repositories/dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomDio {
  final _dio = Dio();

  Dio get dio => _dio;

  CustomDio() {
     _dio.options.headers["content-type"] = "application/json";
    _dio.options.baseUrl = dotenv.env['BACK4APPBASEURL']!;
    _dio.interceptors.add(DioInterceptor());
  }
}
